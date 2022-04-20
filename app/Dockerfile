FROM golang:alpine as build

WORKDIR /app

COPY *.go ./
COPY *.mod ./

RUN go build -o /app/http-chunked

FROM alpine
WORKDIR /
EXPOSE 8080
COPY --from=build /app/http-chunked /http-chunked
USER 1000:1000
ENTRYPOINT ["/http-chunked"]