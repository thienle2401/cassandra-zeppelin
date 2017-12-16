# create directory for data from the dockers

mkdir -p /docker-data/cassandra
mkdir -p /docker-data/zeppelin
mkdir -p /docker-data/shared
chmod -R 777 /docker-data

docker run -d \
--memory-reservation 5500M \
--memory 6000M \
-p 7000:7000 \
-p 7001:7001 \
-p 9042:9042 \
-p 9160:9160 \
-p 7199:7199 \
--name cassandra \
--mount type=bind,source=/docker-data/cassandra,target=/var/lib/cassandra \
cassandra:3.9

# https://hub.docker.com/r/xemuliam/zeppelin/

docker run -d \
--memory-reservation 4000M \
--memory 4500M \
-p 8080:8080 \
-p 8081:8081 \
-p 4040:4040 \
-e MASTER="local[*]" \
-e ZEPPELIN_PORT="8080" \
-e ZEPPELIN_JAVA_OPTS="-Dspark.driver.memory=1g -Dspark.executor.memory=2g" \
-e SPARK_SUBMIT_OPTS="--conf spark.driver.host=localhost --conf spark.driver.port=8081" \
--link cassandra:cassandra \
--name zeppelin \
--mount type=bind,source=/docker-data/zeppelin,target=/opt/zeppelin/notebook \
--mount type=bind,source=/docker-data/shared,target=/shared \
xemuliam/zeppelin
