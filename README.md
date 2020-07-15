# cloud_task3
Launching Wordpress and MySql in public and private subnet under our own VPC

---

# What is aws?

Amazon web service is a platform that offers flexible, reliable, scalable, easy-to-use, and cost-effective cloud computing solutions.
AWS is a comprehensive, easy to use computing platform offered Amazon. The platform is developed with a combination of infrastructure as a service (IaaS), platform as a service (PaaS) and packaged software as a service (SaaS) offerings.

# 7 Best Benefits of AWS (Amazon Web Services)

* Comprehensive
* Cost-Effective
* Adaptable
* Security
* Innovation
* Global leader
* Improved Productivity



---

# It's service

# VPC

Virtual Private Cloud (Amazon VPC) lets you provision a logically isolated section of the AWS Cloud where you can launch AWS resources in a virtual network that you define. You have complete control over your virtual networking environment, including selection of your own IP address range, creation of subnets, and configuration of route tables and network gateways. You can use both IPv4 and IPv6 in your VPC for secure and easy access to resources and applications.

# The following are the key concepts for VPCs:

Virtual private cloud (VPC) - A virtual network dedicated to your AWS account.

Subnet - A range of IP addresses in your VPC.

Route table - A set of rules, called routes, that are used to determine where network traffic is directed.

Internet gateway - A gateway that you attach to your VPC to enable communication between resources in your VPC and the internet.

# Subnet

Subnet, or subnetwork, is a network inside a network. Subnets make networks more efficient. Through subnetting, network traffic can travel a shorter distance without passing through unnecessary routers to reach its destination.
Each computer, or host, on the internet, has at least one IP address as a unique identifier. Organizations will use a subnet to subdivide large networks into smaller, more efficient subnetworks. One goal of a subnet is to split a large network into a grouping of smaller, interconnected networks to help minimize traffic.

# Route Table

Route table contains a set of rules, called routes, that are used to determine where network traffic from your subnet or gateway is directed.

# Internet Gateway

Internet gateway is a horizontally scaled, redundant, and highly available VPC component that allows communication between your VPC and the internet.
An internet gateway serves two purposes: to provide a target in your VPC route tables for internet-routable traffic, and to perform network address translation (NAT) for instances that have been assigned public IPv4 addresses.
An internet gateway supports IPv4 and IPv6 traffic. It does not cause availability risks or bandwidth constraints on your network traffic.

# EC2

Elastic Block Store (EBS) is an easy to use, high-performance block storage service designed for use with Amazon Elastic Compute Cloud (EC2) for both throughput and transaction-intensive workloads at any scale. A broad range of workloads, such as relational and non-relational databases, enterprise applications, containerized applications, big data analytics engines, file systems, and media workflows are widely deployed on Amazon EBS.

# Key Pairs and Security Group

Key pair, consisting of a private key and a public key, is a set of security credentials that you use to prove your identity when connecting to an instance. Amazon EC2 stores the public key, and you store the private key. You use the private key, instead of a password, to securely access your instances.
Security group acts as a virtual firewall for your EC2 instances to control incoming and outgoing traffic. Inbound rules control the incoming traffic to your instance, and outbound rules control the outgoing traffic from your instance. … If you don't specify a security group, Amazon EC2 uses the default security group.

#What is terraform?

Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.
Configuration files describe to Terraform the components needed to run a single application or your entire datacenter. Terraform generates an execution plan describing what it will do to reach the desired state, and then executes it to build the described infrastructure. As the configuration changes, Terraform is able to determine what changed and create incremental execution plans which can be applied.
The infrastructure Terraform can manage includes low-level components such as compute instances, storage, and networking, as well as high-level components such as DNS entries, SaaS features, etc.

# The key features of Terraform are

* Execution Plans
* Infrastructure as Code
* Change Automation
* Resource Graph
