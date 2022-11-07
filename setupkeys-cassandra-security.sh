#!/bin/bash

# source: https://dzone.com/articles/setting-up-a-cassandra-cluster-with-ssl

KEY_STORE_PATH="$PWD/cassandra"
mkdir -p "$KEY_STORE_PATH"
KEY_STORE="$KEY_STORE_PATH/cassandra.keystore"
PKS_KEY_STORE="$KEY_STORE_PATH/cassandra.pks12.keystore"
TRUST_STORE="$KEY_STORE_PATH/cassandra.truststore"
PASSWORD=cassandra
CLUSTER_NAME=thp
CLUSTER_PUBLIC_CERT="$KEY_STORE_PATH/CLUSTER_${CLUSTER_NAME}_PUBLIC.cer"
CLIENT_PUBLIC_CERT="$KEY_STORE_PATH/CLIENT_${CLUSTER_NAME}_PUBLIC.cer"

### Cluster key setup.
# Create the cluster key for cluster communication.
keytool -genkey -keyalg RSA -alias "${CLUSTER_NAME}_CLUSTER" -keystore "$KEY_STORE" -storepass "$PASSWORD" -keypass "$PASSWORD" \
-dname "CN=None Image $CLUSTER_NAME cluster, OU=None, O=None, L=None, ST=None, C=PL, DC=test_DC" \
-validity 36500

# Create the public key for the cluster which is used to identify nodes.
keytool -export -alias "${CLUSTER_NAME}_CLUSTER" -file "$CLUSTER_PUBLIC_CERT" -keystore "$KEY_STORE" \
-storepass "$PASSWORD" -keypass "$PASSWORD" -noprompt

# Import the identity of the cluster public cluster key into the trust store so that nodes can identify each other.
keytool -import -v -trustcacerts -alias "${CLUSTER_NAME}_CLUSTER" -file "$CLUSTER_PUBLIC_CERT" -keystore "$TRUST_STORE" \
-storepass "$PASSWORD" -keypass "$PASSWORD" -noprompt
