# --- STAGE 1: Builder ---
FROM node:20 AS builder

# Set the working directory
WORKDIR /app

# Copy package.json
COPY package*.json ./

# Install  dependencies
RUN npm install

# Copy source code
COPY . .

# Build the application
RUN npm run build


# --- STAGE 2: Production ---
FROM node:20-alpine
RUN apk add --no-cache bash

WORKDIR /app

# Copy only the necessary build artifacts
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# start the app
CMD ["npm", "start"]