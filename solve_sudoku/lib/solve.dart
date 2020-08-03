import 'dart:math';
import 'main.dart';

bool trigger=true;
List<List<String>> sudArray =
List.generate(9, (i) => ["", "", "", "", "", "", "", "", ""], growable: false);
List<List<String>> amal =
List.generate(9, (i) => ["", "", "", "", "", "", "", "", ""], growable: false);

List<String> source = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];
List<List<int>> centers = [
  [1, 1],
  [1, 4],
  [1, 7],
  [4, 1],
  [4, 4],
  [4, 7],
  [7, 1],
  [7, 4],
  [7, 7]
];
List<String>given=[];
List<List<List<String>>> solutions=[];



int distanceFun(List<int> a, List<int> b) {
  return (((a[0] - b[0]) * (a[0] - b[0])) + ((a[1] - b[1]) * (a[1] - b[1])));
}

List<int> boxcheck(int i, int j) {
  List<int> dist = [];
  for (List<int> center in centers) {
    int distance = distanceFun(center, [i, j]);
    dist.add(distance);
  }

  return centers[dist.indexOf(dist.reduce(min))];
}

List<List<String>> CreateBox(i, j) {
  List<List<String>> box1;
  List<List<String>> box = [];
  box1 = sudArray.sublist(i - 1, i + 2);
  for (List<String> sublists in box1) {
    box.add(sublists.sublist(j - 1, j + 2));
  }
  return(box);
}

bool possible(i,j,n){
  List<int> center=boxcheck(i,j);
  List<List<String>> box=CreateBox(center[0],center[1]);

  if(!sudArray[i].contains(n)){
    if(!columnFunction(j).contains(n)){
      for(List<String> sublist in box){
        if(sublist.contains(n)){
          return false;
        }
      }
      return true;

    }
    return false;
  }
  return false;

}




List<String> columnFunction(i) {
  List<String> column = [];
  for (List<String> sublist in sudArray) {
    column.add(sublist[i]);
  }
  return column;
}

solve() {
print("start");
  for (int i = 0; i < 9; i++) {
    for (int j = 0; j < 9; j++) {
      if(sudArray[i][j]==""){
        for(String n in source){
          if(possible(i,j,n)){
            sudArray[i][j]=n;
            solve();
            sudArray[i][j]="";
          }
        }
        return;
      }
    }
  }
  sudokuPrinter(sudArray);
  copy(sudArray);


}
void copy(List<List<String>> sud){
  for (int i = 0; i < 9; i++) {
    for (int j = 0; j < 9; j++) {
      amal[i][j]=sud[i][j];
    }}

  sudokuPrinter(sud);
}

void sudokuPrinter(List<List<String>> sud){
  print("--------------------------------------------------");
  for(List<String> sublist in sud){
    print(sublist);
  }
  print("--------------------------------------------------");
}

void solveSudoku() {
  given=predictions;
  int k = 0;
  for (int i = 0; i < 9; i++) {
    for (int j = 0; j < 9; j++) {
      sudArray[i][j] = given[k];
      k = k + 1;
    }
  }
  sudokuPrinter(sudArray);
  solve();
  print("new");
  print(amal);


}