FROM golang

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

ENTRYPOINT ["./filebeat"]
CMD ["-e","-c","/etc/filebeat/filebeat.yml"]
