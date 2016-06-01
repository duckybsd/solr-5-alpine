#
# Based on:
#
# 1) docker-library/openjdk
#    https://github.com/docker-library/openjdk/blob/8f8d04a5f77116be8ebfcaf84e4fcbd1190b95e8/8-jre/alpine
#
# 2) docker-solr/docker-solr
#    https://github.com/docker-solr/docker-solr/tree/b8c4d759249af569e169d249fb667f79a230a0c0/5.5/alpine
#

FROM alpine:3.3

ENV LANG C.UTF-8
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
ENV PATH $PATH:$JAVA_HOME/bin

ENV JAVA_VERSION 8u92
ENV JAVA_ALPINE_VERSION 8.92.14-r0

RUN apk add --no-cache \
        openjdk8-jre="$JAVA_ALPINE_VERSION"
