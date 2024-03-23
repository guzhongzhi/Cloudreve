FROM golang:1.19 AS builder
WORKDIR /app
COPY . ./
RUN /bin/sh -c "go env -w GOPROXY=https://goproxy.cn"
RUN /bin/sh -c "go build -o cloudreve main.go"

#---
FROM alpine:latest

WORKDIR /cloudreve


RUN apk update
RUN apk add --no-cache tzdata
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" > /etc/timezone
RUN chmod +x ./cloudreve 
RUN mkdir -p /data/aria2 
RUN chmod -R 766 /data/aria2
    
COPY --from=builder /app/cloudreve ./cloudreve


EXPOSE 5212
VOLUME ["/cloudreve/uploads", "/cloudreve/avatar", "/data"]

ENTRYPOINT ["./cloudreve"]
