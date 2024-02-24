#!/bin/bash

# (JW) so code generators are not my favorite thing but apparently lots of people like them, especially for onboarding. so here we go.

usage="bash create_claro_project.sh <project name>"

if [ "$1" = "" ]; then
  echo "$usage"
  exit 1
fi

if [ -d "$1" ]; then
  echo "Requested project dir \"$1\" already exists!"
  echo "Exiting."
  exit 1
fi

dest="$1"
mkdir -p "$dest"
mkdir -p "$dest/example"

# .bazelrc
echo 'common --enable_bzlmod
common --java_runtime_version=remotejdk_11
' > "$dest/.bazelrc"

# .bazelversion
echo '6.4.0' > "$dest/.bazelversion"

# MODULE.bazel
echo 'module(name = "example-claro-module")

bazel_dep(name = "claro-lang", version = "0.1.409")

' > "$dest/MODULE.bazel"

# BUILD
echo "load(\"@claro-lang//:rules.bzl\", \"claro_binary\")

claro_binary(
  name = \"$1_bin\",
  main_file = \"$1.claro\",
  resources = {
    \"Input\": \"input.txt\",
  }
)" > "$dest/example/BUILD"

# input.txt
echo -n "
look ma, no hands!
" > "$dest/example/input.txt"

# claro file
echo -n 'resources::Input
  |> files::readOrPanic(^)
  |> strings::trim(^)
  |> strings::toUpperCase(^)
  |> wrapInBox(^)
  |> print(^);

function wrapInBox(s: string) -> string {
  var line = strings::repeated("-", len(s) + 4);
  return "{line}\n| {s} |\n{line}";
}' > "$dest/example/$1.claro"

# README.md
echo "# Run these commands from some dir in the project tree.
bazel build //example:$1_bin
bazel run //example:$1_bin" > "$dest/README.md"

cat "$dest/README.md"

