# New session
#  cd /usr/bin/spark-3.4.0-bin-hadoop3/bin   
# ./bin/spark-submit --master spark://spark-master:7077 --conf spark.dynamicAllocation.enable=False --driver-memory g --executorscript/main.py
from pyspark.sql import SparkSession


spark = SparkSession.builder.getOrCreate()
df = spark.read.options(header='True',inferschema='True').csv("src/Travel\ Company\ New\ Clients.csv")
df.count()
df.printSchema()
df.select("FamilyMembers").distinct().show()

def myFunc(s):
    return [ ( s["FamilyMembers"],1)]

lines=df.rdd.flatMap(myFunc).reduceByKey(lambda a, b: a + b)
