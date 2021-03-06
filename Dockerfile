FROM ubuntu:latest

# Install build dependencies.
RUN apt-get update
RUN apt-get -y install \
    build-essential \
    python-dev \
    python-pip \
    ca-certificates \
    git \
    libffi-dev \
    libssl-dev \
    curl

# Install nodejs.
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get -y install nodejs

# Cloning elastalert repository.
RUN git clone https://github.com/Yelp/elastalert.git -b master --depth=1 /opt/elastalert

# Build and install python dependencies.
WORKDIR /opt/elastalert
RUN mkdir server_data
RUN python setup.py install

# Clean
RUN apt-get -y purge \
    build-essential \
    python-dev \
    python-pip \
    ca-certificates \
    git \
    libffi-dev \
    libssl-dev \
    curl
RUN apt-get clean

# Copy elastalert-server and install nodejs dependencies.
WORKDIR /opt/elastalert-server
COPY . /opt/elastalert-server
RUN npm install --production --quiet
