# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "do_token" {}
variable "do_ssh_fingerprint" {}
variable "do_region" {}
variable "do_image_name" {}
variable "nextcloud_subdomain_name" {}
variable "nextcloud_root_domain_name" {}
variable "nextcloud_full_fqdn" {
  type = string
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

# Create a tag
resource "digitalocean_tag" "nextcloud-tag" {
  name = "nextcloud"
}

# Create a volume
resource "digitalocean_volume" "nextcloud-data" {
  region                  = var.do_region
  name                    = "nextcloud-data"
  size                    = 100
  initial_filesystem_type = "ext4"
  description             = "nextcloud data volume"
  tags                    = [digitalocean_tag.nextcloud-tag.id]
}

# Create a web server
resource "digitalocean_droplet" "nextcloud" {
  image              = var.do_image_name
  name               = "nextcloud"
  region             = var.do_region
  size               = "s-2vcpu-2gb"
  ssh_keys           = var.do_ssh_fingerprint
  ipv6               = false
  private_networking = true
  tags               = [digitalocean_tag.nextcloud-tag.id]

  # provisioner "remote exec" {
  #   script = "provision.sh"
  # }
}

# Instantiate a LetsEncrypt certificate
resource "digitalocean_certificate" "nextcloud-cert" {
  name    = "le-nextcloud"
  type    = "lets_encrypt"
  domains = [var.nextcloud_full_fqdn]
}

# Attach the volume
resource "digitalocean_volume_attachment" "nextcloud-data" {
  droplet_id = digitalocean_droplet.nextcloud.id
  volume_id  = digitalocean_volume.nextcloud-data.id
}

# Create a load balancer
resource "digitalocean_loadbalancer" "nextcloud-lb" {
  name                   = "nextcloud-lb"
  region                 = var.do_region
  redirect_http_to_https = true

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 80
    target_protocol = "http"

    # assign LetsEncrypt cert to loadbalancer
    certificate_id = digitalocean_certificate.nextcloud-cert.id
  }

  healthcheck {
    port     = 80
    protocol = "tcp"
  }

  # comma-delimit the list below if adding more/different droplets
  # droplet_ids = [digitalocean_droplet.nextcloud.id]

  # TODO: Check out using tags instead of droplet_ids
  droplet_tag = digitalocean_tag.nextcloud-tag.id
}

# Create a firewall
## TODO: Figure out how to apply public vs. private
resource "digitalocean_firewall" "nextcloud-fw" {
  name                      = "only-22-and-80"
  tags                      = [digitalocean_tag.nextcloud-tag.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "2002:1:2::/48"]
  }

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "80"
    # source_addresses = ["0.0.0.0/0", "::/0"]
    source_load_balancer_uids = [digitalocean_loadbalancer.nextcloud-lb.id]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

# Create the domain record
resource "digitalocean_record" "nextcloud-dns" {
  domain = var.nextcloud_root_domain_name
  type   = "A"
  name   = var.nextcloud_subdomain_name
  value  = digitalocean_loadbalancer.nextcloud-lb.ip
}
