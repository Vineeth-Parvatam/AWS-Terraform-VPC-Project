#defining key pair and security group for the demo project

resource "aws_key_pair" "demo_project_key" {
    key_name   = "${var.project_name}_key"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "demo_project_sg" {
    name        = "${var.project_name}_sg"
    description = "Security group for ${var.project_name} instances"
    vpc_id      = module.vpc.vpc_id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 8000
        to_port     = 8000
        protocol    = "tcp"
        security_groups = [aws_security_group.demo_project_sg_lb.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Launch Template for the demo project

resource "aws_launch_template" "demo_project_lt" {
    name_prefix   = "${var.project_name}_lt"
    image_id      = var.ami_id
    instance_type = var.instance_type
    key_name      = aws_key_pair.demo_project_key.key_name
    vpc_security_group_ids = [aws_security_group.demo_project_sg.id]

    user_data = filebase64("./user_data.sh")

    tag_specifications {
        resource_type = "instance"
        tags = {
            Name = "${var.project_name}_instance"
        }
    }
}

# Auto Scaling Group for the demo project

resource "aws_autoscaling_group" "demo_project_asg" {
    launch_template {
        id      = aws_launch_template.demo_project_lt.id
        version = "$Latest"
    }
    vpc_zone_identifier = module.vpc.private_subnet_ids
    min_size            = 2
    max_size            = 4
    desired_capacity    = 2
    target_group_arns = [ aws_lb_target_group.demo_project_tg.arn ]

    tag {
        key              = "Name"
        value            = "${var.project_name}_instance"
        propagate_at_launch = true
    }

    health_check_type          = "EC2"
    health_check_grace_period = 300
}