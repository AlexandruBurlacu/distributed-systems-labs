FROM clojure:latest

RUN apt-get update && apt-get install -y vim

RUN mkdir /service

WORKDIR /service

COPY . /service

CMD ["lein", "run"]

