vpsadmin: self: super:
{
  libnodectld = super.callPackage "${vpsadmin}/packages/libnodectld" {};
  nodectld = super.callPackage "${vpsadmin}/packages/nodectld" {};
  nodectl = super.callPackage "${vpsadmin}/packages/nodectl" {};
  vpsadmin.core.node = { ... }@args:
    super.beam.packages.erlangR21.callPackage "${vpsadmin}/packages/core/generic.nix" args;
}
