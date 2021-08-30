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

## Deploy to nomad

Before you start, make sure your nomad commandline is setup for your nomad cluster (e.g. NOMAD_ADDR env var is set) and connected to consul.
You also need to make sure you want the public image, otherwise you need to edit `elife.nomad` to point to the correct docker image.

You can deploy straight from this repo:

```
$ nomad job run elife.nomad
==> 2021-08-30T09:52:35+01:00: Monitoring evaluation "a30937c6"
    2021-08-30T09:52:35+01:00: Evaluation triggered by job "elife"
==> 2021-08-30T09:52:36+01:00: Monitoring evaluation "a30937c6"
    2021-08-30T09:52:36+01:00: Evaluation within deployment: "82f768b8"
    2021-08-30T09:52:36+01:00: Evaluation status changed: "pending" -> "complete"
==> 2021-08-30T09:52:36+01:00: Evaluation "a30937c6" finished with status "complete"
==> 2021-08-30T09:52:36+01:00: Monitoring deployment "82f768b8"
  ✓ Deployment "82f768b8" successful

    2021-08-30T09:52:36+01:00
    ID          = 82f768b8
    Job ID      = elife
    Job Version = 4
    Status      = successful
    Description = Deployment completed successfully

    Deployed
    Task Group  Auto Revert  Desired  Placed  Healthy  Unhealthy  Progress Deadline
    elife-web   true         1        1       1        0          2021-08-30T08:53:27Z
```

Alternatively, just run `make deploy`

You can find the allocated port via nomad or consul catalog, e.g. (assuming CONSUL_HTTP_ADDR env var set):

```
curl -s $CONSUL_HTTP_ADDR/v1/catalog/service/elife |  jq '.[0] | .ServiceAddress+":"+(.ServicePort|tostring)' -r
```