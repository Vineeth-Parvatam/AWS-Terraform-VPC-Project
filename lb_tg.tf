# define the target group for the demo project

resource "aws_lb_target_group" "demo_project_tg" {
    name     = "${var.project_name}-tg"
    port     = 8000
    protocol = "HTTP"
    vpc_id   = module.vpc.vpc_id

    health_check {
        path            = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 3
        unhealthy_threshold = 3
    }

    tags = {
        Name = "${var.project_name}_tg"
    }
}

# Create a security group for the load balancer
resource "aws_security_group" "demo_project_sg_lb" {
    name        = "${var.project_name}_sg_lb"
    description = "Security group for ${var.project_name} load balancer"
    vpc_id      = module.vpc.vpc_id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project_name}_sg"
    }
}

# Create an Application Load Balancer for the demo project
resource "aws_lb" "demo_project_lb" {
    name               = "${var.project_name}-lb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.demo_project_sg_lb.id]
    subnets            = module.vpc.public_subnet_ids

    enable_deletion_protection = false

    tags = {
        Name = "${var.project_name}_lb"
    }
}

# Create a listener for the load balancer
resource "aws_lb_listener" "demo_project_listener" {
    load_balancer_arn = aws_lb.demo_project_lb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.demo_project_tg.arn
    }
}
