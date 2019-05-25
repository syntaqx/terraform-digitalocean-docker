variable "region" {
  description = "The region to deploy resources to"
  type        = string
}

variable "prefix" {
  description = "The naming prefix to append to resources"
  type        = string
}

variable "number" {
  description = "The number of instances to provision"
  type        = string
  default     = 1
}

variable "size" {
  description = "The unique slug that identifies the Droplet size"
  default     = "s-1vcpu-1gb"
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
  description = "The file path to the private SSH key. If this is a file, it can be read using the file interpolation function"
  type        = string
}

