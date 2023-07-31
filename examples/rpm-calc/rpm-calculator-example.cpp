#include <iostream>
#include <chrono> // for time measurement
#include <unistd.h>

#define PURSE_PER_ROTATION 20
#define TIME() std::chrono::high_resolution_clock::now()

int main() {
  size_t RPM = 0;
  double prevTimeStamp = 0.0;

  int PurseCounter = 1;
  int readingsCnt = 1;

  double ElapsedTimeAvg = 0.0;
  double ElapsedTimeSum = 0.0;

  // get start time
  auto prevTime = TIME();
  int i = 0;

  while (i++ < 100) {
    RPM++;
    // get current time
    auto current_time = TIME();
    // elapse time (μs)
    size_t elapsed_time = std::chrono::duration_cast<std::chrono::microseconds>(current_time - prevTime).count();
    // renew prev time
    prevTime = TIME();

    if (PurseCounter >= readingsCnt) {
      ElapsedTimeAvg = ElapsedTimeSum / readingsCnt;
      PurseCounter = 1;
      ElapsedTimeSum = elapsed_time;

      int tmpReadCnt = elapsed_time / 10000;
      tmpReadCnt = std::min(tmpReadCnt, 10);
      tmpReadCnt = std::max(tmpReadCnt, 1);
      readingsCnt = tmpReadCnt;
    } else {
      PurseCounter++;
      ElapsedTimeSum += elapsed_time;
    }

    // pulse frequency calculation
    // - 1s * 1000 / average purse interval
    // - reason of dividing with 1000 : to reduce errors of calculating float things
    size_t frqRaw = 1000000 * 1000 / ElapsedTimeAvg;

    // RPM calculating
    RPM = (frqRaw / PURSE_PER_ROTATION * 60) / 1000;
    std::cout << "RPM: [ " << RPM << "rpm/min]" << std::endl;

    usleep(5000);
  }
  return 0;
}
