FROM node:18-alpine AS builder

LABEL org.opencontainers.image.authors="Adam Dawidziuk"

WORKDIR /usr/app

COPY package.json ./
RUN npm install --production

RUN rm -rf node_modules/**/test \
    node_modules/**/docs \
    node_modules/**/example \
    node_modules/.bin

COPY index.js ./

COPY public ./public

# https://github.com/GoogleContainerTools/distroless
FROM gcr.io/distroless/nodejs:latest

WORKDIR /usr/app

COPY --from=builder /usr/app /usr/app

EXPOSE 3000

HEALTHCHECK --interval=10s --timeout=1s \
  CMD curl -f http://localhost:3000/ || exit 1

CMD ["index.js"]
