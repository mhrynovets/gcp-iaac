resource "tls_private_key" "key-pair" {
  algorithm = "${var.ssh-algorithm}"
}

resource "local_file" "sshkey" {
  sensitive_content = "${tls_private_key.key-pair.private_key_pem}"
  filename          = "${var.ssh-private-key-location}"
  file_permission   = "${var.ssh-private-key-perm}"
}

