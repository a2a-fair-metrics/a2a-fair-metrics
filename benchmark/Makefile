## 
## For deployment on https://s11.no/2022/a2a-fair-metrics/
## by Stian Soiland-Reyes
BASE=/files/web/vhosts/s11.no/2022/a2a-fair-metrics/
PID_BASE=https://w3id.org/a2a-fair-metrics/
URL_BASE=https://s11.no/2022/a2a-fair-metrics/

all: clean deploy

linkset.txt: [0-9]*
	cp linkset.txt.template linkset.txt
	for d in [0-9]* ; do echo "<${PID_BASE}$$d/>;\n  rel=\"item\";\n  anchor=\"${URL_BASE}\";\n  type=\"text/html\"\n" >> linkset.txt ; done

deploy: linkset.txt
	test -d `dirname $(BASE)`
	mkdir -p ${BASE}
	cp -vr README.html HEADER.html .htaccess linkset.jsonld cc-zero.svg [0-9]* ${BASE}
	chmod -R a+rX ${BASE}
	
clean:
	rm -rf ${BASE} linkset.txt

docker-image: Dockerfile httpd.conf
	docker build -t a2abenchmark .

docker: docker-image
	docker run -p 8080:80 a2abenchmark	
