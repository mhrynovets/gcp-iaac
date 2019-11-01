output "public-key" {
  value = "${tls_private_key.key-pair.public_key_openssh}"
}

output "private-key-location" {
  value = "${local_file.sshkey.filename}"
}

output "data" {
  value = flatten([
    {
      key  = tls_private_key.key-pair.public_key_openssh,
      name = var.ssh_username
    },
    var.attach-external
  ])
}

