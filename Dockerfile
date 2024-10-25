# Use Alpine for a smaller image size
FROM node:18.17.0-alpine AS builder

WORKDIR /app
COPY package.json package-lock.json turbo.json ./
RUN npm ci --production
COPY . .

# Build the app
RUN npm run build

# Use a minimal base image for running the production build
FROM node:18.17.0-alpine AS runner

WORKDIR /app

COPY --from=builder /app/build ./build
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules
COPY turbo.json ./


EXPOSE 3000

CMD ["node", "build/index.js"]


# Developer stage for local development
FROM node:18.17.0-alpine AS developer

WORKDIR /app
COPY package.json package-lock.json turbo.json ./
RUN npm ci
COPY . .

EXPOSE 3000
CMD ["npx", "turbo", "dev"]
