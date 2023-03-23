// PSO de acuerdo a Talbi (p.247 ss)

PImage surf; // imagen que entrega el fitness
// ===============================================================
int puntos = 100;
Particle[] fl; // arreglo de partículas
float d = 10; // radio del círculo, solo para despliegue
float gbestx, gbesty, gbest; // posición y fitness del mejor global
float w = 1000; // inercia: baja (~50): explotación, alta (~5000): exploración (2000 ok)
float C1 = 10, C2 = 30; // learning factors (C1: own, C2: social) (ok)
int evals = 0, evals_to_best = 0; //número de evaluaciones, sólo para despliegue
float maxv = 0.025; // max velocidad (modulo)

float domMin = 3;
float domMax = 7;

int n_iters = 800;// numero de iteraciones
int act = 0; // iteracion actual
float BestValues[] = new float[100];
int BestValues_i[] = new int[100];

class Particle{
  float x, y, fit; // current position(x-vector)  and fitness (x-fitness)
  float px, py, pfit; // position (p-vector) and fitness (p-fitness) of best solution found by particle so far
  float vx, vy; //vector de avance (v-vector)
  
  // ---------------------------- Constructor
  Particle(){
    // x,y -> [-3,7] 
    x = random(-domMin,domMax);
    y = random(-domMin,domMax); 
    vx = random(-1,1) ; vy = random(-1,1);
    //pfit = pow(10,5); fit = pow(10,5);
    pfit = 1; fit = 1; // como ajustar los valores fitness
  }
  
  // ---------------------------- Evalúa partícula en funcion rastrigin
  float Eval(){
    evals++;
    
    //Funcion rastrigin para 2 dimensiones
    fit = 20 + pow(x,2) - 10*cos(2*PI*x) + pow(y,2) - 10*cos(2*PI*y); 
    
    if(fit < pfit){ // actualiza local best si es menor
      pfit = fit;
      px = x;
      py = y;
    }
      if (fit < gbest){ // actualiza global best
        gbest = fit;
        gbestx = x;
        gbesty = y;
        evals_to_best = evals;
        //println("x: ",str(x)," y: ",str(y)," best: ",str(gbest));
      };
    
    return fit; //retorna la componente roja
  }
  
  // ------------------------------ mueve la partícula
  void move(){
    //actualiza velocidad (fórmula con factores de aprendizaje C1 y C2)
    //vx = vx + random(0,1)*C1*(px - x) + random(0,1)*C2*(gbestx - x);
    //vy = vy + random(0,1)*C1*(py - y) + random(0,1)*C2*(gbesty - y);
    //actualiza velocidad (fórmula con inercia, p.250)
    vx = w * vx + random(0,1)*(px - x) + random(0,1)*(gbestx - x);
    vy = w * vy + random(0,1)*(py - y) + random(0,1)*(gbesty - y);
    //actualiza velocidad (fórmula mezclada)
    //vx = w * vx + random(0,1)*C1*(px - x) + random(0,1)*C2*(gbestx - x);
    //vy = w * vy + random(0,1)*C1*(py - y) + random(0,1)*C2*(gbesty - y);
    // trunca velocidad a maxv
    float modu = sqrt(vx*vx + vy*vy);
    if (modu > maxv){
      vx = vx/modu*maxv;
      vy = vy/modu*maxv;
    }
    // update position
    x = x + vx;
    y = y + vy;
    // rebota en murallas
    if (x > domMax || x < -domMin) vx = - vx;
    if (y > domMax || y < -domMin) vy = - vy;
  }
  
  // ------------------------------ despliega partícula
  void display(){
    // ajusta la posicion de las particulas a los pixeles de la imagen
    // 600x600
    int ejeX = int( (domMin+x)/(domMin+domMax) * width );
    int ejeY = int( abs(y-domMax)/(domMin+domMax) * height ); 
    
    stroke(#111111);
    fill(#008000);
    ellipse (ejeX,ejeY,d,d);
    stroke(#008000);
    line(ejeX,ejeY, ejeX - 1000*vx, ejeY + 1000*vy );
  }
}

// y despliega números
void despliegaBest(){
  // ajusta el mejor punto a los pixeles de la imagen
  int bestEjeX = int( (domMin+gbestx)/(domMin+domMax) * width );
  int bestEjeY = int( abs(gbesty-domMax)/(domMin+domMax) * height );
   
  stroke(#111111);
  fill(#0000ff);
  ellipse(bestEjeX,bestEjeY,d,d);
  //PFont f = createFont("Arial",16,true);
  //textFont(f,15);
  //fill(#000000);
  //text("Best fitness: "+str(gbest)+"\nEvals to best: "+str(evals_to_best)+"\nEvals: "+str(evals),10,20);
}

void setup(){  
  size(600,600);
  surf = loadImage("rastrigin_dom.png");
  smooth();
  // crea arreglo de objetos partículas
  fl = new Particle[puntos];
  
  fl[0] = new Particle();
  gbest = fl[0].fit;
  gbestx = fl[0].x;
  gbesty = fl[0].y;
  
  for(int i =1;i<puntos;i++)
    fl[i] = new Particle();
    
  for(int i=0; i<100; i++)
    BestValues_i[i] = -1;
}

void draw(){
  image(surf,0,0);
  for(int i = 0;i<puntos;i++){
    fl[i].display();
  }
  despliegaBest();
  
  //mueve puntos
  float minCiclo=90, maxCiclo=0, acum=0;
  for(int i = 0;i<puntos;i++){
    fl[i].move();
    fl[i].Eval();
    acum += fl[i].fit;
    minCiclo = min(minCiclo, fl[i].fit);
    maxCiclo = max(maxCiclo, fl[i].fit);
  }
  acum /= float(puntos);
 
  //if(act == n_iters - 1){
    //noLoop();}
  //++act;
}
