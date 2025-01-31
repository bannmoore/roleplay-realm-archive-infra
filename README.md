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

## Gotchas

### DigitalOcean expects the amd64 platform

If the published image is built on the arm64 platform, it won't work on Digital Ocean. Check it like so:

```sh
docker image ls | grep bam 
docker inspect <IMAGE_ID> --format '{{.Architecture}}'
```

This _should_ print out amd64. If not, the image needs to be rebuilt.

## Gratitude to these Resources

- https://tonitalksdev.com/deploying-clojure-like-a-seasoned-hobbyist