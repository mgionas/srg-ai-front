# Dockerfile

# --- STAGE 1: Builder ---
# This stage installs dependencies and builds the Next.js app
FROM node:20 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock, pnpm-lock.yaml)
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Build the application for production
RUN npm run build


# --- STAGE 2: Production ---
# This stage creates the final, lightweight image for deployment
FROM node:20-alpine

WORKDIR /app

# Copy only the necessary build artifacts from the 'builder' stage
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Expose the port Next.js runs on
EXPOSE 3000

# The command to start the app in production
CMD ["npm", "start"]