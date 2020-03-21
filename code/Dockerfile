from golang:1.13.9-alpine3.11

WORKDIR /usr/src/app/

COPY . /usr/src/app

RUN go build -o /usr/src/app/main .

CMD /usr/src/app/main
