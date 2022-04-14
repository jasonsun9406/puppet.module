class linux_mgmt {
  sudo::conf { "admin":
      priority => 10,
      content  => "%jenkins ALL=(ALL) NOPASSWD: ALL",
    }
}