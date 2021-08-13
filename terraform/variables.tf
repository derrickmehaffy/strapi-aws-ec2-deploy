variable "aws_access_key" {
  type        = string
  description = "AWS Access Key."
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key."
}

variable "ssh_key" {
  type        = string
  description = "The new SSH key you generated with ssh-keygen."
}

variable "region" {
  type        = string
  description = "The physical location of the resources."
  default     = "us-west-2"
}

variable "availability_zone" {
  type        = string
  description = "The availability zone used in the region selected."
  default     = "us-west-2a"
}

variable "cloudflare_enabled" {
  type        = bool
  description = "Define if Cloudflare records should be created."
  default     = true
}

variable "cloudflare_email" {
  type        = string
  description = "Email Address used for Cloudflare account."
  default     = "test@test.com"
}

variable "cloudflare_api_key" {
  type        = string
  description = "Cloudflare API Key used to create DNS records."
  default     = "12345abc"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare Zone ID to use for record creation."
  default     = ""
}

variable "strapi_srv_domain" {
  type        = string
  description = "Subdomain used for the Strapi Server."
  default     = "api"
}

variable "strapi_vpc_name" {
  type        = string
  description = "The name of the Strapi VPC."
  default     = "strapi_vpc_main"
}

variable "strapi_vpc_cidr_block" {
  type        = string
  description = "The CIDR Block assigned to the VPC"
  default     = "10.0.0.0/16"
}

variable "strapi_subnet_name" {
  type        = string
  description = "The name of the Strapi Subnet."
  default     = "strapi_subnet_main"
}

variable "strapi_subnet_cidr_block" {
  type        = string
  description = "The CIDR Block assigned to the Subnet"
  default     = "10.0.1.0/24"
}

variable "strapi_gateway_name" {
  type        = string
  description = "The name of the Strapi Internet Gateway."
  default     = "strapi_gw_main"
}

variable "strapi_plan" {
  type        = string
  description = "The size of the AWS EC2 strapi instance"
  default     = "t2.medium"
}

variable "strapi_label" {
  type        = string
  description = "The label assigned to the strapi instance"
  default     = "my-strapi-srv"
}

variable "database_plan" {
  type        = string
  description = "The size of the AWS EC2 database instance"
  default     = "t2.medium"
}

variable "database_label" {
  type        = string
  description = "The label assigned to the database instance"
  default     = "my-strapi-db"
}
