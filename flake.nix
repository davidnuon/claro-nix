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
          pkgs.bazelisk
          pkgs.jdk11
          pkgs.glibc
          pkgs.gcc
          pkgs.zlib.dev
          pkgs.zlib.out
        ];
      })
      .env;
  };
}
