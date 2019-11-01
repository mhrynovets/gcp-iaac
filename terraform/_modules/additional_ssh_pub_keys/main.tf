variable "key_path" {
  description = "Path of directory, where public ssh keys (*.pub) are stored"
  type        = string
}

# join(" ", slice(split(" ", "algo key comment"), 0, 2))

output "data" {
  value = [
    for item in fileset(var.key_path, "*.pub") : {
      name     = split(".pub", basename(item))[0]
      location = "${abspath(var.key_path)}/${item}",
      key      = join(" ", slice(split(" ", chomp(file("${abspath(var.key_path)}/${item}"))), 0, 2))
    }
  ]
}
