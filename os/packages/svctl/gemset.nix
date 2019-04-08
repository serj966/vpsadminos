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
      sha256 = "0qh56sqb4p1yr48hf5v1gbpmg4ri056w5qd0xi8zpv8kflmpn5nl";
      type = "gem";
    };
    version = "19.03.0.build20190408174653";
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
      sha256 = "10pjjd7s7akw6yxgf9sx7ibp13fj7rzlhhikv5ygbqm0b842a5xr";
      type = "gem";
    };
    version = "19.03.0.build20190408174653";
  };
}