# Layer - Image
ARG jdk_version
FROM openjdk:${jdk_version}

# Layer  - Arguments in dockerfile
ARG spark_version
ARG hadoop_version
ARG shared_wk
ARG py_cmd


# Layer - OS + Directories 
RUN apt-get update -y
RUN mkdir -p ${shared_wk}/data 
RUN mkdir -p /usr/share/man/man1
RUN ln -s /usr/bin/python3 
RUN ln -s /urs/bin/python

# Layer - Prequistes
RUN apt-get -y install curl
RUN apt-get -y install vim 
RUN apt-get -y install python3

# Download the info about PySpark
RUN curl https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz -o spark.tgz  
RUN tar -xvzf spark.tgz
RUN mv spark-${spark_version}-bin-hadoop${hadoop_version} /usr/bin/ 
RUN echo "alias pyspark=/usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/bin/pyspark" >> ~/.bashrc 
RUN echo "alias spark-shell=/usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/bin/spark-shell" >> ~/.bashrc
RUN mkdir /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/logs
RUN rm spark.tgz
RUN echo "JAVA_HOME"

# Layer - Enviorment Out
ENV SPARK_HOME /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}
ENV SPARK_MASTER_HOST spark-master    
ENV SPARK_MASTER_PORT 7077   
ENV PYSPARK_PYTHON python3   

# Layer - Move files to execute
## Data of the execution
RUN mkdir -p /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/src 
COPY ./src/*  /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/src/
## Script of the execution
RUN mkdir -p /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/script 
COPY ./script/*  /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/script/

# Layer - Volume & workdir 
VOLUME ${shared_wk}
WORKDIR ${SPARK_HOME}

# Layer - Keep the logs
# CMD bin/spark-class org.apache.spark.deploy.master.Master >> logs/spark-master.out
#CMD bin/spark-class org.apache.spark.deploy.worker.Worker spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT} >> logs/spark-worker.out

