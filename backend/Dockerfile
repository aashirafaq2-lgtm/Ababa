# STEP 1: Build Stage
FROM node:20-alpine AS builder

WORKDIR /app

# Copy dependency definitions
COPY package*.json ./
RUN npm ci

# Copy source and config
COPY . .
RUN npm run build

# STEP 2: Production Stage
FROM node:20-alpine

WORKDIR /app

# Define production environment
ENV NODE_ENV=production
ENV PORT=5000

# Install production dependencies only
COPY package*.json ./
RUN npm ci --only=production

# Pull built assets from builder
COPY --from=builder /app/dist ./dist

# System hardening: Run as non-root
RUN addgroup -S ahmedbaba && adduser -S ahmedbaba -G ahmedbaba
USER ahmedbaba

EXPOSE 5000

CMD ["node", "dist/server.js"]
