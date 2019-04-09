{
  gli = {
    source = {
      remotes = ["https://rubygems.vpsfree.cz"];
      sha256 = "1sgfc8czb7xk0sdnnz7vn61q4ixbkrpz2mkvcgchfkll94rlqhal";
      type = "gem";
    };
    version = "2.17.2";
  };
  libosctl = {
    dependencies = ["require_all"];
    source = {
      remotes = ["https://rubygems.vpsfree.cz"];
      sha256 = "0pw1rdgbf1jypm5jgz47m7vi66ks74hnmrxz0x0s8jjy4f2ksvs4";
      type = "gem";
    };
    version = "19.03.0.build20190409164131";
  };
  require_all = {
    source = {
      remotes = ["https://rubygems.vpsfree.cz"];
      sha256 = "0sjf2vigdg4wq7z0xlw14zyhcz4992s05wgr2s58kjgin12bkmv8";
      type = "gem";
    };
    version = "2.0.0";
  };
  svctl = {
    dependencies = ["gli" "libosctl"];
    source = {
      remotes = ["https://rubygems.vpsfree.cz"];
      sha256 = "0j6d4gf6fwsgy10dci7d6rdzcgy26ag75zvdsm9qxdz3ykrcrxgp";
      type = "gem";
    };
    version = "19.03.0.build20190409164131";
  };
}