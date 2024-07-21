FROM golang:1.22 as base

WORKDIR /app

# Dependencies are stored in that file
COPY go.mod .

# Download Dependencies for the app = requirements.txt in Python
RUN go mod download 

COPY . .

# Artifact will be created inside the image
RUN go build -o main .

# Second Stage / Distroless Image

FROM gcr.io/distroless/base

COPY --from=base /app/main .

COPY --from=base /app/static ./static

EXPOSE 8080 

CMD ["./main"]

