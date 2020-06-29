# DigitalOcean + Terraform + Nextcloud == DigitalTerraCloud

## Overview
I got tired of having an over-heated toaster-box and Dynamic DNS on my home
router constantly having issues while hosting my own Nextcloud instance at home.

Enter: `DigitalTerraCloud`

This repo leverages three distinct tools/services to attempt to achieve a secure
single-node Nextcloud deployment at DigitalOcean:
* `Terraform` (https://www.terraform.io)
* `DigitalOcean` (https://www.digitalocean.com)
* `Nextcloud` (https://www.nextcloud.com)

## Usage
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

## TODO
* Fix DNS management via the `digitalocean_record` and `digitalocean_domain` resources
* Create a Packer image that comes with Nextcloud pre-installed as a Snap (or whatever's appropriate)
  * re: the above, also pre-enable the `removable-media` snap config and pre-configure the data dir on the data volume
  * example snap command: `snap connect nextcloud:removable-media`
* Figure out how to automatically create backups and a backup schedule of the data volume created for the DO instance
* Figure out whether to funnel SSH through the LB or not (I'm personally leaning toward `yes` on this -e1n)
* Expose (or pre-configure) the data volume location for Nextcloud
  * Exposing the volume's mount-point at the end of `terraform apply` allows the user to configure the data location manually
  * Also allows the user to decide how they want to take backups (if they don't want to use DigitalOcean's volume backup mechanisms)

## Acknowledgments
Big thanks to `tnorris` ([GitHub](https://github.com/tnorris)) for being the best
rubber-ducky I could ask for on a holiday weekend.

Also big thanks to `apolloclark` ([Github](https://github.com/apolloclark)) for
continued snark and debauchery in the face of global uncertainty.