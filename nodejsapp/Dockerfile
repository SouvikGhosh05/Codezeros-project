FROM node:22-alpine
RUN apk update && apk upgrade --no-cache
WORKDIR /app
COPY src/* /app/
RUN npm install
EXPOSE 3000
CMD [ "node", "server.js"]