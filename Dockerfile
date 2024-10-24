# Use Alpine for a smaller image size
FROM node:18.17.0-alpine AS builder

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# Use a minimal base image for running the production build
FROM node:18.17.0-alpine AS runner


WORKDIR /app
COPY --from=builder /app ./
EXPOSE 3000
CMD ["node", "build/index.js"]


# Developer stage for local development
FROM node:18.17.0-alpine AS developer

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
EXPOSE 3000
CMD ["npx", "turbo", "dev"]
