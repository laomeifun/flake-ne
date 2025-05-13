# my-nix-config/system/my-nixos-machine/wsl.nix (WSL 配置)
{ config, pkgs, lib, inputs, ... }: # 'inputs' 这里指的是 flake 的 inputs
{
  imports = [
    ../my-nixos-machine/common.nix # 导入通用配置
    # inputs.nixos-wsl.nixosModules.default # 从 Flake 输入导入 NixOS-WSL 模块
  ];

  networking.hostName = "nixos-wsl"; # WSL 特定的主机名

  wsl.enable = true;
  wsl.defaultUser = "laomei"; # WSL 默认用户为 zero
  security.sudo.wheelNeedsPassword = false;
  wsl.wslConf = { # INI 文件节的属性集, 默认: { }
  automount = {
      enabled = true; # 布尔值, 默认: true. 自动在 /mnt 下挂载 Windows 驱动器。
      # ldconfig = false; # 布尔值, 默认: false. 是否修改 /etc/ld.so.conf.d/ld.wsl.conf 以加载 OpenGL 驱动程序。应改用 wsl.useWindowsDriver。
      # mountFsTab = false; # 布尔值, 默认: false. 通过 WSL 挂载 /etc/fstab 中的条目。
      # options = "metadata,uid=1000,gid=100"; # 以 "," 连接的字符串, 默认: "metadata,uid=1000,gid=100". Windows 驱动器的挂载选项。
      # root = "/mnt"; # 匹配模式 ^/(.*[^/])?$ 的字符串, 默认: "/mnt". 挂载 Windows 驱动器的目录。
    };
    boot = {
      # command = ""; # 字符串, 默认: "". 发行版启动时运行的命令。
      systemd = true; # 布尔值, 默认: true. 使用 systemd作为 init。禁用此选项可能会损坏您的 NixOS 安装。
    };
    interop = {
      enabled = true; # 布尔值, 默认: true. 支持从 Linux shell 运行 Windows 二进制文件。
      appendWindowsPath = true; # 布尔值, 默认: true. 在 PATH 变量中包含 Windows PATH。
    };
    network = {
      generateHosts = true; # 布尔值, 默认: true. 通过 WSL 生成 /etc/hosts。
      generateResolvConf = true; # 布尔值, 默认: true. 通过 WSL 生成 /etc/resolv.conf。
      # hostname = "config.networking.hostName"; # 字符串, 默认: "config.networking.hostName". WSL 实例的主机名。
    };
    user = {
      default = "laomei"; # 字符串, 默认: "root". 在此 WSL 发行版中以哪个用户身份启动命令。
    };
  };
  # WSL 特定的系统级 Zsh 设置
  # 如果 Home Manager 为 zero 用户管理 Zsh，这里的配置主要是为系统提供 zsh 包
  # 或者为其他潜在的 WSL 用户提供一个基础 Zsh 环境。
  # 对于 zero 用户，Home Manager 的配置会优先。
  programs.zsh.enable = true; # 确保 zsh 模块被启用，以便 pkgs.zsh 可用

  # WSL 特定的软件包
  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs.nix-ld-rs;
  wsl.useWindowsDriver = true; # 布尔值, 默认: false. 是否启用来自 Windows 主机的 OpenGL 驱动程序。
  # WSL 可能需要覆盖 common.nix 中的某些 systemPackages 或添加额外的
  # environment.systemPackages = with pkgs; (config.environment.systemPackages ++ [
  #   # WSL 特有的额外包
  # ]);

  # WSL 特定的 stateVersion (如果不同于 common.nix)
  # system.stateVersion = "24.11"; # 例如，如果 WSL 环境基于不同版本初始化
}
