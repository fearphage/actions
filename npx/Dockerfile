FROM node:10-alpine

LABEL version="1.0.0"

LABEL com.github.actions.name="GitHub Action for npx"
LABEL com.github.actions.description="Wraps the npx CLI"
LABEL com.github.actions.icon="package"
LABEL com.github.actions.color="red"

COPY "entrypoint.sh" "/entrypoint.sh"
ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]
