## 
## For deployment on https://s11.no/2022/a2a-fair-metrics/
## by Stian Soiland-Reyes
#BASE=/files/web/vhosts/s11.no/2022/a2a-fair-metrics/
BASE=/home/stain/src/s11.no/static/2022/a2a-fair-metrics/
#BASE=/files/web/vhosts/dev.s11.no/2022/a2a-fair-metrics/
PID_BASE=https://w3id.org/a2a-fair-metrics/
#PID_BASE=https://dev.s11.no/2022/a2a-fair-metrics/
URL_BASE=https://s11.no/2022/a2a-fair-metrics/
#URL_BASE=https://dev.s11.no/2022/a2a-fair-metrics/

all: clean deploy

dependencies:
	docker ps -q >/dev/null

linkset.txt: [0-9]*
	cp linkset.txt.template linkset.txt
	for d in [0-9]* ; do echo "<${PID_BASE}$$d/>;\n  rel=\"item\";\n  anchor=\"${URL_BASE}\";\n  type=\"text/html\",\n" >> linkset.txt ; done
	## To ensure we don't terminate with , we'll add the 404 entry last
	echo "<${PID_BASE}/00-404-not-found/>;\n  rel=\"item\";\n  anchor=\"${URL_BASE}\";\n  type=\"text/html\"" >> linkset.txt

resources: linkset.txt README.html HEADER.html .htaccess linkset.jsonld cc-zero.svg [0-9]*

deploy: resources
	test -d `dirname $(BASE)`
	mkdir -p ${BASE}
	cp -vr README.html HEADER.html .htaccess linkset.txt linkset.jsonld cc-zero.svg [0-9]* ${BASE}
	chmod -R a+rX ${BASE}
	
clean:
	rm -rf ${BASE} linkset.txt

docker-image: dependencies Dockerfile httpd.conf resources
	docker build -t a2abenchmark .

docker: dependencies docker-image
	echo "Starting Apache httpd on http://localhost:8080/"
	docker run -p 8080:80 a2abenchmark	

