build:
	docker build -t nginx-geoip2 .

release:
	../sbdi-install/utils/make-release.sh
