FROM node:16-alpine
RUN mkdir -p /gaus
WORKDIR /gaus
RUN npm install markdown-spellcheck -g
COPY . .

RUN mdspell "docs/*.md" README.md curl/README.md --report --ignore-numbers
