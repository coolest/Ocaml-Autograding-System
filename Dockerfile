FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:avsm/ppa && \
    apt-get update

COPY source /autograder/source

WORKDIR /autograder/source

CMD ["sh", "/autograder/run_autograder"]