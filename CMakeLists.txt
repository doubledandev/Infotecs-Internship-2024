cmake_minimum_required(VERSION 3.10)

project(SQLite VERSION 3.26 LANGUAGES C)

set(HEADERS src/sqlite3.h)
set(SOURCES src/sqlite3.c)

add_library(${PROJECT_NAME} SHARED ${HEADERS} ${SOURCES})
