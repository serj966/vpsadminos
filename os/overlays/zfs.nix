self: super:
{
  zfs = super.zfsUnstable.overrideAttrs (oldAttrs: rec {
    name = "zfs-${version}";
    version = "0.8.z.vpsfree-storage-1910190";
    src = super.fetchFromGitHub {
      owner = "vpsfreecz";
      repo = "zfs";
      rev = "367f26ebcdc256524043f974f16430b5ce238a57";
      sha256 = "sha256:1n1d2jir196b3nk29nb4jh9k8kdycqbz2crzyq42v8nsf93a9vbj";
    };
  });
}
