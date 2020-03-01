output "dynamodb_table" {
  value = module.database.table
}

output "reader_queue_url" {
  value = module.reader_queue.url
}

output "writer_queue_url" {
  value = module.writer_queue.url
}