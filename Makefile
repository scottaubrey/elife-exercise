build-php-updater:
	docker build php-updater -t php-updater

build-nginx:
	docker build mynginx -t mynginx

build:
	make build-php-updater
	make build-nginx

run:
	docker run --rm -d -v public:/usr/share/nginx/html --name mynginx -p 8080:80 mynginx
	docker run --rm -d -v public:/var/www --name php-updater php-updater

stop:
	docker stop mynginx php-updater
