FROM hashicorp/terraform:latest

RUN apk add --no-cache git

WORKDIR /app

COPY run.sh /app/run.sh

RUN chmod +x /app/run.sh

ENTRYPOINT ["/bin/sh", "/app/run.sh"]