{
  concurrent-ruby = {
    source = {
      remotes = ["https://rubygems.vpsfree.cz"];
      sha256 = "183lszf5gx84kcpb779v6a2y0mx9sssy8dgppng1z9a505nj1qcf";
      type = "gem";
    };
    version = "1.0.5";
  };
  ipaddress = {
    source = {
      remotes = ["https://rubygems.vpsfree.cz"];
      sha256 = "1x86s0s11w202j6ka40jbmywkrx8fhq8xiy8mwvnkhllj57hqr45";
      type = "gem";
    };
    version = "0.8.3";
  };
  json = {
    source = {
      remotes = ["https://rubygems.vpsfree.cz"];
      sha256 = "01v6jjpvh3gnq6sgllpfqahlgxzj50ailwhj9b3cd20hi2dx0vxp";
      type = "gem";
    };
    version = "2.1.0";
  };
  libosctl = {
    dependencies = ["rake" "yard"];
    source = {
      remotes = ["https://rubygems.vpsfree.cz"];
      sha256 = "1r8mcsvvcnvyyr61pv0zfnan05s17ha5yp3nkycxi97wp78cya8k";
      type = "gem";
    };
    version = "0.1.0.build20180216153209";
  };
  osctld = {
    dependencies = ["concurrent-ruby" "ipaddress" "json" "libosctl" "rake" "ruby-lxc" "yard"];
    source = {
      remotes = ["https://rubygems.vpsfree.cz"];
      sha256 = "19qchivrg59mnh4707pls3bkcsjc57c6nxla3qgw4grsdb1k6waj";
      type = "gem";
    };
    version = "0.1.0.build20180216153209";
  };
  rake = {
    source = {
      remotes = ["https://rubygems.vpsfree.cz"];
      sha256 = "190p7cs8zdn07mjj6xwwsdna3g0r98zs4crz7jh2j2q5b0nbxgjf";
      type = "gem";
    };
    version = "12.3.0";
  };
  ruby-lxc = {
    source = {
      remotes = ["https://rubygems.vpsfree.cz"];
      sha256 = "1n2yf4mi1y6r44hd3bxsj0qfys26s8p3lnr11cb5l9ajm05f7gnm";
      type = "gem";
    };
    version = "1.2.2";
  };
  yard = {
    source = {
      remotes = ["https://rubygems.vpsfree.cz"];
      sha256 = "11x58w0ccayvgy0lmhfyrzxd33ya1v41prh5zzhvaajhw8vr74lh";
      type = "gem";
    };
    version = "0.9.12";
  };
}