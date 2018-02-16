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
    dependencies = ["yard"];
    source = {
      remotes = ["https://rubygems.vpsfree.cz"];
      sha256 = "1mqw2pdrl7m32r7gilfx3w2ssp0702x139kbsg43yh58dmxvfa3z";
      type = "gem";
    };
    version = "0.1.0.build20180216125625";
  };
  osctld = {
    dependencies = ["concurrent-ruby" "ipaddress" "json" "libosctl" "ruby-lxc" "yard"];
    source = {
      remotes = ["https://rubygems.vpsfree.cz"];
      sha256 = "10b5fw32pfgibyqd459x32v4vng6n2z276ms5ffgnm939ki139ff";
      type = "gem";
    };
    version = "0.1.0.build20180216125625";
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