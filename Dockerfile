FROM golang

RUN mkdir /app
WORKDIR /app
COPY . .

RUN go get -d -v ./...
RUN go test -c -o test-exec -test.coverprofile=/coverage/external.out

EXPOSE 8080

ENTRYPOINT exec /app/test-exec -test.v -test.coverprofile=/coverage/external.out
