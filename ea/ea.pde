PImage surf;   // imagen que entrega el fitness
float d = 10;  // radio del círculo, solo para despliegue
int i;

int solutions = 30;      // Cantidad de soluciones
int select_bests = 16;   // Mejores candidatos a solucion (numero par)
int father_1, father_2; // Padres

// Dominio funcion
float domMin = 3;
float domMax = 7;

Solution[] sol;    // arreglo de soluciones
Solution[] bests;  // arreglo con las mejores soluciones

void setup(){  
  size(600,600);
  surf = loadImage("rastrigin_dom.png");
  smooth();
 
  initialization();
  insertion(sol);
  //println("Order init");
  //for(i = 0 ; i < solutions; i++)
  //  println("i: " + i + " x " + str(sol[i].x) + " y " + str(sol[i].y) + " fit " + str(sol[i].Eval()));
  //println("--------------------");
  
  selection(sol, select_bests);
  //println("Selection");
  //for(i = 0 ; i < select_bests; i++)
  //  println("x " + str(bests[i].x) + " y " + str(bests[i].y) + " fit " + str(bests[i].Eval()));
  //println("--------------------");
  crossover(sol, bests, select_bests);
  
  //println("Reproduction");
  //for(i = 0 ; i < solutions; i++)
  //  println("i: " + i + " x " + str(sol[i].x) + " y " + str(sol[i].y) + " fit " + str(sol[i].Eval()));
}

class Solution{
  float x, y, fit;
  
  Solution(){ 
    x = random(-domMin,domMax);
    y = random(-domMin,domMax);
  }
  
  float Eval(){
    fit = 20 + pow(x,2) - 10*cos(2*PI*x) + pow(y,2) - 10*cos(2*PI*y); 
    return fit;
  }
}

void initialization(){
  sol = new Solution[solutions];
  for(i = 0; i < solutions; i++)
    sol[i] = new Solution();
}

void insertion(Solution[] S){
  int n = S.length;
  for(int i = 1;i < n;i++){
    float aux = S[i].Eval();
    Solution aux2 = S[i];
    int j = i - 1;
    while ((j >= 0) && (S[j].Eval() > aux)){
      S[j+1] = S[j];
      j--;
    }
    S[j+1] = aux2;
  }
}

void selection(Solution[] S, int n){
  bests = new Solution[n];
  for(i = 0; i < n; i++)
    bests[i] = S[i];
}

void crossover(Solution[] S, Solution[] B, int n){
  
  // ---- pasar todo esto a una funcion a parte
  float zero = 0;
  int number_of_sons =  int(random((n/2)+1));
  int ns = number_of_sons;
  int[] indexs = new int[number_of_sons*2];
  int aux = 0;
  //println(number_of_sons);
  
  while(number_of_sons>0){
    father_1 = int(random(zero,n));
    father_2 = int(random(zero,n));
    
    if(father_1 == 0 || father_2 == 0)
      zero = 1;
    
    if(father_1 == father_2){
      while(father_1 == father_2)
        father_2 = int(random(zero,n));
    }
    indexs[aux] = father_1;
    indexs[aux+1] = father_2;
    aux += 2;
    number_of_sons -= 1;
  }
  // ---- hasta aqui
  
  int j = 0;
  for(i = select_bests; i < select_bests + ns; i++){
    Solution son = new Solution();
 
    son.x = (B[indexs[j]].x + B[indexs[j+1]].x)/2;
    son.y = (B[indexs[j]].y + B[indexs[j+1]].y)/2;
   
    S[i] = son;
    j++;
    //println(i,j);
  }
}

void mutation(Solution[] S){
  println("mutando");
}

void display(Solution s){
    int ejeX = int((domMin+s.x)/(domMin+domMax)*width);
    int ejeY = int(abs(s.y-domMax)/(domMin+domMax)*height); 
    stroke(#111111);
    fill(#008000);
    ellipse (ejeX,ejeY,d,d);
}

void draw(){
  image(surf,0,0);
 
  for(i = 0; i < solutions; i++)
    display(sol[i]);
}
