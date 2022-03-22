## 
## For deployment on https://s11.no/2022/a2a-fair-metrics/
## by Stian Soiland-Reyes
BASE=/files/web/vhosts/s11.no/2022/a2a-fair-metrics/

all: clean deploy

deploy:
	test -d `dirname $(BASE)`
	mkdir -p ${BASE}
	cp -vr README.html HEADER.html .htaccess linkset.jsonld cc-zero.svg [0-9]* ${BASE}
	chmod -R a+rX ${BASE}
	
clean:
	rm -rf ${BASE}
