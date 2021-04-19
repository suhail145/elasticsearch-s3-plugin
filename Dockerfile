FROM elasticsearch:7.10.1
MAINTAINER cis.support@amadeus.com

LABEL name="elasticsearch"

ENV PLUGIN=repository-s3

ENV PLUGIN_URL=artifacts.elastic.co:443

RUN yum install -y openssl \
    && yum clean all \
    && openssl s_client  -showcerts -verify 5 -connect ${PLUGIN_URL} < /dev/null | awk '/BEGIN/,/END/{ if(/BEGIN/){a++}; out="/tmp/cert"a".crt"; print >out}' \
    && cp /tmp/cert*.crt /etc/pki/ca-trust/source/anchors/ \
    && update-ca-trust extract \
    && bin/elasticsearch-plugin install --batch ${PLUGIN}

