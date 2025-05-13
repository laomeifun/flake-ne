# home/laomei/home.nix
# IMPORTANT: This file was copied from home/zero/home.nix.
# Please review and update user-specific settings,
# especially programs.git.userName and programs.git.userEmail,
# to match the user "laomei".

{ config, pkgs, inputs, username, ... }: # 'inputs' 和 'username' 从 specialArgs 传入

{
  # Home Manager 需要知道这个配置是给哪个用户的。
  home.username = "${username}"; # 使用从 flake 传递过来的 username
  home.homeDirectory = "/home/${username}";

  # Nixpkgs 配置 (当 useGlobalPkgs = true 时，此部分应在系统级别配置)
  # nixpkgs.config = {
  #   allowUnfree = true;
  #   # 你可以在这里添加其他的 nixpkgs 配置，例如 overlays
  # };

  # 安装的软件包
  home.packages = with pkgs; [
    # 开发工具
    git
    # vscode

    # Shell 工具
    zsh
    oh-my-zsh # 如果你使用 oh-my-zsh，需要额外配置
    fzf
    ripgrep
    fd


    # # 常用工具
    # firefox
    # htop
    curl
    wget
    
    #python
    python3
    uv
    nixfmt-classic # Renamed from nixfmt
    # # (可选) Nix 相关工具
    # nix-output-monitor # nom

    zed-editor
  ];

  # Shell 配置 (以 Zsh 为例)
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    # 你可以在这里添加更多的 Zsh 配置，例如插件、别名等
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "fzf" ];
      theme = "robbyrussell";
    };
    # shellAliases = {
    #   ll = "ls -l";
    #   update = "sudo nixos-rebuild switch --flake .#my-nixos-machine && home-manager switch --flake .#${username}";
    # };
  };

  # Git 配置
  programs.git = {
    enable = true;
    userName = "laomei"; # !!! IMPORTANT: Change this to "laomei" or desired git username
    userEmail = "laomei@laomei.site"; # !!! IMPORTANT: Change this to "laomei's" email
    extraConfig = {
      init.defaultBranch = "main";
      # 你可以在这里添加更多的 Git 配置
      # 例如，如果你想使用存储在其他地方的 .gitconfig 内容：
      # core.excludesfile = "${config.home.homeDirectory}/.gitignore_global";
    };
    # 如果你想管理一个 .gitconfig 文件，可以这样做：
    # configFilePath = "${config.home.homeDirectory}/.gitconfig"; # Home Manager 会创建这个文件
    # 或者，如果你有一个现有的 .gitconfig 文件想让 Home Manager 管理，
    # 你可以把它放在 `home.file` 中，并在这里只设置 userName 和 userEmail。
  };

  # 其他程序配置 (示例)
  programs.neovim = {
    enable = true;
    # 你可以在这里添加 Neovim 的插件和配置
  };





  # 设置状态版本，这对于确保配置的向后兼容性很重要。
  # 通常设置为你开始使用 Home Manager 时的版本。
  home.stateVersion = "25.05"; # 或者你当前使用的 Home Manager 版本
} 