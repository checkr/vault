FROM alpine:3.5

RUN apk upgrade --no-cache && apk add --no-cache bash curl coreutils gpgme
RUN adduser -h /vault -D vault

EXPOSE 8200

ARG VAULT_VERSION=0.7.3

WORKDIR /tmp
# See https://www.hashicorp.com/security.html for PGP verification steps
RUN curl -s -o vault_${VAULT_VERSION}_linux_amd64.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
    curl -s -o vault_SHA256SUMS https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS && \
    curl -s -o vault_SHA256SUMS.sig https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS.sig && \
    gpg --keyserver pgp.mit.edu --recv-key 51852D87348FFC4C && \
    gpg --verify vault_SHA256SUMS.sig vault_SHA256SUMS && \
    grep linux_amd64 vault_SHA256SUMS | sha256sum -c - && \
    unzip /tmp/vault_${VAULT_VERSION}_linux_amd64.zip -d /usr/bin; rm -f /tmp/vault_${VAULT_VERSION}_linux_amd64.zip; chmod +x /usr/bin/vault

WORKDIR /vault
COPY config/vault.hcl /vault/vault.hcl
COPY bin/run.sh /vault/bin/run.sh
COPY bin/overlord.sh /vault/bin/overlord.sh
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD [ "/vault/bin/run.sh" ]
