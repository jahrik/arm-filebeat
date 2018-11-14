FROM jahrik/arm-gosu-tini:armv7l

# Add filebeat user and group first to make sure their IDs get assigned consistently
RUN groupadd -r filebeat && useradd -r -m -g filebeat filebeat
ENV GOSU_USER filebeat

# Dependencies
RUN apt-get update && apt-get install -y \
  apt-transport-https \
  wget \
  && rm -rf /var/lib/apt/lists/*

# Filebeat
# https://www.elastic.co/guide/en/filebeat/5.6/docker.html
# https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.4.3-linux-x86.tar.gz
ENV FB_VERSION 5.6.12
ENV FB_URL https://artifacts.elastic.co/downloads/beats/filebeat/
ENV FB_HOME /usr/share/filebeat
WORKDIR ${FB_HOME}
RUN wget -qO - \
  https://artifacts.elastic.co/GPG-KEY-elasticsearch | \
  apt-key add -
RUN echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | \
  tee -a /etc/apt/sources.list.d/elastic-5.x.list
RUN apt-get update && apt-get install -y \
  filebeat-${FB_VERSION} \
  && rm -rf /var/lib/apt/lists/*

ENV PATH ${FB_HOME}/bin:$PATH

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 5000 5044
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["filebeat"]
