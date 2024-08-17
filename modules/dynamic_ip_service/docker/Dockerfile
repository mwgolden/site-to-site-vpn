FROM hashicorp/terraform:latest

ENV CUSTOMER_GATEWAY_ADDRESS=1.1.1.1
ENV LOCAL_NETWORK_CIDR=1.1.0.0/16
ENV REMOTE_NETWORK_CIDR=1.1.0.0/16

RUN apk add --no-cache git

WORKDIR /app

COPY run.sh /app/run.sh

RUN chmod +x /app/run.sh

ENTRYPOINT ["/bin/sh", "/app/run.sh"]
