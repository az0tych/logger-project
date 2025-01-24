#ifndef LOGGER_H
#define LOGGER_H

#include <iostream>
#include <fstream>
#include <string>
#include <mutex>
#include <chrono>
#include <ctime>

enum class LogLevel {
    LOW,
    MEDIUM,
    HIGH
};

class Logger {
private:
    std::ofstream logFile;
    LogLevel defaultLevel;
    std::mutex mtx; // Для обеспечения потокобезопасности

public:
    Logger(const std::string& fileName, LogLevel level = LogLevel::MEDIUM);
    void log(const std::string& message, LogLevel level = LogLevel::MEDIUM);
    void setLogLevel(LogLevel level);
    ~Logger();
};

#endif // LOGGER_H
