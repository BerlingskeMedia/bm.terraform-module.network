variable "region" {
  type        = string
  description = "AWS Region for S3 bucket"
  default     = ""
}

variable "vpc_id" {
  type        = string
  description = "ID of vpc for this infrastructure"
  default     = "vpc-00f92d0d578c6a298"
}

variable "app_cidr" {
  type        = string
  description = "The CIDR range within all subnets will be created (at least mask 24)"
  default     = ""
}

variable "igw_id" {
  type        = string
  description = "Internet Gateway ID"
  default     = ""
}

variable "nat_id" {
  type        = string
  description = "NAT Gateway ID"
  default     = ""
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
  default     = []
}

variable "namespace" {
  type        = string
  description = "Namespace (e.g. `eg` or `cb`)"
  default     = ""
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `production`, `testing`, `staging`)"
  default     = ""
}

variable "name" {
  type        = string
  description = "Name of the application"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (_e.g._ { BusinessUnit : ABC })"
  default     = {}
}

variable "priv1_cidr" {
  type        = string
  default     = ""
  description = "[optional] Manualy set CIDR for private network in AZ 1"
}
variable "priv2_cidr" {
  type        = string
  default     = ""
  description = "[optional] Manualy set CIDR for private network in AZ 2"
}
variable "pub1_cidr" {
  type        = string
  default     = ""
  description = "[optional] Manualy set CIDR for public network in AZ 1"
}
variable "pub2_cidr" {
  type        = string
  default     = ""
  description = "[optional] Manualy set CIDR for public network in AZ 2"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter between `namespace`, `stage`, `name` and `attributes`"
  #sane default
}

variable "attributes" {
  type        = list(string)
  description = "Additional attributes (_e.g._ \"1\")"
  default     = []
  #sane default
}

variable "enabled" {
  type    = bool
  default = false
}