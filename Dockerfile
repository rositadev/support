FROM ubuntu:rolling

# Use baseimage-docker's init system:
CMD ["/sbin/my_init"]


# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    software-properties-common \
    && mkdir -p /home/stuff

# Set work dir:
WORKDIR /home

# Add Node.js 20 repository and install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Add Google Chrome repository and install Google Chrome
RUN curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && \
    apt-get install -y google-chrome-stable


# Copy files:
COPY script.sh /home
COPY /stuff /home/stuff

# Run config.sh and clean up APT:
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install the bot:
RUN echo "Uploaded files:" && ls /home/stuff/

# Run bot script:
CMD bash /home/script.sh