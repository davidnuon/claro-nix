{
  description = "davidnuon's NixOS configuration";
  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: {
    devShells."x86_64-linux".default = let
      pkgs = import inputs.nixpkgs-unstable {
        system = "x86_64-linux";
      };
    in
      (pkgs.buildFHSUserEnv {
        name = "bazel-userenv-example";
        targetPkgs = pkgs: [
          # Use Bazelisk to manage Bazel install
          pkgs.bazelisk

          # Bazel depdencies
          pkgs.glibc
          pkgs.gcc

          # Claro Java Depdencies
          pkgs.zlib.dev
          pkgs.zlib.out
        ];
      })
      .env;
  };
}
