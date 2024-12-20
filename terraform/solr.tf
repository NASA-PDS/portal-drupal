# Solr
# ====
#
# The app can access Solr at http://solr.drupalservices.local:8983/solr/

locals {
  solr_port      = 8983
  solr_version   = "7"
  namespace_name = "drupalservices.local"
}

# Security group for Solr ECS tasks. Only allow inbound traffic from Apache SG on port 8983.
resource "aws_security_group" "solr_sg" {
  name        = "solr_sg"
  description = "Allow Solr inbound traffic only from the Apache HTTPD server"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "Solr from Apache SG only"
    from_port       = local.solr_port
    to_port         = local.solr_port
    protocol        = "tcp"
    security_groups = [aws_security_group.apache_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS Cluster for running Solr
resource "aws_ecs_cluster" "solr_cluster" {
  name = "solr-cluster"
}

# Create a Service Discovery Namespace for private DNS
resource "aws_service_discovery_private_dns_namespace" "solr_namespace" {
  name        = local.namespace_name
  description = "Private DNS namespace for ECS services"
  vpc         = data.aws_vpc.default.id
}

# ECS Task Definition for Solr
resource "aws_ecs_task_definition" "solr_task" {
  family                   = "solr-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([
    {
      "name" : "solr",
      "image" : "solr:${local.solr_version}",
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : local.solr_port,
          "hostPort" : local.solr_port,
          "protocol" : "tcp"
        }
      ],
      "command" : [
        "solr-foreground"
      ]
    }
  ])

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_execution_role.arn
}

# IAM Role for ECS Task Execution (pulling images, logs)
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement : [
      {
        Action : "sts:AssumeRole",
        Principal : {
          Service : "ecs-tasks.amazonaws.com"
        },
        Effect : "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Service Discovery Service
resource "aws_service_discovery_service" "solr_sd_service" {
  name = "solr"
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.solr_namespace.id
    dns_records {
      type = "A"
      ttl  = 300
    }
    routing_policy = "MULTIVALUE"
  }
  health_check_custom_config {
    failure_threshold = 1
  }
}

# ECS Service for Solr
resource "aws_ecs_service" "solr_service" {
  name            = "solr-service"
  cluster         = aws_ecs_cluster.solr_cluster.id
  task_definition = aws_ecs_task_definition.solr_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    assign_public_ip = false
    security_groups  = [aws_security_group.solr_sg.id]
  }

  service_registries {
    registry_arn = aws_service_discovery_service.solr_sd_service.arn
  }

  depends_on = [aws_service_discovery_private_dns_namespace.solr_namespace]
}

output "solr_service_dns" {
  description = "The DNS name for the Solr service"
  # The ECS service will register a record like solr.<namespace>
  # The full domain would be: solr.drupalservices.local
  value = "solr.${local.namespace_name}"
}