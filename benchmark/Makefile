## 
## For deployment on https://s11.no/2022/a2a-fair-metrics/
## by Stian Soiland-Reyes
BASE=/files/web/vhosts/s11.no/2022/a2a-fair-metrics/

all: clean deploy

deploy:
	test -d `dirname $(BASE)`
	mkdir -p ${BASE}
	cp -vr .htaccess [0-9]* ${BASE}
	cp README.md ${BASE}/README.html
	chmod -R a+rX ${BASE}
	
clean:
	rm -rf ${BASE}
