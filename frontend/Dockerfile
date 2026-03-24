# Multi-stage Dockerfile for Nuxt 3
# Supports both development (hot reload) and production modes

FROM node:20-alpine AS development

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

EXPOSE 3000 24678

CMD ["npm", "run", "dev"]

FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

FROM node:20-alpine AS production

WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder /app/.output /app/.output
COPY --from=builder /app/package.json /app/

RUN npm ci --production

EXPOSE 3000

USER node

CMD ["node", ".output/server/index.mjs"]
