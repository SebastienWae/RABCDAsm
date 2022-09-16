{
  description = "nix shell  RABCDAsm";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, flake-utils, devshell, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShell =
        let pkgs = import nixpkgs {
          inherit system;
          overlays = [ devshell.overlay ];
        };
        in
        pkgs.devshell.mkShell {
          name = "RABCDAsm";
          packages = with pkgs; [
            dtools
            dmd
          ];
          env = [
            {
              name = "DCFLAGS";
              value = "-O -inline -L=-L${pkgs.xz.out}/lib";
            }
          ];
          commands = [ ];
        };
    });
}
