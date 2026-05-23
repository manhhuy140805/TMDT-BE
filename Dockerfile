# ============================================
# Stage 1: Install dependencies
# ============================================
FROM node:22-alpine AS deps

WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install all dependencies (including devDependencies for build)
RUN npm ci

# ============================================
# Stage 2: Build the application
# ============================================
FROM node:22-alpine AS builder

WORKDIR /app

# Copy dependencies from previous stage
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Generate Prisma client
RUN DATABASE_URL="postgresql://dummy:dummy@localhost:5432/dummy" npx prisma generate

# Build NestJS application
RUN npm run build

# ============================================
# Stage 3: Production image
# ============================================
FROM node:22-alpine AS production

WORKDIR /app

# Set environment
ENV NODE_ENV=production

# Install only production dependencies
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# Copy Prisma schema & migrations (needed for prisma migrate deploy)
COPY prisma ./prisma
COPY prisma.config.ts ./

# Generate Prisma client in production node_modules
RUN DATABASE_URL="postgresql://dummy:dummy@localhost:5432/dummy" npx prisma generate

# Copy built application from builder stage
COPY --from=builder /app/dist ./dist

# Expose the application port
EXPOSE 8080

# Start the application
# Run migrations then start the server
CMD ["sh", "-c", "npx prisma migrate deploy && node dist/main"]
