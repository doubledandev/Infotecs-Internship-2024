# Сборка SQLite библиотеки с использованием Docker

0. В директории, где находится Dockerfile открыть терминал

1. Построить Docker image и запустить контейнер:

    docker build -t sqlite-builder .
    docker run -it sqlite-builder

2. Внутри контейнера перейти в рабочую директорию:

    cd /app

3. Скачать и распаковать исходники SQLite:

    wget https://www.sqlite.org/2018/sqlite-amalgamation-3260000.zip
    unzip sqlite-amalgamation-3260000.zip

4. Создать директорию для сборки и выполнить сборку библиотеки:

    mkdir build
    cd build
    cmake ..
    cmake . --build

5. Итоговая библиотека будет находиться в директории `build`.
