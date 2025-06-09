FROM node:18

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

ENV SECRET_WORD=mycloudquest

EXPOSE 8080

CMD ["node", "index.js"]
