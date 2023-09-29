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

variable "index_html_filepath" {
  description = "Path to the index.html file"
  type        = string

  validation {
    condition     = fileexists(var.index_html_filepath)
    error_message = "The specified index.html path is not valid or the file does not exist."
}
}
 

variable "error_html_filepath" {
  description = "Path to the error.html file"
  type        = string

    validation {
    condition     = fileexists(var.error_html_filepath)
    error_message = "The specified error.html path is not valid or the file does not exist."
  
}
}

variable "content_version" {
  description = "Version number for content. Must be a positive integer starting at 1."
  type        = number

  validation {
    condition     = var.content_version > 0 && floor(var.content_version) == var.content_version
    error_message = "The content_version must be a positive integer."
  }
}