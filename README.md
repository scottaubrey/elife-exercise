# elife interview exercise

This repo contains the output of an DevOps interview exercise at eLife

There are two containers built from this repo:

1. **php-updater** - a single-script PHP container that updates `/var/www/index.txt` with the date and time every 10 seconds
1. **mynginx** - a customised `nginx` container to add basic monitoring, where retrieving `/index.txt` from the local container webserver is a success.

## Build

You can build both containers using `docker build`:

```
docker build mynginx -t mynginx
docker build php-updater -t php-updater
```

Alternatively, using make run `make build` to build both images, or `make build-and-test` to run tests on the final images

## Run and test

To run both containers together, the directory `/usr/share/nginx/html` in the `mynginx` container and `/var/www` in the `php-updater` container need access to the same directory. You can bind-mount a local folder (such as the empty public folder in this repo), for example, run also bind local port 8080 to nginx:

```
docker run --rm -d -v public:/usr/share/nginx/html --name mynginx -p 8080:80 mynginx
docker run --rm -d -v public:/var/www --name php-updater php-updater
```

retriveing the latest text file:

```
curl http://localhost:8080/index.txt
```

Alternatively, just run `make test` once the containers are up.

You can then stop the containers, using docker stop:

```
docker stop mynginx php-updater
```

Alternatively, just run `make run`, and `make stop`, respectively.
