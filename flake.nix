{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      nixpkgs,
      nixos-generators,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        packages = {
          amazon = nixos-generators.nixosGenerate {
            inherit system;
            specialArgs = {
              inherit nixpkgs;
            };
            modules = [
              ./configuration.nix
              # https://github.com/nix-community/nixos-generators/issues/150#issuecomment-2037085609
              (
                { ... }:
                {
                  amazonImage.sizeMB = 16 * 1024;
                }
              )
            ];
            format = "amazon";
          };
        };
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ terraform ];
          shellHook = ''
            source .env
          '';
        };
        formatter = pkgs.nixfmt;
      }
    );
}
