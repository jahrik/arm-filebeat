FROM jahrik/arm-gosu-tini:armv7l

# Add filebeat user and group first to make sure their IDs get assigned consistently
RUN groupadd -r filebeat && useradd -r -m -g filebeat filebeat
ENV GOSU_USER filebeat

# Dependencies
RUN apt-get update && apt-get install -y \
  wget \
  tar \
  && rm -rf /var/lib/apt/lists/*

# Filebeat
# https://www.elastic.co/guide/en/filebeat/5.6/docker.html
ENV FB_VERSION 5.6.12
ENV FB_URL https://artifacts.elastic.co/downloads/beats/filebeat/
ENV FB_HOME /usr/share/filebeat
WORKDIR ${FB_HOME}
RUN wget ${FB_URL}filebeat-${FB_VERSION}-linux-x86.tar.gz \
  && tar xzvf filebeat-${FB_VERSION}-linux-x86.tar.gz \
    -C ${FB_HOME} --strip-components 1 \
  && rm filebeat-${FB_VERSION}-linux-x86.tar.gz

ENV PATH ${FB_HOME}/bin:$PATH

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 5000 5044
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["filebeat","-e","-c","/etc/filebeat/filebeat.yml"]
