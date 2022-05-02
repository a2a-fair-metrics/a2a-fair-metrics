FROM httpd:2.4
COPY httpd.conf /usr/local/apache2/conf/httpd.conf
RUN rm /usr/local/apache2/htdocs/index.html
COPY . /usr/local/apache2/htdocs/

# Add our fake self-signed SSL certificate
COPY .ssl/s11-fake/server.* conf/

# For testing against our fake clones of w3id
# .. and s11.no
COPY .ssl/s11-fake/server.crt /etc/ssl/certs/ca-certificates.crt
RUN cat conf/server.crt >> /etc/ssl/certs/ca-certificates.crt

# Avoid w3id.org base URI in directory listing
RUN sed -i "/base.href/d" /usr/local/apache2/htdocs/HEADER.html
