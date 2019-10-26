variable "prefix" {
  description = "The name prefix to append to resources"
  type        = string
}

variable "instance_count" {
  description = "The number of droplet resources to provision"
  default     = 1
}

variable "region" {
  description = "The region to deploy resources to"
  type        = string
  default     = "nyc3"
}

variable "droplet_image" {
  description = "The unique slug that identifies the Droplet image"
  default     = "docker-18-04"
}

variable "size" {
  description = "The unique slug that identifies the Droplet size"
  default     = "s-1vcpu-1gb"
}

variable "monitoring" {
  description = "Whether or not to install the monitoring agent"
  default     = true
}
variable "backups" {
  description = "Whether or not to enable backups"
  default     = true
}

variable "private_networking" {
  description = "Whether or not to enable private networking"
  default     = true
}

variable "ipv6" {
  description = "Whether or not to enable IPv6 networking"
  default     = false
}

variable "tags" {
  description = "A list of the existing tag resources to label the Droplets"
  type        = list(string)
  default     = []
}

variable "ssh_keys" {
  description = "A list of SSH IDs or fingerprints to enable for the Droplets"
  type        = list(string)
  default     = []
}

variable "private_key_path" {
  description = "The file path to the private SSH key. This path will be interpolated with the file function"
  type        = string
  default     = null
}

variable "ssh_agent" {
  description = "Whether or not to use the SSH agent to authenticate"
  type        = bool
  default     = false
}
