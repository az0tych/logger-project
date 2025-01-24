# Устанавливаем компилятор и флаги компиляции
CXX = g++
CXXFLAGS = -std=c++17 -pthread -fPIC -Wall -Wextra
LDFLAGS = -pthread -L. -llogger

# Источники и объектные файлы
SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin

SRCS = $(SRC_DIR)/main.cpp $(SRC_DIR)/logger.cpp
OBJS = $(OBJ_DIR)/main.o $(OBJ_DIR)/logger.o
TARGET = $(BIN_DIR)/logger_app
LIBRARY = liblogger.so

# Цели сборки
all: $(TARGET)

# Компиляция исходников с флагом -fPIC
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	mkdir -p $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

# Сборка динамической библиотеки
$(LIBRARY): $(OBJ_DIR)/logger.o
	$(CXX) -shared -o $@ $^ -fPIC

# Сборка тестового приложения
$(TARGET): $(OBJ_DIR)/main.o $(LIBRARY)
	mkdir -p $(BIN_DIR)
	$(CXX) -o $@ $(OBJ_DIR)/main.o $(LDFLAGS)



# Очистка временных файлов
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR) $(LIBRARY)

# Автоматическая установка LD_LIBRARY_PATH при запуске
run: $(TARGET)
	LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH ./$(TARGET) log.txt 1