# Roleplay Realm Archive Terraform

## Dependencies

- [Docker Desktop](https://docs.docker.com/desktop/)
- [Terraform](https://developer.hashicorp.com/terraform?product_intent=terraform) (`brew install terraform`)
- [Doctl](https://github.com/digitalocean/doctl) (`brew install doctl`)

This project also expects the following repos to be cloned into the same workspace:

- `roleplay-realm-archive`
- `roleplay-realm-archive-db`

## Quick Start

```sh
docker compose up -d
```

## Deploy

### Prerequisites

This Terraform configuration expects two resources to already exist:
- An ssh key called "ssh_admin"
- A container app registry called "bam"

### Deployment

Export the Digital Ocean Access Token:

```sh
export DIGITALOCEAN_ACCESS_TOKEN=$TOKEN
```

Build and publish Docker images:

```sh
# build images
docker compose build web

# check image creation
docker image ls | grep bam 

# log in and publish images
doctl registry login
docker push registry.digitalocean.com/bam/roleplay-realm-archive

# confirm
doctl registry repository list-v2
```

Apply Terraform :

```sh
cd terraform
terraform plan
terraform apply
```

Move setup files onto jumpbox:

```sh
cd jump
./move-files.sh
```

SSH into jumpbox:

```sh
doctl compute ssh postgres-jump-box --ssh-key-path ~/.ssh/id_rsa_do
```

(First time only) Set up jump box:

[Docs](https://docs.digitalocean.com/products/volumes/how-to/mount/)

```sh
./setup.sh

cat ~/.ssh/id_rsa.pub
# (copy the public key and add it to GH)

cd /mnt/postgres_jump_data
git clone git@github.com:bannmoore/roleplay-realm-archive-db.git
cd roleplay-realm-archive

source ../.env
./bin/migrate.sh
```

To run new migrations:

```
doctl compute ssh postgres-jump-box --ssh-key-path ~/.ssh/id_rsa_do

cd /mnt/postgres_jump_data/roleplay-realm-archive-db
git pull
source ../.env
./bin/migrate.sh
```

## Gotchas

### DigitalOcean expects the amd64 platform

If the published image is built on the arm64 platform, it won't work on Digital Ocean. Check it like so:

```sh
docker image ls | grep bam 
docker inspect <IMAGE_ID> --format '{{.Architecture}}'
```

This _should_ print out amd64. If not, the image needs to be rebuilt with the `--platform=linux/amd64` flag.

### Can not delete default VPCs

If your digitalocean_vpc resource is the first one for a region, it will automatically become the default. In order to run terraform destroy, create another one via the console and set it to default.

## Gratitude to these Resources

- https://tonitalksdev.com/deploying-clojure-like-a-seasoned-hobbyist
- https://slugs.do-api.dev/
- https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-a-registry/#:~:text=Even%20though%20they're%20related,your%20images%20based%20on%20projects.