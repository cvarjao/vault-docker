# Must use URL
FROM registry.access.redhat.com/rhel7

RUN yum install -y sudo unzip openssl  && \
    sed -i '/Defaults    requiretty/s/^/#/' /etc/sudoers && \
    yum clean all -y
    
ENV VAULT_VERSION 0.5.3
ADD https://releases.hashicorp.com/vault/0.5.3/vault_0.5.3_linux_amd64.zip /tmp/vault_linux_amd64.zip
RUN mkdir -p /app/vault/bin && \
     unzip -d /app/vault/bin /tmp/vault_linux_amd64.zip && \
     rm /tmp/vault_linux_amd64.zip && \
     chmod 755 /app/vault/bin/vault && \
     mkdir /data/vault

COPY ./files/ /

EXPOSE 8200

ENTRYPOINT ["top", "-b"]
