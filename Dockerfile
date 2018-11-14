FROM jahrik/arm-gosu-tini:armv7l

# Add filebeat user and group first to make sure their IDs get assigned consistently
RUN groupadd -r filebeat && useradd -r -m -g filebeat filebeat
ENV GOSU_USER filebeat

# Dependencies
RUN apt-get update && apt-get install -y \
  wget \
  && rm -rf /var/lib/apt/lists/*

# Filebeat
# https://www.elastic.co/guide/en/filebeat/5.6/docker.html
# https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.4.3-linux-x86.tar.gz
ENV FB_VERSION 5.6.12
ENV FB_URL https://artifacts.elastic.co/downloads/beats/filebeat/
ENV FB_HOME /usr/share/filebeat
WORKDIR ${FB_HOME}
RUN wget ${FB_URL}filebeat-${FB_VERSION}-i386.deb && \
  dpkg -i filebeat-${FB_VERSION}i386.deb && \
  rm filebeat-${FB_VERSION}.deb

ENV PATH ${FB_HOME}/bin:$PATH

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 5000 5044
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["filebeat"]
