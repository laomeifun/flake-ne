# my-nix-config/flake.nix
{
  description = "My NixOS and Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # (可选) 如果你需要其他 Flake 作为输入
    # another-flake.url = "github:some/flake";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs"; # 确保它使用与我们相同的 nixpkgs
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-wsl, ... }@inputs:
    let
      # --- 通用设置 ---
      username = "laomei"; # Home Manager 用户名
      system = "x86_64-linux"; # 目标系统架构

      # 创建一个 pkgs 实例，方便在各处使用
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; }; # 在这里设置 allowUnfree
      };

      # Home Manager 模块的通用部分，用于 NixOS 集成
      homeManagerNixosModule = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs username pkgs; }; # 传递 pkgs
        home-manager.users.${username} = import ./home/${username}/home.nix;
      };

    in
    {
      # --- NixOS 系统配置 ---
      nixosConfigurations = {
        "nixos-pc" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username pkgs; }; # 传递 pkgs 给模块
          modules = [
            ./system/nixos-pc/configuration.nix # 普通 PC 的主配置
            home-manager.nixosModules.home-manager     # 集成 Home Manager
            homeManagerNixosModule                     # 应用 Home Manager 用户配置
          ];
        };

        "nixos-wsl" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username pkgs; }; # 重新传递 pkgs 给模块
          modules = [
            # inputs.nixpkgs.nixosModules.readOnlyPkgs # Remains commented out
            { nixpkgs.pkgs = pkgs; }                 # Uncommented, restored
            inputs.nixos-wsl.nixosModules.default
            ./system/nixos-wsl/wsl.nix
            home-manager.nixosModules.home-manager
            homeManagerNixosModule                     # 应用 Home Manager 用户配置
          ];
        };
      };

      # --- Home Manager 独立配置 (可选) ---
      # 如果你想单独构建和切换 Home Manager 配置，不通过 NixOS 系统配置
      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs; # 使用上面定义的 pkgs
        modules = [ ./home/${username}/home.nix ];
        extraSpecialArgs = { inherit inputs username pkgs; }; # 传递 pkgs
      };

      # Configuration for user laomei
      homeConfigurations."laomei" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/laomei/home.nix ];
        extraSpecialArgs = { inherit inputs pkgs; username = "laomei"; }; # Pass username "laomei"
      };
    };
}
