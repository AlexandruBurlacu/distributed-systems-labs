FROM clojure

RUN mkdir /app
WORKDIR /app

COPY project.clj /app
RUN lein deps

COPY . /app

CMD ["lein", "run", "src/core.clj"]
