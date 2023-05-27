# Create a cluster from pyspark

The main goal of this proces is create an pyspark cluster. To run it:

```shell 
chmod +x start.sh
./start.sh
```

## Test
To purpouse of a test I've include some code to check if cluster runs properly. It could be run in the master with this script:

```shell
./bin/spark-submit --master spark://spark-master:7077 script/main.py

```
## Uninstall the cluster
If we want to uninstall this cluster we could use: 

```shell
docker compose down --rmi all -v --remove-orphans
```

