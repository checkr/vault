FROM alpine:3.5

RUN apk upgrade --no-cache && apk add --no-cache bash curl coreutils
RUN adduser -h /vault -D vault

WORKDIR /vault
EXPOSE 8200

ENV VAULT_VERSION 0.7.0

RUN curl -s -o /tmp/vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && unzip /tmp/vault.zip -d /usr/bin; rm -f /tmp/vault.zip; chmod +x /usr/bin/vault

COPY config/vault.hcl /vault/vault.hcl
COPY bin/run.sh /vault/bin/run.sh
COPY bin/overlord.sh /vault/bin/overlord.sh
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

RUN mkdir -p /etc/secrets
RUN chown vault:vault /etc/secrets
RUN chgrp -R vault /etc/secrets
RUN chmod g+s /etc/secrets

USER vault
CMD [ "/vault/bin/run.sh" ]
