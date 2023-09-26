variable "user_uuid" {
  description = "User UUID"
  type        = string
validation {
  condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$", var.user_uuid))
    error_message = "The user_uuid must be in UUID format."
 }
}
  

 