# Simple and functional thehive4 instance using docker compose


### TheHive4 
https://localhost
### Cortex   
https://localhost:2443
### n8n      
https://localhost:8765

## Requirements
CPU: >= 4 vCPUs
Memory: >= 16 GB
Hard disk: >= 40 GB

Java 11 ```sudo apt install openjdk-11-jre-headless```

## Initial configuration".
### 1. Update vol/nginx/thehive.conf and vol/nginx/cortex.conf files for nginx as appropriate.
* Update server_name for your fqdn
* Review/modify the configuration for your requirements

### 2. Your certificates.
* Add your certificates to ./vol/ssl
* Update ./vol/nginx/certs.conf with the certificate file names. "/etc/ssl/" must be unchanged because it is the path in docker volume.
* Update .env with the CORTEX_KEY after Cortex has been setup and configured. A restart of TheHive node is required.

### 3. Accessibility setting on 'vol' dir.
```
sudo chown -R 1000:1000 vol
sudo chmod -R u+rwX,go+rX,go-w vol  # set directories to 755 but files to 644
```

## Docker UP.
### 1. Analyze docker-compose.yml and run all images.
``` 
sudo docker network create proxy # create external network for nginx
sudo docker compose up -d
```
### 2. New file will be created.
```
sudo chown -R 1000:1000 vol
sudo chmod -R u+rwX,go+rX,go-w vol
```
### 3. Change "somekey" in vol/thehive/application.conf to api key from cortex

### 4. Enable thehive in nginx
add port 443 to nginx image in docker-compose.yaml
rename vol/nginx/.thehive.conf to vol/nginx/thehive.conf
```
sudo docker compose restart
```
### 5. Add index to elasticsearch (when thehive can't find it). 
Prefix is in field "index-name: thehive" that is defined in thehive4 application.conf.
```
docker exec -it elasticsearch curl -XPUT 'localhost:9200/thehive_global'
```
### 6. Delete cass1/2/3|thehive|elasticsearch data when you get some odd err in thehive logs

## Cassandra.
### 1. Check cassandra cluster.
```
docker exec cass1 nodetool status
```
### 2. Restart nodes if needed.
```
sudo docker compose restart cass2
sudo docker compose restart cass3
```

### 2. Repair cassandra datacenter. 
```
docker exec cass1 nodetool repair -dc test_DC
```

### 3. Cleans up keyspaces and partition keys no longer belonging to a node.
```
docker exec cass1 nodetool cleanup  # clean all keyspace
```

#### Cassandra cluster with 3 nodes.
Two node must working to edit and delete information in thehive4 with replication equal to 3. For adding information (eg alerts) one node is enough.


## Helpfull sources.
https://docs.datastax.com/en/cassandra-oss/3.x/cassandra/tools/toolsRepair.html
https://github.com/TheHive-Project/Docker-Templates
