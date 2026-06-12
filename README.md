# arm-filebeat

[![Build](https://github.com/jahrik/arm-filebeat/actions/workflows/build.yml/badge.svg)](https://github.com/jahrik/arm-filebeat/actions/workflows/build.yml)

Multi-arch [Filebeat](https://www.elastic.co/beats/filebeat) image for shipping container and system logs to the `elk` swarm stack. Built for a 2018 Pi swarm cluster (Filebeat 5.6 tarball on golang); now a pinned layer over the official `docker.elastic.co/beats/filebeat` image.

## Run

```bash
docker run --rm jahrik/arm-filebeat:latest version
```

`filebeat.yml` ships system logs and container logs (filestream + container parser); ES/Kibana hosts come from `ELASTICSEARCH_HOST`/`KIBANA_HOST` env vars.

## Deploy (swarm)

```bash
docker network create -d overlay elk   # once
make deploy                            # global service, config via swarm config
```

## Build

```bash
make build
make push
```

CI: PR builds + version/config checks; merge to main pushes multi-arch (amd64/arm64) to Docker Hub. No armv7: Elastic doesn't publish 32-bit beats images.
