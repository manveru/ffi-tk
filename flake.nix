{
  description = "ffi-tk — Ruby FFI bindings for Tcl/Tk";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.git-hooks.flakeModule
      ];

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
            # treefmt-nix routes only *.rb to rubocop by default, which would
            # leave the Rakefile and tasks/*.rake unguarded -- exactly the files
            # that rotted before. rubocop's own default Include covers these, so
            # widen treefmt to match, keeping the gate and a bare `rubocop` run
            # in agreement.
            settings.formatter.rubocop = {
              includes = [
                "*.rb"
                "*.rake"
                "*.gemspec"
                "Rakefile"
                "Gemfile"
              ];
              # treefmt hands rubocop explicit paths; without --force-exclusion
              # rubocop ignores AllCops/Exclude for explicitly-passed files and
              # would lint the generated, excluded ffi-tk.gemspec (141 offenses).
              # This makes per-file runs honour Exclude like a bare `rubocop`.
              options = [ "--force-exclusion" ];
            };
          };

          # A git pre-commit hook that runs treefmt (rubocop + nix formatters)
          # over staged files and blocks the commit on any offense. This is what
          # keeps rubocop from silently rotting: it can no longer be skipped by
          # forgetting to run `nix flake check`. The hook's treefmt package is
          # auto-wired to the treefmt config above by the git-hooks flakeModule.
          # Installed into .git/hooks by the devShell shellHook below.
          pre-commit = {
            # Only install the local git hook; don't also add a hooks run to
            # `nix flake check` (treefmt-nix already provides that check, and
            # no CI runs it — this stays a purely local guardrail).
            check.enable = false;
            settings.hooks.treefmt.enable = true;
          };

          devShells.default = pkgs.mkShell {
            SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
            TCL_LIBPATH = "${pkgs.tcl}/lib/libtcl8.6.so";
            TK_LIBPATH = "${pkgs.tk}/lib/libtk8.6.so";

            # Installs the pre-commit hook into .git/hooks on shell entry.
            shellHook = config.pre-commit.installationScript;

            packages = [
              gems # rake, bacon, pry, ffi as bundle wrappers on PATH
              gems.wrappedRuby # `ruby`/`irb` that can require the bundled gems
              pkgs.pkg-config
              pkgs.tcl
              pkgs.tk
              pkgs.zip
              config.treefmt.build.wrapper # `treefmt` on PATH, same config as `nix fmt`
            ]
            # The spec runner (tasks/support/headless_display.rb) starts one
            # private Xvfb plus openbox per `rake`/`rake coverage` run, so the
            # suite is headless by default. A window manager is required, not
            # optional: the bind/event specs synthesise key events that only
            # reach a window with real keyboard focus. Set TK_SPEC_DISPLAY=:0
            # to watch the specs on the desktop instead.
            ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
              pkgs.xorg-server # Xvfb
              pkgs.openbox
              pkgs.xprop # WM-readiness probe in headless_display.rb
            ];
          };
        };
    };
}
