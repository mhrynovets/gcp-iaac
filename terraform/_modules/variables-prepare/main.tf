variable "path" {
  description = "Path (path.root) of parent workspace"
  type        = string
}


output "path" {
  value = {
    dir          = basename(abspath(var.path))
    project_root = abspath("${var.path}/../..")
    terraform    = abspath("${var.path}/../../terraform")
    ansible      = abspath("${var.path}/../../ansible")
    creds        = abspath("${var.path}/../../../terraform/creds/cred.json")
  }
}
