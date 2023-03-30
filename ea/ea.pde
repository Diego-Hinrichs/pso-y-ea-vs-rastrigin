import java.util.ArrayList;

PImage surf; // imagen que entrega el fitness

int puntos = 5;
int select_bests = 2;
int i;

float d = 10; // radio del círculo, solo para despliegue
float gbestx, gbesty; // posición solucion (0,0)

float domMin = 3;
float domMax = 7;

int n_iters = 200;// numero de iteraciones
int act = 0; // iteracion actual

Solution[] fl; // arreglo de soluciones
PVector results[] = new PVector[puntos]; //Triupla, contiene (x,y,fit)
PVector bests[] = new PVector[select_bests];


class Solution{
  float x, y, fit; // posicion de la solucion generada y resultado de la evaluacion
  
  // ---------------------------- Constructor
  Solution(){ 
    x = random(-domMin,domMax);
    y = random(-domMin,domMax);
  }
 
  // ---------------------------- Evalúa partícula en funcion rastrigin
  float Eval(){
    fit = 20 + pow(x,2) - 10*cos(2*PI*x) + pow(y,2) - 10*cos(2*PI*y); 
    return fit;
  }
  
  // ------------------------------ despliega partícula
  void display(){
    int ejeX = int((domMin+x)/(domMin+domMax)*width);
    int ejeY = int(abs(y-domMax)/(domMin+domMax)*height); 
    stroke(#111111);
    fill(#008000);
    ellipse (ejeX,ejeY,d,d);
  }
  
  Solution MiddlePoint(Solution f1, Solution f2){
    Solution child = new Solution();
    child.x = (f1.x + f2.x)/2;
    child.y = (f1.y + f2.y)/2;
    child.Eval(); 
    return child;
  }
  
} // FIN CLASE SOLUTION

void mejores(PVector B[]){
  int n = B.length;
  for(i=0; i<n ; i++){
    int bestEjeX = int( (domMin+B[i].x)/(domMin+domMax) * width );
    int bestEjeY = int( abs(B[i].y-domMax)/(domMin+domMax) * height );
    stroke(#111111);
    fill(#F5FF00);
    ellipse(bestEjeX,bestEjeY,d,d);
    }
}

// Ordenar arreglo
void insertion(PVector A[]){
  int n = A.length;
  for(int i = 1;i < n;i++){
    float aux = A[i].z;
    PVector aux2 = A[i];
    int j = i - 1;
    while ((j >= 0) && (A[j].z > aux)){
      A[j+1] = A[j];
      j--;
    }
    A[j+1] = aux2;
  }
}

void setup(){  
  size(600,600);
  surf = loadImage("rastrigin_dom.png");
  smooth();
  // crea arreglo de objetos Soluciones
  fl = new Solution[100];
  
  // llenamos el arreglo con soluciones 
  for(i=0;i<puntos;i++)
    fl[i] = new Solution(); 
    
  // Crear lista con las soluciones
  for(i=0;i<puntos;i++){
    PVector result = new PVector(fl[i].x,fl[i].y,fl[i].Eval());
    results[i] = result;
  }
  
  // Primero hay que ordenar
  insertion(results);
  
  // seleccion de x mejores
  for(i = 0; i < select_bests; i++){
    bests[i] = results[i];
  }
   
  // punto medio entre soluciones, generamos 1 solucion mas x pareja
  int father_1 = int(random(select_bests));
  int father_2 = int(random(select_bests));
  
  for(i = 0; i < puntos; i++)
    println("x: " + str(fl[i].x) + " y: " + fl[i].y);
}

void draw(){
  image(surf,0,0);
  
  for(i = 0;i<puntos;i++)
    fl[i].display();
  
  mejores(bests);
}
