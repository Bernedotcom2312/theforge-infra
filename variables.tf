variable "project_id" {
  description = "project id"
  type        = string
}

variable "region" {
  description = "region"
  type        = string
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
  type        = number
}