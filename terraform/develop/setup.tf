locals {
  backend_dir = abspath("${path.root}/../../../terraform")
  prefix      = basename(abspath(path.root))
}

terraform {
  backend "local" {
    path = "${local.backend_dir}/${local.prefix}.terraform.tfstate"
  }
}

provider "google" {
  version     = "~> 2.16"
  credentials = "${local.common.creds}"
  project     = "${var.project}"
  region      = "${var.region}"
  zone        = "${var.zone}"
}
