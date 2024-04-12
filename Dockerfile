FROM ubuntu:18.04
MAINTAINER MLPerf MLBox Working Group

# Remove all stopped containers: docker rm $(docker ps -a -q)
# Remove containers like none:none: docker rmi $(docker images | grep none | awk '{print $3}')

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
            software-properties-common \
            python3-dev \
            curl && \
    rm -rf /var/lib/apt/lists/*

# Ubuntu 18.04 provides python 3.6
RUN curl -fSsL -O https://bootstrap.pypa.io/pip/3.6/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py

COPY requirements.txt /requirements.txt
RUN pip3 install --no-cache-dir -r /requirements.txt

COPY mnist.py /workspace/mnist.py

COPY mlcube.yaml /mlcube/mlcube.yaml
COPY workspace/data.yaml /mlcube/workspace/data.yaml
COPY workspace/train.yaml /mlcube/workspace/train.yaml

ENTRYPOINT ["python3", "/workspace/mnist.py"]
