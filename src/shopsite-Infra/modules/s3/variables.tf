variable "env" {
    description = "Environment name"
    type = string


validation {
    condition = contains(["dev", "prod"], var.env)
    error_message = "env must be dev or prod"
}
}
