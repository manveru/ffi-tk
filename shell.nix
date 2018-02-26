with (import <nixpkgs> {});
let
  ruby = (ruby_2_4.override { useRailsExpress = false; });
  gems = pkgs.bundlerEnv { name = "ffi-tk-gems"; inherit ruby; gemdir = ./.; };
  bundler = pkgs.bundler.override { inherit ruby; };
  bundix = pkgs.bundix.override { inherit bundler; };
in stdenv.mkDerivation rec {
  name = "ffi-tk";
  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  TCL_LIBPATH = "${tcl-8_6}/lib/libtcl8.6.so";
  TK_LIBPATH = "${tk}/lib/libtk8.6.so";
  buildInputs = [
    bashInteractive
    pkgconfig
    ruby bundler bundix gems
    tcl-8_6 tk
    zip
  ];
}
