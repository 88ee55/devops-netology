# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

Dockerfile
```
FROM centos:7
ENV ELASTICSEARCH_VERSION=7.12.1
ENV ELASTICSEARCH_USER=es
RUN adduser $ELASTICSEARCH_USER
RUN \
  yum install -y wget perl-Digest-SHA && \
  yum clean all && \
  rm -rf /var/cache
RUN install -o $ELASTICSEARCH_USER -g $ELASTICSEARCH_USER -d /var/lib/elasticsearch
USER $ELASTICSEARCH_USER
WORKDIR /home/$ELASTICSEARCH_USER
RUN \
  wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz && \
  wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz.sha512 && \
  shasum -a 512 -c elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz.sha512 && \
  tar -xzf elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz && \
  rm -f elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz*
RUN \
  sed -i 's/^#node.name.*/node.name: \${NODENAME}/' elasticsearch-${ELASTICSEARCH_VERSION}/config/elasticsearch.yml && \
  sed -i 's/^#path.data.*/path.data: \${PATHDATA}/' elasticsearch-${ELASTICSEARCH_VERSION}/config/elasticsearch.yml && \
  echo 'http.bind_host: 0.0.0.0' >> elasticsearch-${ELASTICSEARCH_VERSION}/config/elasticsearch.yml
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["elasticsearch-${ELASTICSEARCH_VERSION}/bin/elasticsearch"]
```

Ссылка на образ 88ee55/netology:0605

curl http://localhost:9200
```
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "d-sPNwfjRX6gqRpIlHmzZA",
  "version" : {
    "number" : "7.12.1",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "3186837139b9c6b6d23c3200870651f10d3343b7",
    "build_date" : "2021-04-20T20:56:39.040728659Z",
    "build_snapshot" : false,
    "lucene_version" : "8.8.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```


  
## Задача 2
 ```
curl -X PUT "http://localhost:9200/ind-1" -H 'Content-Type: application/json' -d '
 {
  "settings" : {
    "number_of_shards" : 1,
    "number_of_replicas" : 0
  }
}
'
```
```
curl -X PUT "http://localhost:9200/ind-2" -H 'Content-Type: application/json' -d '
 {
  "settings" : {
    "number_of_shards" : 2,
    "number_of_replicas" : 1
  }
}
'
```
```
curl -X PUT "http://localhost:9200/ind-3" -H 'Content-Type: application/json' -d '
 {
  "settings" : {
    "number_of_shards" : 4,
    "number_of_replicas" : 2
  }
}
'
```

curl "http://localhost:9200/_cat/indices"
```
green  open ind-1 Kpkp2VVJSWi1WffKvEy9-w 1 0 0 0 208b 208b
yellow open ind-3 dwQdLlnUQvK-aqcBzfw1lQ 4 2 0 0 832b 832b
yellow open ind-2 T4fKf4FUSlCOp5dsg9EQjA 2 1 0 0 416b 416b
```

curl "http://localhost:9200/_cluster/health?pretty=true"
```
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 7,
  "active_shards" : 7,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 41.17647058823529
}
```

Индексы ind-2 и ind-3 находятся в состоянии yellow, тк они не реплицировались на указанное количство реплик (реплики у нас не подняты)

```
curl -X DELETE "http://localhost:9200/ind*"
```

## Задача 3

```
curl -X PUT "http://localhost:9200/_snapshot/netology_backup" -H 'Content-Type: application/json' -d '
{
  "type": "fs",
  "settings": {
    "location": "netology_backup"
  }
}
'

{"acknowledged":true}
```
```
curl -X PUT "http://localhost:9200/test" -H 'Content-Type: application/json' -d '
 {
  "settings" : {
    "number_of_shards" : 1,
    "number_of_replicas" : 0
  }
}
'

curl "http://localhost:9200/_cat/indices"
green open test J27BUVtMSA28DqCjC5XjKw 1 0 0 0 208b 208b
```

```
curl -X PUT "http://localhost:9200/_snapshot/netology_backup/snapshot_1"
```
```
index-0
index.latest
indices
meta-aUP4Ud66RjOyNJkcYj6tcw.dat
snap-aUP4Ud66RjOyNJkcYj6tcw.dat
```

```
curl -X DELETE "http://localhost:9200/test"
curl -X PUT "http://localhost:9200/test-2"
curl "http://localhost:9200/_cat/indices"
yellow open test-2 Zrfwt92RRUC9FfZTjO4ALQ 1 1 0 0 208b 208b
```
```
curl -X POST "http://localhost:9200/_snapshot/netology_backup/snapshot_1/_restore"
curl "http://localhost:9200/_cat/indices"

yellow open test-2 Zrfwt92RRUC9FfZTjO4ALQ 1 1 0 0 208b 208b
green  open test   BEaUImFzSMGEhSxoFOfa8g 1 0 0 0 208b 208b
```