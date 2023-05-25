FROM openjdk:8-jre-slim
# Layer - Metadata

ARG build_date
ARG shared_wk=/opt/workspace


LABEL org.label-schema.build-date=${build_date}
LABEL org.label-schema.name="Apache Base"


# Layer - OS + Python 

RUN mkdir -p ${shared_wk}/data 
RUN mkdir -p /usr/share/man/man1
RUN apt-get update -y 
RUN ln -s /usr/bin/python3 
RUN ln -s /urs/bin/python

# - Get version

ARG spark_version="3.4.0"
ARG hadoop_version="3"
ARG tipo
ARG tipomaster="master"

# - Download Apache 

RUN apt-get -y install curl
RUN curl https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz -o spark.tgz  
RUN tar -xvzf spark.tgz
RUN mv spark-${spark_version}-bin-hadoop${hadoop_version} /usr/bin/ 
RUN echo "alias pyspark=/usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/bin/pyspark" >> ~/.bashrc 
RUN echo "alias spark-shell=/usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/bin/spark-shell" >> ~/.bashrc
RUN mkdir /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/logs
RUN rm spark.tgz

ENV SPARK_HOME /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}
ENV SPARK_MASTER_HOST spark-master
ENV SPARK_MASTER_PORT 7077
ENV PYSPARK_PYTHON python3

# -- Runtime


VOLUME ${shared_wk}
WORKDIR ${SPARK_HOME}

RUN bash -c "if ['${tipo}' == 'worker']; then echo 'bin/spark-class org.apache.spark.deploy.worker.Worker spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT} >> logs/spark-worker.out' > run.sh;else  echo 'bin/spark-class org.apache.spark.deploy.master.Master >> logs/spark-master.out'> run.sh;fi"
RUN chmod +x ./run.sh
CMD ./run.sh
#CMD bin/spark-class org.apache.spark.deploy.master.Master >> logs/spark-master.out
#CMD if [[-z "tipo"]]; then bin/spark-class org.apache.spark.deploy.master.Master >> logs/spark-master.out; else bin/spark-class org.apache.spark.deploy.worker.Worker spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT} >> logs/spark-worker.out;fi
#CMD ["bin/spark-class","if [\"${tipo}\" = master ]; then org.apache.spark.deploy.master.Master >> logs/spark-master.out;fi"]





