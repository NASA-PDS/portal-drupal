# Terraform

More to come.


## SSH key pair

Generated an elliptical key via

    ssh-keygen -t ed25519 -C 'EMAIL AWS'

For me, I used my personal email address.

Most will register with AWS via:

    aws ec2 import-key-pair --key-name KEYNAME --public-key-material fileb://~/.ssh/id_rsa.pub

For me, I used `KEYNAME` = `SKAWS` and the `ed25519` key, so:

    aws ec2 import-key-pair --key-name SKAWS --public-key-material fileb://~/.ssh/id_ed25519_aws.pub


## Env vars

For personal running (or MCP running), set env vars (bash, fish, ksh, etc.):

    export AWS_ACCESS_KEY_ID=
    export AWS_SECRET_ACCESS_KEY=

Or for csh, tcsh, etc.:

    setenv AWS_ACCESS_KEY
    setenv AWS_SECRET_ACCESS_KEY


## Platform Mismatch Issue

If you get the arm64 not supported for template, try:

    kreuzwerker/taps/m1-terraform-provider-helper
    m1-terraform-provider-helper activate
    m1-terraform-provider-helper install hashicorp/template -v 2.2.0
    terraform init
