_: {
  boot.kernelParams = [
    "transparent_hugepage=never"
  ];
  boot.kernelModules = [ "tcp_bbr" ];

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 1048576; # 1GB

    "net.core.default_qdisc" = "cake";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_window_scaling" = 1;
  };
}
