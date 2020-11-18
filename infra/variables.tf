variable "namespace" {
  type = string
}

variable "app_image" {
  type = string
}

variable "app_version" {
  type = string
}

variable "domain" {
  type = string
}

variable "wiki_secret" {
  type = string
  default = "wiki-secrets"
}

variable "db_type" {
  type = string
  default = "postgres"
}

variable "db_name" {
  type = string
  default = "mw_wodsonck"
}

variable "db_schema" {
  type = string
  default = "mediawiki"
}

variable "ssh_host" {
  type = string
}

variable "environment" {
  type = string
}

variable "gitlab_app" {
  type = string
}