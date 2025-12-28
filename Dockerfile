# Use the official Golang image as the base image
FROM golang:1.25-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod file
COPY go.mod ./

# Copy the source code
COPY main.go ./
COPY main_test.go ./

# Build the Go application
RUN go build -o main main.go

# Command to run the executable
CMD ["./main"]
