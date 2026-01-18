# ========================
# Project configuration
# ========================
TARGET      := Dungeon-Crawl.exe

CC          := gcc
CXX         := g++ -std=c++23

INCLUDES    := -Iinclude

# raylib + Windows system libs
LDFLAGS     := -lraylib -lopengl32 -lgdi32 -lwinmm

SRC_DIR     := src
OBJ_DIR     := obj

# ========================
# Build mode selection
# ========================
# MODES:
#   debug   -> -Og -g -D_DEBUG   (default)
#   normal  -> -Og -g
#   release -> -O2 -DNDEBUG
MODE ?= debug

ifeq ($(MODE),debug)
	BUILD_TYPE := DEBUG (_DEBUG)
	CFLAGS     := -Wall -Werror -Og -g -D_DEBUG
	CXXFLAGS   := -Wall -Werror -Og -g -D_DEBUG
endif

ifeq ($(MODE),normal)
	BUILD_TYPE := NORMAL
	CFLAGS     := -Wall -Werror -Og -g
	CXXFLAGS   := -Wall -Werror -Og -g
endif

ifeq ($(MODE),release)
	BUILD_TYPE := RELEASE
	CFLAGS     := -Wall -O2 -DNDEBUG
	CXXFLAGS   := -Wall -O2 -DNDEBUG
endif

# ========================
# Source discovery
# ========================
C_SOURCES   := $(wildcard $(SRC_DIR)/*.c)
CPP_SOURCES := $(wildcard $(SRC_DIR)/*.cpp)

C_OBJECTS   := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(C_SOURCES))
CPP_OBJECTS := $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(CPP_SOURCES))

OBJECTS    := $(C_OBJECTS) $(CPP_OBJECTS)

# Use C++ linker if any C++ files exist
ifeq ($(strip $(CPP_SOURCES)),)
	LINKER := $(CC)
else
	LINKER := $(CXX)
endif

.PHONY: all build debug normal release run clean clean-output help info

# ========================
# Targets
# ========================
all: build

build: info $(TARGET)

debug:
	@$(MAKE) MODE=debug build

normal:
	@$(MAKE) MODE=normal build

release:
	@$(MAKE) MODE=release build

run: build
	@echo.
	@echo Running $(TARGET)...
	@$(TARGET)

info:
	@echo.
	@echo ============================
	@echo Building: $(BUILD_TYPE)
	@echo ============================

$(TARGET): $(OBJECTS)
	@echo.
	@echo Linking...
	$(LINKER) $(OBJECTS) $(LDFLAGS) -o $@

# ========================
# Compile rules
# ========================
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	@echo Compiling C $< ...
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	@echo Compiling C++ $< ...
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

$(OBJ_DIR):
	@if not exist "$(OBJ_DIR)" mkdir "$(OBJ_DIR)"

# ========================
# Cleanup
# ========================
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
	@echo   make / make debug   - -Og -g -D_DEBUG
	@echo   make normal         - -Og -g (no debug macros)
	@echo   make release        - -O2 -DNDEBUG
	@echo   make run            - build & run
	@echo   make clean          - remove objects + exe
	@echo.
