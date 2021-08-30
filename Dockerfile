FROM php:8.0-cli
COPY index.php /usr/src/index.php
WORKDIR /usr/src/
RUN apt update && apt install -y procps
CMD ["php", "index.php"]

#health check
HEALTHCHECK --interval=1m --timeout=3s \
  CMD ps | grep php