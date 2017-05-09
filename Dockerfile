FROM node:alpine
MAINTAINER ObjectRocket <dev@objecrocket.com>

EXPOSE 3030

RUN apk add --update \
    ca-certificates \
    openssl-dev \
    libffi-dev \
    git \
    python \
    python-dev \
    py-pip \
    py-setuptools \
    build-base \
    && rm -rf /var/cache/apk/*

RUN git clone https://github.com/objectrocket/elastalert.git -b master --depth=1 /opt/elastalert
WORKDIR /opt/elastalert
RUN mkdir server_data
RUN python setup.py install
WORKDIR /opt/elastalert-server
COPY . /opt/elastalert-server
RUN chmod +x /opt/elastalert-server/wait-for
RUN npm install --production --quiet
COPY config/elastalert.yaml /opt/elastalert/config.yaml
COPY config/elastalert-server.json config/config.json

RUN apk del python-dev \
    py-setuptools \
    py-pip \
    build-base \
    git

CMD ["npm", "start"]
