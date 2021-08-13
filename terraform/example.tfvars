###################
# Global Settings #
###################
# AWS Keys
aws_access_key = "your_access_key"
aws_secret_key = "your_secret_key"

# SSH Keys
ssh_key = "ssh-rsa your-ssh-key you@your-host"

# See the following API for Regions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html#Concepts.RegionsAndAvailabilityZones.Regions
region            = "us-west-2" # US West (Oregon)
availability_zone = "us-west-2a"

#######################
# Cloudflare Settings #
#######################
# DO NOT DISABLE, no cloudflare support is WIP
cloudflare_enabled = true
cloudflare_email   = "test@test.com"
cloudflare_api_key = "abc123"
cloudflare_zone_id = "abc123"
strapi_srv_domain  = "api-test"

####################
# Network Settings #
####################

# VPC Settings
strapi_vpc_name       = "strapi_vpc_main"
strapi_vpc_cidr_block = "10.0.0.0/16" # 65536 total IPs => 10.0.0.0 - 10.0.255.255

# Subnet Settings
strapi_subnet_name       = "strapi_subnet_main"
strapi_subnet_cidr_block = "10.0.1.0/24" # 256 total IPs => 10.0.1.0 - 10.0.1.255

# Internet Gateway Settings
strapi_gateway_name = "strapi_gw_main"

##############################
# Strapi App Server Settings #
##############################

# See the following Site for Plans: https://aws.amazon.com/ec2/instance-types/
strapi_plan  = "t2.medium" # Cost ~34$/month
strapi_label = "my-strapi-srv"

###################################
# Strapi Database Server Settings #
###################################

# See the following Site for Plans: https://aws.amazon.com/ec2/instance-types/
database_plan  = "t2.medium" # Cost ~34$/month
database_label = "my-strapi-db"
