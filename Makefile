IMAGE = "jahrik/arm-filebeat"
STACK = "elk"
TAG := $(shell uname -m)

all: build

git:
	@git clone https://github.com/elastic/beats-docker.git

build: git
	@cd logspout && docker build -t ${IMAGE}:$(TAG) .

push:
	@docker push ${IMAGE}:$(TAG)

deploy:
	@docker stack deploy -c docker-compose.yml ${STACK}

.PHONY: all build push deploy
