# Simple and functional thehive4 instance using docker compose


## 1. Check cassandra cluster.
```
docker exec cass1 nodetool status
```

## 2. Accessibility setting on 'vol' dir.
```
sudo chown -R 1000:1000 vol
sudo chmod -R u+rwX,go+rX,go-w vol  # set directories to 755 but files to 644
```

## 3. Repair cassandra datacenter. https://docs.datastax.com/en/cassandra-oss/3.x/cassandra/tools/toolsRepair.html
```
docker exec cass1 nodetool repair -dc test_DC
```

## 4. Cleans up keyspaces and partition keys no longer belonging to a node.
```
docker exec cass1 nodetool cleanup  # clean all keyspace
```

### Cassandra cluster with 3 nodes.
Two node must working to edit and delete information in thehive4 with replication equal to 3. For adding information (eg alerts) one node is enough.
