{ config, lib, helpers, pkgs, ... }: 
let
  
  mkOptionalOption = helpers.mkOptionalOption;
  notNull = helpers.notNull;
  
  formatOption = field: value: (field + "  " + "${toString value}\n"); boolToStr = bool: (if bool then "enable" else "disable");
  ifSet = field: value: if notNull value then (formatOption field value) else "";
  cfg = config.usr.sway.swayfx;
in
{
  options.usr.sway.swayfx = with lib; {
    enable = mkEnableOption "swayfx";
    
    blur = {
      enable = mkEnableOption "blur";
      enableXray = mkEnableOption "blur xray.";
      passes = mkOptionalOption types.ints.between 0 10 "The number of passes (int 0 - 10).";
      radius = mkOptionalOption types.ints.between 0 10 "The radius of the blur (int 0 - 10)."; 
      noise  = mkOptionalOption types.numbers.between 0 1 "The amount of noise (float 0 - 1).";
      brightness = mkOptionalOption types.numbers.between 0 2 "Brightness of the blur (float 0 - 2)."; 
      contrast = mkOptionalOption types.numbers.between 0 2 "Contrast of the blur (float 0 - 2).";
      saturation = mkOptionalOption types.numbers.between 0 2 "Saturation of the blur (float 0 - 2).";
    };
    
    shadows = {
      enable = mkEnableOption "shadows";
      color = mkOptionalOption types.str "The color of shadows (hex code)."; 
      inactiveColor = mkOptionalOption types.str "The color of inactive shadows (hex code).";

      onCsd = mkEnableOption "Shadows on CSD";
      blurRadius = mkOptionalOption types.ints.between 0 99 "The blur radius of the shadow (int 0 - 99).";

      offsetY = mkOptionalOption types.number "Y offset of the shadow (float)." ;
      offsetX = mkOptionalOption types.number "X offset of the shadow (float).";
    };

    cornerRadius = mkOptionalOption  types.int "Radius of window corners (int).";

    extraConfig =  mkOptionalOption  types.str "Extra configuration options (str).";

    extraConfigOverride = mkOptionalOption types.str "Override the swayfx specific config (str).";
  };

  config = lib.mkIf cfg.enable (
  let
    blurConfig = if cfg.blur.enable
    then 
      formatOption "blur" (boolToStr cfg.blur.enable)
    + formatOption "blur_xray" (boolToStr cfg.blur.enableXray)
    + ifSet "blur_passes" cfg.blur.passes
    + ifSet "blur_radius" cfg.blur.radius
    + ifSet "blur_noise" cfg.blur.noise
    + ifSet "blur_brightness" cfg.blur.brightness
    + ifSet "blur_contrast" cfg.blur.contrast
    + ifSet "blur_saturation" cfg.blur.saturation
    else "";
    
    shadowOffsetX = if notNull cfg.shadows.offsetX then toString cfg.shadows.offsetX else "0";
    shadowOffsetY = if notNull cfg.shadows.offsetY then toString cfg.shadows.offsetY else "0";
    shadowOffset  = "${shadowOffsetX} ${shadowOffsetY}";

    shadowsConfig = if cfg.shadows.enable
    then
      formatOption "shadows" (boolToStr cfg.shadows.enable)
    + ifSet "shadow_color" cfg.shadows.color
    + ifSet "shadow_inactive_color" cfg.shadows.inactiveColor
    + ifSet "shadows_on_csd" (boolToStr cfg.shadows.onCsd)
    + ifSet "shadow_blur_radius" cfg.shadows.blurRadius
    + formatOption "shadow_offset" shadowOffset
    else "";

    extraConf = if notNull cfg.extraConfig then cfg.extraConfig else "";

    cornerConfig = ifSet "corner_radius" cfg.cornerRadius;
  in
   
  {
    wayland.windowManager.sway = {
      package = lib.mkForce pkgs.swayfx;
      checkConfig = lib.mkForce false; # otherwise errors will be thrown      
      
      extraConfig = lib.mkAfter (
        if notNull cfg.extraConfigOverride
        then cfg.extraConfigOverride 
        else (blurConfig + shadowsConfig + extraConf + cornerConfig)
      );
    };
  });

}
