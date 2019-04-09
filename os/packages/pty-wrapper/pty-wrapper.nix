{ mkDerivation, aeson, async, base, base64-bytestring, bytestring
, fetchgit, network, posix-pty, stdenv, stm, text
}:
mkDerivation {
  pname = "pty-wrapper";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/vpsfreecz/pty-wrapper";
    sha256 = "16byw4jf3b3gz3skwkxhrnbw8n9jz499s0z8vfn2dp49aa3gc357";
    rev = "42be234da6e31ed2dcd05aea7e71f824d5d8ee9c";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson async base base64-bytestring bytestring network posix-pty stm
    text
  ];
  executableHaskellDepends = [ base bytestring ];
  homepage = "https://github.com/vpsfreecz/pty-wrapper";
  description = "PTY wrapper";
  license = stdenv.lib.licenses.bsd3;
}
