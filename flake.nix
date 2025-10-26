{
  description = "Illogical Impulse - Home-manager module for end-4's Hyprland dotfiles with QuickShell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "github:HynDuf/dots-hyprland";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, quickshell, nur, dotfiles, ... }:
    let
      flakeInputs = { inherit quickshell nur dotfiles; };
    in {
      homeManagerModules.default = { config, lib, pkgs, ... }: (import ./home-module.nix) {
        inherit config lib pkgs;
        inputs = flakeInputs;
      };
      homeManagerModules.illogical-flake = self.homeManagerModules.default;
    };
}
