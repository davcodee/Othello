/**
 * Proyecto base para el juego de Othello/Reversi
 * @author Rodrigo Colín
 */

Tablero tablero;


/*Arbol de nuestro juego*/
Arbol arbol;

/*Nodo raiz de nuestro árbol*/
Nodo raiz ;

/**
 * Método para establecet tamaño de ventana al incluir variables
 */
void settings(){
  tablero =  new Tablero();
  Tablero t = new Tablero();
  Nodo n = new Nodo(t);
  size(tablero.dimension * tablero.tamCasilla, tablero.dimension * tablero.tamCasilla);
  
  /* Cración de nuesto arbol*/
  raiz = new Nodo(tablero);
  arbol = new Arbol(raiz);
  arbol.agrega(raiz, n);

  
  
}

/*
* Implemenataciónde MiniMax
*/

public int MiniMax(Nodo n, int profundidad, boolean turno ){
  int value =0;
  if (n.esHoja()){
    return euristica(n);
  }if(turno == true ){
  
    value = -1;
    for(Nodo nodo: n.getHijos()){
        value = maximo(value,MiniMax(nodo, profundidad -1 , false));
    }
  
  }if (turno == false){
    value = 0;
    for(Nodo nodo : n.getHijos()){
      value = minimo(value, MiniMax(nodo, profundidad-1,  true));
    }
  }
  
  return value;
}


/*Función que nos da el número mayor*/
public  int maximo(int n, int m){
  return (n >= m)? n:m;
}

public int minimo(int n, int m){
  return (n <= m )? n :m;
}


/*
*  Función que dado un nodo nos da su valor heurístico¡.
*/
public int euristica(Nodo n ){
 return 1;
}



/**
 * Inicializaciones
 */
void setup(){
  println("Proyecto base para el juego de mesa Othello");
}

/**
 * Ciclo de dibujado
 */
void draw(){
  tablero.display();
}

/**
 * Evento para detectar cuando el usuario da clic
 */
void mousePressed() {
  println("\nClic en la casilla " + "[" + mouseX/tablero.tamCasilla + ", " + mouseY/tablero.tamCasilla + "]");
  if(!tablero.estaOcupado(mouseX/tablero.tamCasilla, mouseY/tablero.tamCasilla) && tablero.movimientoValido(mouseX/tablero.tamCasilla, mouseY/tablero.tamCasilla, tablero.getMundo())){
    tablero.setFicha(mouseX/tablero.tamCasilla, mouseY/tablero.tamCasilla);
    tablero.cambiarTurno();
    println("[Turno #" + tablero.numeroDeTurno + "] "  + (tablero.turno ? "jugó ficha blanca" : "jugó ficha negra") + " (Score: " + int(tablero.cantidadFichas(tablero.getMundo()).x) + " - " + int(tablero.cantidadFichas(tablero.getMundo()).y) + ")");
    println("Posibles tiros: " + tablero.posiblesTiros(tablero.getMundo(),tablero.getColorActual()));  
}
}
