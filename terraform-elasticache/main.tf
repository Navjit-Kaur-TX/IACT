resource "aws_elasticache_replication_group" "example" {
  replication_group_id   = "my-replication-group"
  description            = "My ElastiCache replication group"
  engine                 = "redis"
  engine_version         = "6.x"
  port                   = 6379
  automatic_failover_enabled = true
  node_type              = "cache.t3.small"
  replicas_per_node_group = 1  # Replace with your security group ID(s)

  tags = {
    Environment = "Production"
    Owner       = "John Doe"
  }
}