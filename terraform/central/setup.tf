
# terraform {
#   backend "local" {
#     path = "${abspath("${path.root}/../../../terraform")}/${basename(abspath(path.root))}.terraform.tfstate"
#   }
# }

provider "google" {
  version     = "~> 2.16"
  credentials = "${local.common.creds}"
  project     = "${var.project}"
  region      = "${var.region}"
  zone        = "${var.zone}"
}
