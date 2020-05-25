# DigitalOcean + Terraform == Nextcloud (DigitalTerraCloud?)

## Overview
I got tired of having an over-heated toaster-box and Dynamic DNS on my home
router constantly having issues while hosting my own Nextcloud instance at home.

Enter: `DigitalTerraCloud`

This repo leverages three distinct tools/services to attempt to achieve a secure
single-node Nextcloud deployment at DigitalOcean:
* `Terraform` (https://www.terraform.io)
* `DigitalOcean` (https://www.digitalocean.com)
* `Nextcloud` (https://www.nextcloud.com)

# Usage
TODO: improve this section.
* Install `Terraform`
    * https://learn.hashicorp.com/terraform/getting-started/install
* Install the `DigitalOcean` Terraform provider:
    ```
    terraform init
    ```
* Copy `tfvars.example` to `terraform.tfvars` in the project directory
* Fill in the specified variables in `terraform.tfvars`
* Run `terraform apply`
* _**PROFIT**_ (or whatever)

# Acknowledgments
Big thanks to `tnorris` ([GitHub](https://github.com/tnorris)) for being the best
rubber-ducky I could ask for on a holiday weekend.

Also big thanks to `apolloclark` ([Github](https://github.com/apolloclark)) for
continued snark and debauchery in the face of global uncertainty.