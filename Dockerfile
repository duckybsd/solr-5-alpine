#
# Based on:
#
# 1) docker-library/openjdk
#    https://github.com/docker-library/openjdk/blob/8f8d04a5f77116be8ebfcaf84e4fcbd1190b95e8/8-jre/alpine
#
# 2) docker-solr/docker-solr
#    https://github.com/docker-solr/docker-solr/tree/b8c4d759249af569e169d249fb667f79a230a0c0/5.5/alpine
#

FROM wodby/base-alpine:edge

ENV LANG C.UTF-8
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
ENV PATH $PATH:$JAVA_HOME/bin
ENV JAVA_VERSION 8u92
ENV JAVA_ALPINE_VERSION 8.92.14-r1
ENV SOLR_VERSION 5.5.1
ENV SOLR_URL http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz

RUN export SEARCH_API_SOLR_7_VERSION="7.x-1.10" && \
    export SEARCH_API_SOLR_8_VERSION="8.x-1.0-alpha4" && \

    # Install JRE
    apk add --no-cache \
        tar \
        openjdk8-jre="$JAVA_ALPINE_VERSION" && \

    export JAVA_HOME=/usr && \

    # Install Solr
    mkdir -p /opt/solr && \
    wget $SOLR_URL -O /opt/solr.tgz && \
    wget $SOLR_URL.asc -O /opt/solr.tgz.asc && \
    tar -C /opt/solr --extract --file /opt/solr.tgz --strip-components=1 && \
    rm -rf \
        /opt/solr.tgz* \
        /opt/solr/docs \
        /opt/solr/licenses \
        /opt/solr/*.txt \
        /opt/solr/dist \
        /opt/solr/example && \
    mkdir -p /opt/solr/server/solr/lib && \
    sed -i -e 's/#SOLR_PORT=8983/SOLR_PORT=8983/' /opt/solr/bin/solr.in.sh && \
    sed -i -e '/-Dsolr.clustering.enabled=true/ a SOLR_OPTS="$SOLR_OPTS -Dsun.net.inetaddr.ttl=60 -Dsun.net.inetaddr.negative.ttl=60"' /opt/solr/bin/solr.in.sh && \
    chown -R $WODBY_USER:$WODBY_GROUP /opt/solr && \

    # Download default Solr config for Drupal 7, 8.
    export SAS_CONFIG_DIR=solr-conf/5.x && \
    mkdir -p /opt/solr_defaults && \

    export DRUPAL_VERSION=7 && \
    export SAS_VERSION=$SEARCH_API_SOLR_7_VERSION && \
    wget -qO- https://ftp.drupal.org/files/projects/search_api_solr-${SAS_VERSION}.tar.gz | tar xz -C /tmp && \
    mkdir -p /opt/solr_defaults/config/drupal-${DRUPAL_VERSION} && \
    cp /tmp/search_api_solr/$SAS_CONFIG_DIR/* /opt/solr_defaults/config/drupal-${DRUPAL_VERSION}/ && \
    rm -rf /tmp/search_api_solr && \

    export DRUPAL_VERSION=8 && \
    export SAS_VERSION=$SEARCH_API_SOLR_8_VERSION && \
    wget -qO- https://ftp.drupal.org/files/projects/search_api_solr-${SAS_VERSION}.tar.gz | tar xz -C /tmp && \
    mkdir -p /opt/solr_defaults/config/drupal-${DRUPAL_VERSION} && \
    cp /tmp/search_api_solr/$SAS_CONFIG_DIR/* /opt/solr_defaults/config/drupal-${DRUPAL_VERSION}/ && \
    rm -rf /tmp/search_api_solr

COPY rootfs /
