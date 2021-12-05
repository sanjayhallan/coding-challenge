locals {
  name        = "bidnamic-ecs"
  environment = "dev"

  ec2_resources_name = "${local.name}-${local.environment}"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.name

  cidr = "10.1.0.0/16"

  azs             = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.11.0/24", "10.1.12.0/24"]

  enable_nat_gateway = false

  tags = {
    Environment = local.environment
    Name        = local.name
  }
}


module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  name = "bidnamic-ecs"

  capacity_providers = ["FARGATE"]


  tags = {
    Environment = "Development"
  }
}

resource "aws_ecs_service" "hello_world_service" {
  name            = "python-app"
  cluster         = module.ecs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = module.vpc.public_subnets
    assign_public_ip = true
    security_groups = [aws_security_group.app_inbound.id]
  }

}

resource "aws_ecs_task_definition" "app_task" {
  family                   = "hello_world_task"
  network_mode             = "awsvpc"
  container_definitions    = file("task_def.json")
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
}


resource "aws_security_group" "app_inbound" {
  name        = "bidnamic_app_inbound"
  description = "Allow app traffic inbound to port 5000"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Inbound traffic to application"
    from_port        = 5000
    to_port          = 5000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}