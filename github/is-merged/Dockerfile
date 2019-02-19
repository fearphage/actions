FROM alpine:latest

LABEL "com.github.actions.name"="PR merged"
LABEL "com.github.actions.description"="Checks if PR is merged"
LABEL "com.github.actions.icon"="git-merge"
LABEL "com.github.actions.color"="gray-dark"

RUN	apk add --no-cache \
	bash \
	jq

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
