output "project_id" {
  description = "The unique ID of the GCP project."
  value       = google_project.project.project_id
}

output "project_number" {
  description = "The unique number of the GCP project."
  value       = google_project.project.number
}
