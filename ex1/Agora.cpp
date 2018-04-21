#include <fstream>
#include <iostream>
#define MAX 1000000

using namespace std;

long INIT_ARR[MAX];
long long LEFT_ARR[MAX];
long long RIGHT_ARR[MAX];
long long FINAL_ARR[MAX];

long long lcm(long long n1, long long n2) {
  long long u, v, i, gcd;
  long long lcm;
  u = n1;
  v = n2;
  while (v != 0) {
    long r = u % v;
    u = v;
    v = r;
  }
  gcd = u;
  lcm = ((n1 / gcd) * n2);
  return lcm;
}

int main(int argc, char* argv[]) {
  string str;
  ifstream in(argv[1]);
  streambuf* cinbuf = cin.rdbuf();  // save old buf
  cin.rdbuf(in.rdbuf());            // redirect cin to in.txt!
  long quantity;
  cin >> quantity;
  for (size_t i = 0; i < quantity; i++) {
    cin >> INIT_ARR[i];
  }

  LEFT_ARR[0] = INIT_ARR[0];
  RIGHT_ARR[quantity - 1] = INIT_ARR[quantity - 1];

  for (size_t i = 1; i < quantity; i++) {
    LEFT_ARR[i] = lcm(INIT_ARR[i], LEFT_ARR[i - 1]);
    RIGHT_ARR[quantity - (i + 1)] =
        lcm(INIT_ARR[quantity - (i + 1)], RIGHT_ARR[quantity - i]);
  }

  FINAL_ARR[0] = RIGHT_ARR[1];
  FINAL_ARR[quantity - 1] = LEFT_ARR[quantity - 1];

  for (size_t i = 1; i < quantity - 1; i++) {
    FINAL_ARR[i] = lcm(LEFT_ARR[i - 1], RIGHT_ARR[i + 1]);
  }

  long long min = INT64_MAX;
  long long max = INT64_MIN;
  long index = 0;
  for (size_t i = 0; i < quantity; i++) {
    max = max < FINAL_ARR[i] ? FINAL_ARR[i] : max;
    if (min > FINAL_ARR[i]) {
      min = FINAL_ARR[i];
      index = i + 1;
    }
  }
  if (min == max)
    index = 0;
  printf("%lld %ld \n", min, index);

  return 0;
}