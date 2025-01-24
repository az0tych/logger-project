# ������������� ���������� � ����� ����������
CXX = g++
CXXFLAGS = -std=c++17 -pthread -fPIC -Wall -Wextra
LDFLAGS = -pthread -L. -llogger

# ��������� � ��������� �����
SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin

SRCS = $(SRC_DIR)/main.cpp $(SRC_DIR)/logger.cpp
OBJS = $(OBJ_DIR)/main.o $(OBJ_DIR)/logger.o
TARGET = $(BIN_DIR)/logger_app
LIBRARY = liblogger.so

# ���� ������
all: $(TARGET)

# ���������� ���������� � ������ -fPIC
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	mkdir -p $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

# ������ ������������ ����������
$(LIBRARY): $(OBJ_DIR)/logger.o
	$(CXX) -shared -o $@ $^ -fPIC

# ������ ��������� ����������
$(TARGET): $(OBJ_DIR)/main.o $(LIBRARY)
	mkdir -p $(BIN_DIR)
	$(CXX) -o $@ $(OBJ_DIR)/main.o $(LDFLAGS)



# ������� ��������� ������
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR) $(LIBRARY)

# �������������� ��������� LD_LIBRARY_PATH ��� �������
run: $(TARGET)
	LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH ./$(TARGET) log.txt 1