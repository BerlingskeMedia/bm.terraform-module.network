variable "region" {
  type        = string
  description = "AWS Region for S3 bucket"
}

variable "vpc_id" {
  type        = string
  description = "ID of vpc for this infrastructure"
}

variable "app_cidr" {
  type        = string
  description = "The CIDR range within all subnets will be created (at least mask 24)"
}

variable "igw_id" {
  type        = string
  description = "Internet Gateway ID"
}

variable "nat_id" {
  type        = string
  description = "NAT Gateway ID"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "namespace" {
  type        = string
  description = "Namespace (e.g. `eg` or `cb`)"
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `production`, `testing`, `staging`)"
}

variable "name" {
  type        = string
  description = "Name of the application"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (_e.g._ { BusinessUnit : ABC })"
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
