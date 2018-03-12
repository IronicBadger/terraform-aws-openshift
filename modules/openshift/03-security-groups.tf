//  This security group allows intra-node communication on all ports with all
//  protocols.
resource "aws_security_group" "ocp-vpc-${var.cluster_name}" {
  name        = "ocp-vpc-${var.cluster_name}"
  description = "Default security group that allows all instances in the VPC to talk to each other over any port and protocol."
  vpc_id      = "${aws_vpc.ocp-${var.cluster_name}.id}"

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  tags {
    Name    = "ocp ${var.cluster_name} Internal VPC"
    Cluster = "ocp-${var.cluster_name}"
  }
}

//  This security group allows public ingress to the instances for HTTP, HTTPS
//  and common HTTP/S proxy ports.
### TODO: Lock down to only infra nodes
resource "aws_security_group" "ocp-public-ingress-${var.cluster_name}" {
  name        = "ocp-public-ingress-${var.cluster_name}"
  description = "Security group that allows public ingress to instances, HTTP, HTTPS and more."
  vpc_id      = "${aws_vpc.ocp-${var.cluster_name}.id}"

  //  HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  HTTP Proxy
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  HTTPS Proxy
  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name    = "ocp ${var.cluster_name} Public Access"
    Cluster = "ocp-${var.cluster_name}"
  }
}

//  This security group allows public egress from the instances for HTTP and
//  HTTPS, which is needed for yum updates, git access etc etc.
resource "aws_security_group" "ocp-public-egress-${var.cluster_name}" {
  name        = "ocp-public-egress-${var.cluster_name}"
  description = "Security group that allows egress to the internet for instances over HTTP and HTTPS."
  vpc_id      = "${aws_vpc.ocp-${var.cluster_name}.id}"

  //  HTTP
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //  HTTPS
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name    = "ocp ${var.cluster_name} Public Access"
    Cluster = "ocp-${var.cluster_name}"
  }
}

//  Security group which allows SSH access to a host. Used for the bastion.
resource "aws_security_group" "ocp-ssh-${var.cluster_name}" {
  name        = "ocp-ssh-${var.cluster_name}"
  description = "Security group that allows public ingress over SSH."
  vpc_id      = "${aws_vpc.ocp-${var.cluster_name}.id}"

  //  SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name    = "ocp ${var.cluster_name} SSH Access"
    Cluster = "ocp-${var.cluster_name}"
  }
}
