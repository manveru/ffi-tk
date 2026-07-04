{
  description = "ffi-tk — Ruby FFI bindings for Tcl/Tk";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.treefmt-nix.flakeModule ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        { config, pkgs, ... }:
        let
          ruby = pkgs.ruby_4_0;
          bundler = pkgs.bundler.override { inherit ruby; };
          bundix = pkgs.bundix.override { inherit bundler; };
        in
        {
          # `nix fmt` and `nix flake check` both drive this.
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              # Nix
              nixfmt.enable = true;
              deadnix.enable = true;
              statix.enable = true;
              # Ruby
              rubocop.enable = true;
            };
          };

          devShells.default = pkgs.mkShell {
            SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
            TCL_LIBPATH = "${pkgs.tcl}/lib/libtcl8.6.so";
            TK_LIBPATH = "${pkgs.tk}/lib/libtk8.6.so";

            packages = [
              ruby
              bundler
              bundix
              pkgs.rubocop
              pkgs.pkg-config
              pkgs.tcl
              pkgs.tk
              pkgs.zip
              config.treefmt.build.wrapper # `treefmt` on PATH, same config as `nix fmt`
            ];
          };
        };
    };
}
