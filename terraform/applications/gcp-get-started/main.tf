terraform {
  backend "remote" {
    organization = "christerbeke-binx"
    workspaces {
      name = "gcp-get-started"
    }
  }
}
