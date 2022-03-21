all: clean deploy

deploy:
	test -d /files/web/vhosts/s11.no/2022
	mkdir -p /files/web/vhosts/s11.no/2022/a2a-fair-metrics/
	cp -vr README.html .htaccess [0-9]* /files/web/vhosts/s11.no/2022/a2a-fair-metrics/
	chmod -R a+rX /files/web/vhosts/s11.no/2022/a2a-fair-metrics/
	
clean:
	rm -rf /files/web/vhosts/s11.no/2022/a2a-fair-metrics/
