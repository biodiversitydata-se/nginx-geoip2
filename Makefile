build:
	docker build -t nginx-geoip2 .

run:
	docker run --rm --detach --name nginx-geoip2 --publish 80:80  nginx-geoip2

release:
	../sbdi-install/utils/make-release.sh
