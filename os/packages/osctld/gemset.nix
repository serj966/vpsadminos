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
      sha256 = "155f5050m1lzv3bir62r4gbvrx2chnrmj2229q9n8shcglgqpjhm";
      type = "gem";
    };
    version = "0.1.0.build20180216145345";
  };
  osctld = {
    dependencies = ["concurrent-ruby" "ipaddress" "json" "libosctl" "rake" "ruby-lxc" "yard"];
    source = {
      remotes = ["https://rubygems.vpsfree.cz"];
      sha256 = "0si6kn37n97nkx52gpsd82mal3f2r1spzcvqzad2kmlm4jj02q00";
      type = "gem";
    };
    version = "0.1.0.build20180216145345";
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