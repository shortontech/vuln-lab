# Builds a dev-only layer on top of the production image
FROM php:8.3-fpm-alpine

# Use ARGs to define environment variables passed from the Docker build command or Docker Compose.
ARG XDEBUG_ENABLED=true
ARG XDEBUG_MODE=develop,coverage,debug,profile
ARG XDEBUG_HOST=host.docker.internal
ARG XDEBUG_IDE_KEY=DOCKER
ARG XDEBUG_LOG=/dev/stdout
ARG XDEBUG_LOG_LEVEL=0
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

USER root
RUN apk add --no-cache \
      git unzip icu-dev oniguruma-dev libzip-dev libpng-dev \
      su-exec netcat-openbsd bash shadow bash

RUN set -eux; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS; \
    docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd; \
    docker-php-ext-install -j"$(nproc)" mysqli pdo_mysql; \
    docker-php-ext-enable mysqli pdo_mysql; \
    apk del .build-deps

# Add ARGs for syncing permissions
ARG UID=1000
ARG GID=1000

# Create a new user with the specified UID and GID, reusing an existing group if GID exists
RUN groupadd -g ${GID} var-www && \
      usermod -u 1000 www-data

# Set the working directory & chmod that shi-
WORKDIR /var/www/html
USER root
RUN chown -R www-data:www-data .
# Switch back to the non-privileged user to run the application
USER www-data
COPY ./docker/php/entrypoint.sh /usr/local/bin/entrypoint.sh

# Change the default command to run the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]