#include <iostream>
#include <thread>
#include <atomic>
#include "logger.h"

void logMessage(Logger& logger) {
    std::string message;
    int level;
    while (true) {
        std::cout << "Enter a message (or 'exit' to exit): ";
        std::getline(std::cin, message);
        if (message == "exit") break;

        std::cout << "Enter the level of importance (0 for low, 1 for medium, 2 for high): ";
        if (!(std::cin >> level)) {
            std::cin.clear();
            std::cin.ignore(10000, '\n');
            std::cout << "Input error! Use 0, 1 or 2.\n";
            continue;
        }
        std::cin.ignore(); // Ожидаем окончания ввода числа

        if (level < 0 || level > 2) level = 1; // По умолчанию средний уровень
        logger.log(message, static_cast<LogLevel>(level));
    }
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Error: Specify the name of the log file.\n";
        return 1;
    }

    std::string logFileName = argv[1];
    LogLevel defaultLevel = LogLevel::MEDIUM;
    if (argc > 2) {
        defaultLevel = static_cast<LogLevel>(std::stoi(argv[2]));
    }

    Logger logger(logFileName, defaultLevel);

    std::thread inputThread(logMessage, std::ref(logger));
    inputThread.join();

    return 0;
}
