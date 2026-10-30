FROM node:22-slim
RUN apt-get update && apt-get install -y --no-install-recommends openssl ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .
RUN npx prisma generate && npm run build
ENV NODE_ENV=production
EXPOSE 4000
# Applies committed migrations, then starts the API.
CMD ["sh", "-c", "npx prisma migrate deploy && node dist/src/server.js"]
