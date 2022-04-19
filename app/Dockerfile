FROM golang:buster as build

WORKDIR /app

COPY *.go ./
COPY *.mod ./

RUN go build -o /app/http-chunked

FROM gcr.io/distroless/base-debian10
WORKDIR /
EXPOSE 8080
COPY --from=build /app/http-chunked /http-chunked
USER nonroot:nonroot
ENTRYPOINT ["/http-chunked"]