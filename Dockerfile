# ARG before FROM to use in FROM instruction
ARG RUBY_VERSION=3.2 
FROM ruby:${RUBY_VERSION}-alpine

WORKDIR /app

# Install build dependencies for native extensions
RUN apk add --no-cache \
    build-base \
    git \
    linux-headers \
    libc-dev \
    make \
    gcc \
    g++

# Copy everything first
COPY . .

# Set up entrypoint script
COPY rake-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/rake-entrypoint.sh

# Default command to keep container running (overridden by docker-compose)
CMD ["sleep", "infinity"]
