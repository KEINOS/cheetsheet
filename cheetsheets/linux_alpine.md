[INDEX](../)

---

# Linux (Alpine Linux)

## Must dependencies for building Go binary

This is a list of basic apk packages that must be installed to develop and build Go applications on Alpine Linux.

```bash
apk add --no-cache alpine-sdk build-base
```

## How to create user (docker)

```dockerfile
FROM alpine:latest

# Create a group and user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Tell docker that all future commands should run as the appuser user
USER appuser
```

- REF:
  - [Setting up a new user](https://wiki.alpinelinux.org/wiki/Setting_up_a_new_user) @ wiki.alpinelinux.org
  - [How do I add a user when I'm using Alpine as a base image?](https://stackoverflow.com/a/49955098/18152508) @ StackOverflow

## Installing Docker on Alpine Linux

```bash
# Install docker, compose and buildx
apk add docker docker-cli-compose docker-cli-buildx
# Add user to docker group
addgroup $(whoami) docker
# Regist docker
rc-update add docker default
service docker start
# Smoke test
docker compose --version
docker run hello-world
```

- Ref: [https://wiki.alpinelinux.org/wiki/Docker](https://wiki.alpinelinux.org/wiki/Docker)

## Launching Portainer via docker compose

Create self cert for portainer endpoint.

```bash
# Move to portainer cert directory to mount
cd /data/portainer/certs

openssl genrsa 2048 > server.key
openssl req -new -key server.key > server.csr
openssl x509 -req -days 3650 -signkey server.key < server.csr > server.crt
```

Create `docker-compose.yml` and mount the data and cert directory.

```yaml
version: "3"
services:
  portainer:
    image: portainer/portainer-ce:latest
    ports:
      - 9443:9443
    security_opt:
      - no-new-privileges:true
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock
      - /data/portainer:/data
      - /data/portainer/certs:/certs
    restart: unless-stopped
    command:
      --sslcert /certs/server.crt
      --sslkey /certs/server.key
```
