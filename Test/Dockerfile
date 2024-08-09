FROM alpine:latest
RUN apk update && apk add --no-cache \
    build-base \
    cmake
WORKDIR /app
COPY . /app
RUN wget https://www.sqlite.org/2018/sqlite-amalgamation-3260000.zip && \
    unzip sqlite-amalgamation-3260000.zip
RUN mkdir build && \
    cd build && \
    cmake .. && \
    cmake --build .
CMD ["ls", "-l", "/app/build"]
