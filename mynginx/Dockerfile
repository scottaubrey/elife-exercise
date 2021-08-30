FROM nginx

HEALTHCHECK --interval=1m --timeout=3s \
  CMD curl -f http://localhost/index.txt || exit 1