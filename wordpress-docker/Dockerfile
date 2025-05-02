# WordPress Dockerfile: Create container from official WordPress image, basic customizations.
# docker build -t wordpress_local:wp_custom_1.0 .

FROM wordpress:latest

# APT Update/Upgrade, then install packages we need
RUN apt update && \
    apt upgrade -y && \
    apt autoremove && \
    apt install -y \
    vim \
    wget \
    mariadb-client

# Replace php.ini
COPY php.ini /usr/local/etc/php

# Copy wp-config.php
COPY wp-config.php /var/www/html/

# Copy pre-installed themes
COPY themes /var/www/html/wp-content/themes/

# Copy pre-installed plugins
COPY plugins /var/www/html/wp-content/plugins/

# Copy pre-installed uploads
COPY uploads /var/www/html/wp-content/uploads/

COPY wordpress /var/www/html/

# Optional: Copy database dump
COPY wp-dump.sql /tmp/

# Install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    php wp-cli.phar --info && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    # Remove old php.ini files (without creating new image)
    rm /usr/local/etc/php/php.ini-development && \
    rm /usr/local/etc/php/php.ini-production


# Install WP-CLI
# RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
#     php wp-cli.phar --info && \
#     chmod +x wp-cli.phar && \
#     mv wp-cli.phar /usr/local/bin/wp && \
#     rm -f wp-cli.phar

# Copy entrypoint script that imports DB at runtime if needed
COPY docker-entrypoint-custom.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint-custom.sh

# Override default entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint-custom.sh"]

# Use the default command (Apache foreground)
CMD ["apache2-foreground"]