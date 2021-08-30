build-php-updater:
	docker build php-updater -t php-updater -t ghcr.io/scottaubrey/php-updater --platform linux/amd64

build-nginx:
	docker build mynginx -t mynginx -t ghcr.io/scottaubrey/mynginx --platform linux/amd64

build:
	make build-php-updater
	make build-nginx

build-and-test:
	docker stop mynginx-test | true  # clean up failed test run (if any)
	docker stop php-updater-test | true # clean up failed test run (if any)
	make build-php-updater
	make build-nginx
	docker run --platform linux/amd64 --rm -d -v public:/usr/share/nginx/html --name mynginx-test -p 8080:80 mynginx
	docker run --platform linux/amd64 --rm -d -v public:/var/www --name php-updater-test php-updater
	sleep 1
	make test
	docker stop mynginx-test php-updater-test

push:
	docker push ghcr.io/scottaubrey/php-updater
	docker push ghcr.io/scottaubrey/mynginx

run:
	docker run --platform linux/amd64 --rm -d -v public:/usr/share/nginx/html --name mynginx -p 8080:80 mynginx
	docker run --platform linux/amd64 --rm -d -v public:/var/www --name php-updater php-updater

stop:
	docker stop mynginx php-updater

test:
	tests/e2e-test
