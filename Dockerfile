# Use the official Golang image as the base image
#FROM golang:1.25-alpine AS test
#
## Set the working directory inside the container
#WORKDIR /app
#
## Copy the go.mod file
#COPY go.mod ./
#
## Copy the source code
#COPY main.go ./
#COPY main_test.go ./
#
## Test the Go application
#RUN go test -v ./...
#
## Command to run the executable
#CMD ["./main"]

FROM golang:1.25-alpine AS build

WORKDIR /app
COPY go.mod ./
COPY main.go ./
RUN go build -o main main.go

FROM alpine:3.20

WORKDIR /app
COPY --from=build /app/main ./main
CMD ["./main"]