{ indexState, pkgs, ... }:

let
  libOverlay = { lib, pkgs, ... }:
    {

    };

  shell = { pkgs, ... }: {
    tools = {
      cabal = { index-state = indexState; };
      cabal-fmt = { index-state = indexState; };
      haskell-language-server = { index-state = indexState; };
      hoogle = { index-state = indexState; };
      fourmolu = { index-state = indexState; };
      hlint = { index-state = indexState; };
    };
    withHoogle = true;
    buildInputs = [
      pkgs.gitAndTools.git
      pkgs.just
      pkgs.nixfmt-classic

    ];
    shellHook = ''
      echo "Entering shell for sparse-merkle-tree development"
    '';
  };

  mkProject = ctx@{ lib, pkgs, ... }: {
    name = "sparse-merkle-trees";
    src = ./..;
    compiler-nix-name = "ghc984";
    shell = shell { inherit pkgs; };
    modules = [ libOverlay ];
  };
  project = pkgs.haskell-nix.cabalProject' mkProject;

in {
  devShells.default = project.shell;
  packages.sparse-merkle-trees = project.hsPkgs.sparse-merkle-trees.components.library;
  inherit project;
}
