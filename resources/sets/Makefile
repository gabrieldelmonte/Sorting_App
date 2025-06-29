CXX = g++
CXXFLAGS = -std=c++11 -Wall -Wextra -O2
TARGET = creator
SOURCE = creator.cpp

$(TARGET): $(SOURCE)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(SOURCE)

clean:
	rm -f $(TARGET)

.PHONY: clean

# Usage examples:
# make
# ./creator --size 1000 --distribution uniform --perturbation 1.0 --output data.txt
# ./creator --size 5000 --distribution normal --perturbation 0.2 --output test_data.txt
# ./creator --help
