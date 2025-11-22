{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ parts, ... }:
    parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem =
        { pkgs, ... }:
        let
          beamPackages = pkgs.beam_minimal.packages.erlang_28;
          elixir = beamPackages.elixir_1_19;
        in
        {
          devShells = {
            default = pkgs.mkShell {
              packages = [ elixir ];

              env = {
                MIX_OS_DEPS_COMPILE_PARTITION_COUNT = "16";
                ERL_AFLAGS = "+pc unicode -kernel shell_history enabled";
                ELIXIR_ERL_OPTIONS = "+fnu +sssdio 128";
              };
            };
          };
        };
    };
}
