FROM golang

RUN mkdir /app
WORKDIR /app
COPY . .

RUN go get -d -v ./...
RUN go test -c -covermode=set -coverpkg=./... -o test-exec

EXPOSE 8080

ENTRYPOINT exec /app/test-exec -test.v -test.coverprofile=/tmp/coverage/demo.cov
