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
          # Gems come from bundlerEnv so the ruby-4.0 gem environment stays
          # clean. Keep bundler/bundix/rubocop OUT of the shell: bundler and
          # bundix ship gems that shadow ruby 4.0's own, and rubocop is built
          # against ruby 3.4 — mixing either into GEM_PATH breaks native
          # extensions and bundler. rubocop is reached via treefmt instead.
          gems = pkgs.bundlerEnv {
            name = "ffi-tk-gems";
            inherit ruby;
            gemdir = ./.;
          };
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
              gems # rake, bacon, pry, ffi as bundle wrappers on PATH
              gems.wrappedRuby # `ruby`/`irb` that can require the bundled gems
              pkgs.pkg-config
              pkgs.tcl
              pkgs.tk
              pkgs.zip
              config.treefmt.build.wrapper # `treefmt` on PATH, same config as `nix fmt`
            ];
            # The specs need an X display and use `rake`. Locally they run
            # against the ambient $DISPLAY. Headless CI would need not just Xvfb
            # but a window manager — the bind/event specs synthesise key events
            # that require real keyboard focus — so that is a deliberate CI
            # concern, not a dev-shell dependency.
          };
        };
    };
}
