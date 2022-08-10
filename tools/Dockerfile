FROM debian:11

RUN apt-get update \
    && apt-get install -y gnupg software-properties-common apt-transport-https ca-certificates curl rsync iproute2 dos2unix

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && curl https://baltocdn.com/helm/signing.asc | apt-key add -

RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list \
    && echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list \
    && apt-get update

RUN apt-get install -y git packer terraform kubectl helm python3 python3-pip \
    && pip install ansible

RUN apt-get install -y sshpass

COPY entrypoint.sh /
RUN dos2unix -q /entrypoint.sh
RUN chmod a+x /entrypoint.sh

RUN useradd -ms /bin/bash build
USER build
WORKDIR /mnt

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]