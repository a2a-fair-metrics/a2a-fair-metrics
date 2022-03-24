FROM httpd:2.4
COPY httpd.conf /usr/local/apache2/conf/httpd.conf
RUN rm /usr/local/apache2/htdocs/index.html
COPY . /usr/local/apache2/htdocs/
# Avoid w3id.org base URI
RUN sed -i "/base.href/d" /usr/local/apache2/htdocs/HEADER.html
