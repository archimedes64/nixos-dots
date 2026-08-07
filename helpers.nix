{lib, ...}: 
rec {
  mkOptionalOption = type: description: lib.mkOption {
    type = lib.types.nullOr type;
    description = description;
    default = null;
  };
  notNull = val: (val != null);
  addAttrIfNotNull = val: attr: lib.optionalAttrs (notNull val) attr;
}
