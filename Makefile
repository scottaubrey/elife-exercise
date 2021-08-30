build-php-updater:
	docker build php-updater -t php-updater

build-nginx:
	docker build mynginx -t mynginx

build:
	make build-php-updater
	make build-nginx

build-and-test:
	docker stop mynginx-test | true  # clean up failed test run (if any)
	docker stop php-updater-test | true # clean up failed test run (if any)
	make build-php-updater
	make build-nginx
	docker run --rm -d -v public:/usr/share/nginx/html --name mynginx-test -p 8080:80 mynginx
	docker run --rm -d -v public:/var/www --name php-updater-test php-updater
	make test
	docker stop mynginx-test php-updater-test

run:
	docker run --rm -d -v public:/usr/share/nginx/html --name mynginx -p 8080:80 mynginx
	docker run --rm -d -v public:/var/www --name php-updater php-updater

stop:
	docker stop mynginx php-updater

test:
	tests/e2e-test
