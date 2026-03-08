# Stage 1: Build (Node.js v25.8.0 / Alpine v3.23.3)
FROM node:25.8.0-alpine3.23 AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build:full

# Stage 2: Runtime (Using your preferred gostatic)
FROM pierrezemb/gostatic

# Copy only the compiled production files
COPY --from=builder /app/dist /srv/http/

EXPOSE 8080

CMD ["-port", "8080", "-https-promote", "-enable-logging"]
