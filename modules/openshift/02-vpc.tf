//  Define the VPC.
resource "aws_vpc" "ocp-${var.cluster_name}" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name    = "ocp ${var.cluster_name} VPC"
    Cluster = "ocp-${var.cluster_name}"
  }
}

//  Create an Internet Gateway for the VPC.
resource "aws_internet_gateway" "ocp-${var.cluster_name}" {
  vpc_id = "${aws_vpc.ocp.id}"

  tags {
    Name    = "ocp ${var.cluster_name} IGW"
    Cluster = "ocp-${var.cluster_name}"
  }
}

//  Create a public subnet.
resource "aws_subnet" "public-subnet-${var.cluster_name}" {
  vpc_id                  = "${aws_vpc.ocp-${var.cluster_name}.id}"
  cidr_block              = "${var.subnet_cidr}"
  availability_zone       = "${lookup(var.subnetaz, var.region)}"
  map_public_ip_on_launch = true
  depends_on              = ["aws_internet_gateway.ocp-${var.cluster_name}"]

  tags {
    Name    = "OCP ${var.cluster_name} Public Subnet"
    Cluster = "ocp-${var.cluster_name}"
  }
}

//  Create a route table allowing all addresses access to the IGW.
resource "aws_route_table" "public-${var.cluster_name}" {
  vpc_id = "${aws_vpc.ocp.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ocp.id}"
  }

  tags {
    Name    = "OCP ${var.cluster_name} Public Route Table"
    Cluster = "ocp"
  }
}

//  Now associate the route table with the public subnet - giving
//  all public subnet instances access to the internet.
resource "aws_route_table_association" "public-subnet-${var.cluster_name}" {
  subnet_id      = "${aws_subnet.public-subnet-${var.cluster_name}.id}"
  route_table_id = "${aws_route_table.public-${var.cluster_name}.id}"
}
