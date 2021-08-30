FROM php:8.0-cli
COPY updater.php /usr/src/updater.php
WORKDIR /usr/src/
RUN apt update && apt install -y procps
CMD ["php", "updater.php"]

#health check
HEALTHCHECK --interval=1m --timeout=3s \
  CMD ps | grep php