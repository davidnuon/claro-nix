{...}:
let 
  unstableTarball =
    fetchTarball
       https://github.com/NixOS/nixpkgs/archive/master.tar.gz;

  pkgs = import unstableTarball {};
in
(pkgs.buildFHSEnv {
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
.env
