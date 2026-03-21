terraform {
    backend "s3" {
        bucket = "terraform-state-868550873443"
        key = "shopsite/terraform.tfstate"
        region = "ap-south-1"
        encrypt = true
        use_lockfile = true
    }
}