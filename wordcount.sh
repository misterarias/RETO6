#!/bin/sh
[ ! -f quijote.txt ] && \
  wget http://latel.upf.edu/traductica/scp/quijote/quijote.txt > quijote.txt
docker cp quijote.txt namenode:/tmp/
docker exec -ti namenode hadoop fs -rm -R -f /tmp/
docker exec -ti namenode hadoop fs -mkdir /tmp/
docker exec -ti namenode hadoop fs -put /tmp/quijote.txt  /tmp/

docker exec -ti jobmanager  /usr/local/flink/bin/flink run  /usr/local/flink/examples/streaming/WordCount.jar --input hdfs://namenode:8020/tmp/quijote.txt --output hdfs://namenode:8020/tmp/result.txt
docker exec -ti namenode hadoop fs -get /tmp/result.txt /tmp/
docker cp namenode:/tmp/result.txt .
echo "Voilá"
