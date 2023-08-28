variable "aws_region" {
  description = "Region where you want to provision this EC2 WebServer"
  type        = string // number , bool
  default     = "eu-central-1"
}

variable "instance_size" {
  description = "EC2 Instance Size to provision"
  type        = string
  default     = "t2.micro"
}

variable "enable_detailed_monitoring" {
  type    = bool
  default = false
}

variable "port_list" {
  description = "List of Poret to open for our WebServer"
  type        = list(any)
  default     = ["80", "443", "22", "8080"]
}

variable "tags" {
  description = "Tags to Apply to Resources"
  type        = map(any)
  default = {
    Owner       = "Oleksii Kochetkov"
    Environment = "CI-CD"
    Project     = "Project_01"
    CostCenter  = "0808083"
  }
}

/*variable "key_pair" {
  description = "SSH Key pair name to ingest into EC2"
  type        = string
  default     = "EuropeKey"
  sensitive   = true
}
*/

/*variable "password" {
  description = "Please Enter Password lenght of 10 characters!"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.password) == 10
    error_message = "Your Password must be 10 characted exactly!!!"
  }
}
*/
