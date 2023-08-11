with (import <nixpkgs> {});
let
  gems = bundlerEnv {
    name = "sedemnajst-gems";
    inherit ruby;
    gemdir = ./.;
  };
in mkShell {
  packages = [ gems gems.wrappedRuby nodejs yarn vips libjpeg postgresql ];
}
