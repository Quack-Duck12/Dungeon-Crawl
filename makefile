# Makefile for raylib project (Windows + gcc)

TARGET      := main.exe
CC          := gcc
CFLAGS      := -Wall -Werror -O2
INCLUDES    := -Iinclude

# raylib + Windows system libs
LDFLAGS     := -lraylib -lopengl32 -lgdi32 -lwinmm

SRC_DIR     := src
OBJ_DIR     := obj

SOURCES     := $(wildcard $(SRC_DIR)/*.c)
OBJECTS     := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SOURCES))

.PHONY: all build run clean clean-output help

all: build

build: $(TARGET)

run: build
	@echo.
	@echo Running $(TARGET)...
	@$(TARGET)

$(TARGET): $(OBJECTS)
	@echo.
	@echo Linking...
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	@echo Compiling $< ...
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(OBJ_DIR):
	@if not exist "$(OBJ_DIR)" mkdir "$(OBJ_DIR)"

clean:
	@echo Cleaning...
	@if exist "$(OBJ_DIR)" rmdir /s /q "$(OBJ_DIR)"
	@if exist "$(TARGET)" del /q "$(TARGET)"
	@echo Done.

clean-output:
	@if exist "$(TARGET)" del /q "$(TARGET)"
	@echo Output file removed.

help:
	@echo.
	@echo Available targets:
	@echo   make                - same as 'make build'
	@echo   make build          - compile the program
	@echo   make run            - build and run
	@echo   make clean          - remove objects + executable
	@echo   make clean-output   - only remove the .exe
	@echo.
