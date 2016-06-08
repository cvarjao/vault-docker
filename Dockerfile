# Must use URL
FROM registry.access.redhat.com/rhel7
ENV VAULT_ADDR="http://127.0.0.1:8200"
ENV VAULT_VERSION=0.5.3

RUN yum install -y sudo unzip tar openssl  && \
    sed -i '/Defaults    requiretty/s/^/#/' /etc/sudoers && \
    yum clean all -y

# Add s6 overlay (https://github.com/just-containers/s6-overlay)
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.17.2.0/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude="./bin" --exclude="./sbin" && \
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin ./sbin

ADD https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 /usr/local/bin/jq
RUN chmod a+x /usr/local/bin/jq

ADD https://releases.hashicorp.com/vault/0.5.3/vault_0.5.3_linux_amd64.zip /tmp/vault_linux_amd64.zip
RUN mkdir -p /app/vault/bin && \
     unzip -d /app/vault/bin /tmp/vault_linux_amd64.zip && \
     rm /tmp/vault_linux_amd64.zip && \
     chmod 755 /app/vault/bin/vault && \
     mkdir -p /data/vault

COPY ./files/ /
RUN find /app/s6.d -type f -exec chmod a+x {} \;

EXPOSE 8200

ENTRYPOINT ["/app/docker/start.sh"]
