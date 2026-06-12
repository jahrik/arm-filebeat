# AGENTS.md

Multi-arch Filebeat image: pinned `FROM` over official `docker.elastic.co/beats/filebeat`, shipping container + system logs in the `elk` swarm stack.

## Commands

```bash
make build                                  # build jahrik/arm-filebeat:latest
docker run --rm jahrik/arm-filebeat:latest version
make deploy                                 # swarm stack deploy (stack: elk)
```

## CI

`build.yml`: Test (build + `version` + `test config`) on PR; Release (buildx amd64+arm64 push to Docker Hub) on merge to main. Needs `DOCKERHUB_USERNAME`/`DOCKERHUB_TOKEN` secrets. No armv7 — Elastic has no 32-bit images.

## Quirks

- Bump Filebeat via the `FROM` tag; keep it on the same major as arm-elasticsearch.
- `filebeat.yml` was ported from 5.x: the removed `type: docker` input became `filestream` + `container` parser. It's delivered as a swarm config, not baked into the image.
- The compose service runs as root with `--strict.perms=false` so it can read `/var/lib/docker/containers` and `docker.sock` — required, not optional.
- External `elk` overlay network — keep that wiring.
