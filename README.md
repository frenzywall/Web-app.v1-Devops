# Web-app.v1-Devops

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Key Pair Management](#key-pair-management)
- [Gitignore](#gitignore)
- [Contributing](#contributing)
- [License](#license)

## Features

- Create and manage AWS resources using OpenTofu.
- Generate SSH key pairs for secure access to EC2 instances.
- Sets up Apache Maven and Amazon Corretto 8 for a web app

## Requirements

- [Terraform](https://www.terraform.io/downloads.html) (version x.x.x)
- [AWS CLI](https://aws.amazon.com/cli/) (version x.x.x)
- Bash (for running shell scripts)
- # OpenNTofu

OpenNTofu is a project that utilizes [OpenTofu](https://opentofu.org/) for provisioning and managing cloud resources on AWS. This repository contains scripts and Terraform configuration files for setting up a basic infrastructure, including key pairs, VPCs, subnets, security groups, and EC2 instances.

## Usage
1. Download the git repo: 
```sh 
git clone https://github.com/frenzywall/Web-app.v1-Devops-.git 

cd Web-app.v1-Devops-.git
```
2. Make sure you meet all the requirements before you proceed further.

3. Do:
```sh
tofu init

tofu plan

tofu apply
```

### Create SSH Key Pair: Use the Key-pair-Creator.sh script to generate a new SSH key pair.
```sh
  chmod +x Key-pair-Creator.sh
```
```sh
 ./Key-pair-Creator.sh
```
For this current version, just running:
```sh
tofu apply
``` 
will auto-generate private and publick key. Public key will be stored in AWS and private key will be appended to a local file within the current directory.

4. Copy the generated Public ip address and ssh into the ec2-instance using:

```sh
chmod 400 Web-Devops-new.pem #Sets .pem to read only to this user

ssh -i Web-Devops-new.pem ec2-user@{replace with public ip address}
```
### Connect using vscode-Remote server ssh
1. Install Remote-server ssh extension, and connect using ssh command, for me it was 
```sh
ssh -i /home/frenzy/openntofu/Web-Devops-new.pem ec2-user@13.201.51.226 #Replace with your IP address
```
using the scp to transfer web-app.sh install script to ec2-instance
```sh
scp -i /home/frenzy/openntofu/Web-Devops-new.pem /home/frenzy/openntofu/web-app.sh ec2-user@13.201.51.226:/home/ec2-user/
```
2. Set execute permissions: 
```sh
chmod +x web-app.sh
#Run
./web-app.sh
```
Success!

## Example of profile: Using AWS CLI

### Method 1: Configure with wizard
```sh
aws configure
```
### Method 2: Configure specific profile

```sh
aws configure --profile profile_name
```
### Method 3: Set credentials manually

```sh
aws configure set aws_access_key_id "your_access_key"
aws configure set aws_secret_access_key "your_secret_key"
aws configure set region "us-east-1"
```
The configured file can be found in:

![alt text](Misc/1.png)

```sh
/home/{username}/.aws/credentials
```
Alternatively, you can manually cd to 
```sh
/home/{username}/.aws/credentials
``` 
and edit out the credential file to manually set a profile, [work,personal,etc..]


