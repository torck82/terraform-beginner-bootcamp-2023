variable "user_uuid" {
  description = "User UUID"
  type        = string
validation {
  condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$", var.user_uuid))
    error_message = "The user_uuid must be in UUID format."
 }
}
  
  variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string

  validation {
    condition     = (
      can(regex("^[a-z0-9][a-z0-9-.]{1,61}[a-z0-9]$", var.bucket_name)) &&
      length(regexall("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.bucket_name)) == 0
    )
    error_message = "The bucket_name must be between 3 and 63 characters in length, can contain only lowercase letters, numbers, hyphens, and periods, must start and end with a lowercase letter or number, and cannot be formatted as IP addresses."
  }
}


 