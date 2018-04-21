
#include <iostream>
#include <fstream>
#include <queue>
#define MAX_N 1000
#define MAX_M 1000
#define SPACE MAX_N*MAX_M+1
#define OBSTACLE MAX_N*MAX_M+2
using namespace std;

long distM[MAX_N][MAX_M],distA[MAX_N][MAX_M];
char line[MAX_N];
std::queue<pair<int,int>> visitedM, visitedA, neighbors;
pair<int,int> current, neighbor;
int n,m;

int main(int argc, char *argv[]) {
  ifstream inputfile;
  if (argc != 2) {
    cout << "Wrong number of arguments: " << argc << endl;
    return 1;
  }
  inputfile.open(argv[1]);
  if (!inputfile.is_open()) { 
    cout << "Could not open file: " << argv[1] << endl;
    return 1;
  }
  while (inputfile.getline(line, MAX_M)) {
    m=0;
    while(line[m]) {
        if (line[m] == 'X') {
            distM[n][m] = OBSTACLE;
            distA[n][m] = OBSTACLE;
        } else if (line[m] == '.') {
            distM[n][m] = SPACE;
            distA[n][m] = SPACE;
        } else if (line[m] == '+') {
            distM[n][m] = 0;
            distA[n][m] = SPACE;
            visitedM.push(make_pair(n,m));
        } else if (line[m] == '-') {
            distM[n][m] = SPACE;
            distA[n][m] = 0;
            visitedA.push(make_pair(n,m));
        } else {
            cout << "Invalid character: " << line[m] << endl;
            return 1;
        }
        m++;
    }
    n++;
  }
  while (!visitedM.empty()) {
    current = visitedM.front(); 
    visitedM.pop();
    neighbors.push(make_pair(current.first-1, current.second));
    neighbors.push(make_pair(current.first+1, current.second));
    neighbors.push(make_pair(current.first, current.second-1));
    neighbors.push(make_pair(current.first, current.second+1));
    while (!neighbors.empty()) {
        neighbor = neighbors.front();
        neighbors.pop();
        if (neighbor.first < 0 || neighbor.first >= n || neighbor.second < 0 || neighbor.second >= m || distM[neighbor.first][neighbor.second] != SPACE)
            continue;
        distM[neighbor.first][neighbor.second] = distM[current.first][current.second] + 1;
        visitedM.push(neighbor);
    }
  }
  while (!visitedA.empty()) {
    current = visitedA.front(); 
    visitedA.pop();
    neighbors.push(make_pair(current.first-1, current.second));
    neighbors.push(make_pair(current.first+1, current.second));
    neighbors.push(make_pair(current.first, current.second-1));
    neighbors.push(make_pair(current.first, current.second+1));
    while (!neighbors.empty()) {
        neighbor = neighbors.front();
        neighbors.pop();
        if (neighbor.first < 0 || neighbor.first >= n || neighbor.second < 0 || neighbor.second >= m || distA[neighbor.first][neighbor.second] != SPACE)
            continue;
        distA[neighbor.first][neighbor.second] = distA[current.first][current.second] + 1;
        visitedA.push(neighbor);
    }
  }
  long collision_min = SPACE;
  for (int i=0; i<n; i++) {
    for (int j=0; j<m; j++) {
        long temp = distM[i][j] > distA[i][j] ? distM[i][j] : distA[i][j];
        if (temp < collision_min)
            collision_min = temp;
    }
  }
  if (collision_min == SPACE) {
    cout << "the world is saved" << endl;
    for (int i=0; i<n; i++) {
        for (int j=0; j<m; j++) {
            if (distM[i][j] == OBSTACLE)
                cout << 'X';
            else if (distM[i][j] < collision_min )
                cout << '+';
            else if (distA[i][j] < collision_min)
                cout << '-';
            else
                cout << '.';
        }
        cout << endl;
      }
  }
  else {	  
      cout << collision_min << endl;
      for (int i=0; i<n; i++) {
       for (int j=0; j<m; j++) {
            if (distM[i][j] == OBSTACLE)
                cout << 'X';
            else if (distM[i][j] <= collision_min && distA[i][j] <= collision_min)
                cout << '*';
            else if (distM[i][j] <= collision_min && distA[i][j] > collision_min)
                cout << '+';
            else if (distM[i][j] > collision_min && distA[i][j] <= collision_min)
                cout << '-';
            else
                cout << '.';
        }
        cout << endl;
      }
  }
  inputfile.close();
  return 0;
}