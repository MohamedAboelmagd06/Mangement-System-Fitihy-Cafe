# ---------- Stage 1: Dependencies ----------
FROM node:18-alpine AS deps

WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

# ---------- Stage 2: Production ----------
FROM node:18-alpine AS production

ENV NODE_ENV=production

WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN addgroup -S appgroup && adduser -S appuser -G appgroup && \
    chown -R appuser:appgroup /app
USER appuser

EXPOSE 5000

CMD ["node", "server.js"]
