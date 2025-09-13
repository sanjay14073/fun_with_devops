FROM golang:1.23-alpine as builder

# Set the Current Working Directory inside the container
WORKDIR /app

COPY go.mod ./

RUN go mod tidy

COPY . .

# Build the Go application binary
RUN go build -o main .

# Stage 2: Create the runtime image
FROM alpine:3.20

WORKDIR /app

# Copy the compiled Go binary from the builder stage
COPY --from=builder /app/main .

# copy the static files
COPY --from=builder /app/static /app/static

EXPOSE 8080

CMD ["./main"]