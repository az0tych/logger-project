#include "logger.h"

Logger::Logger(const std::string& fileName, LogLevel level) : defaultLevel(level) {
    logFile.open(fileName, std::ios::app);
    if (!logFile.is_open()) {
        throw std::runtime_error("Failed to open the log file.");
    }
}

void Logger::log(const std::string& message, LogLevel level) {
    std::lock_guard<std::mutex> lock(mtx); // Защищаем запись в файл
    if (static_cast<int>(level) >= static_cast<int>(defaultLevel)) {
        auto now = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
        char timeBuffer[100];
        std::strftime(timeBuffer, sizeof(timeBuffer), "%Y-%m-%d %H:%M:%S", std::localtime(&now));
        logFile << "[" << timeBuffer << "] "
            << "[Level: " << static_cast<int>(level) << "] "
            << message << std::endl;
        logFile.flush(); // Принудительная запись в файл
    }
}

void Logger::setLogLevel(LogLevel level) {
    defaultLevel = level;
}

Logger::~Logger() {
    if (logFile.is_open()) {
        logFile.close();
    }
}
