terraform {
  cloud {
    organization = "christerbeke-binx"

    workspaces {
      name = "terraform-playground"
    }
  }
}
