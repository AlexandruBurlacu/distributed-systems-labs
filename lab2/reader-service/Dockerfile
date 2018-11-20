FROM clojure

RUN mkdir /app
COPY . /app

WORKDIR /app

RUN lein deps

CMD ["lein", "run", "src/run.clj"]
