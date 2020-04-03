import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;
import java.util.Collections;

/**
 * Definición de un tablero para el juego de Othello
 */
class Tablero {

  /**
   * Cantidad de casillas en horizontal y vertical del tablero
   */
  int dimension;

  /**
   * El tamaño en pixeles de cada casilla cuadrada del tablero
   */
  int tamCasilla;

  /**
   * El indice de la diagonal de donde se revisara si es un tiro valido.
   */
  int iteradorDiagonal;

  /**
   * Representación lógica del tablero. El valor númerico representa:
   * 0 = casilla vacia
   * 1 = casilla con ficha del primer jugador
   * 2 = casilla con ficha del segundo jugador
   */
  int[][] mundo;

  /**
   * Representa de quién es el turno bajo la siguiente convención:
   * true = turno del jugador 1
   * false = turno del jugador 2
   */
  boolean turno;

  /**
   * Contador de la cantidad de turnos en el tablero
   */
  int numeroDeTurno;

  /**
   * El indice hasta el cual se pintara, si es un movimiento valido (solo se utiliza en movimientos verticales y horizontales)
   */
  int indice; 

  /**
   * Constructor base de un tablero. 
   * @param dimension Cantidad de casillas del tablero, comúnmente ocho.
   * @param tamCasilla Tamaño en pixeles de cada casilla
   */
  Tablero(int dimension, int tamCasilla) {
    this.dimension = dimension;
    this.tamCasilla = tamCasilla;
    turno = true;
    numeroDeTurno = 0;
    mundo = new int[dimension][dimension];
    // Configuración inicial (colocar 4 fichas al centro del tablero):
    mundo[(dimension/2)-1][dimension/2] = 1;
    mundo[dimension/2][(dimension/2)-1] = 1;
    mundo[(dimension/2)-1][(dimension/2)-1] = 2;
    mundo[dimension/2][dimension/2] = 2;
  }

  /**
   * Constructor por default de un tablero con las siguientes propiedades:
   * Tablero de 8x8 casillas, cada casilla de un tamaño de 60 pixeles,
   */
  Tablero() {
    this(8, 60);
  }

  /**
   * Dibuja en pantalla el tablero, es decir, dibuja las casillas y las fichas de los jugadores
   */
  void display() {
    color fondo = color(63, 221, 24); // El color de fondo del tablero
    color linea = color(0); // El color de línea del tablero
    int grosor = 2; // Ancho de línea (en pixeles)
    color jugador1 = color(0); // Color de ficha para el primer jugador
    color jugador2 = color(255); // Color de ficha para el segundo jugador

    // Doble iteración para recorrer cada casilla del tablero
    for (int i = 0; i < dimension; i++)
      for (int j = 0; j < dimension; j++) {
        // Dibujar cada casilla del tablero:
        fill(fondo); // establecer color de fondo
        stroke(linea); // establecer color de línea
        strokeWeight(grosor); // establecer ancho de línea
        rect(i*tamCasilla, j*tamCasilla, tamCasilla, tamCasilla);

        // Dibujar las fichas de los jugadores:
        if (mundo[i][j] != 0 && (mundo[i][j] == 1 || mundo[i][j] == 2)) { // en caso de que la casilla no esté vacia
          fill(mundo[i][j] == 1 ? jugador1 : jugador2); // establecer el color de la ficha
          noStroke(); // quitar contorno de línea
          ellipse(i*tamCasilla+(tamCasilla/2), j*tamCasilla+(tamCasilla/2), tamCasilla*3/5, tamCasilla*3/5);
        }
      }
  }

  /**
   * Coloca o establece una ficha en una casilla específica del tablero.
   * Nota: El eje vertical está invertido y el conteo empieza en cero.
   * @param posX Coordenada horizontal de la casilla para establecer la ficha
   * @param posX Coordenada vertical de la casilla para establecer la ficha
   * @param turno Representa el turno o color de ficha a establecer
   */
  void setFicha(int posX, int posY, boolean turno) {
    mundo[posX][posY] = turno ? 1 : 2;
  }

  /**
   * Coloca o establece una ficha en una casilla específica del tablero segun el turno del tablero.
   * @param posX Coordenada horizontal de la casilla para establecer la ficha
   * @param posX Coordenada vertical de la casilla para establecer la ficha
   */
  void setFicha(int posX, int posY) {
    this.setFicha(posX, posY, this.turno);
  }

  /**
   * Representa el cambio de turno. Normalmente representa la última acción del turno
   */
  void cambiarTurno() {
    turno = !turno;
    numeroDeTurno += 1;
  }

  /**
   * Verifica si en la posición de una casilla dada existe una ficha (sin importar su color)
   * @param posX Coordenada horizontal de la casilla a verificar
   * @param posY Coordenada vertical de la casilla a verificar
   * @return True si hay una ficha de cualquier color en la casilla, false en otro caso
   */
  boolean estaOcupado(int posX, int posY) {
    return mundo[posX][posY] != 0;
  }

  /*
  * Método que devulve el numero del color que esta jugando en ese momento.
   */
  int getColorActual() {
    boolean turnoActual = getTurno(); // Obtenemos el turno para saber de que color seran las fichas a revisar.
    if (turnoActual) { 
      return 1;
    } else { 
      return 2;
    } // 1:Negras, 2: Blancas.
  }

  /*
  * Método que devulve el numero del color contrario del que esta jugando en ese momento.
   */
  int getColorContraria(int colorActual) {
    if (colorActual == 1) { 
      return 2;
    } else { 
      return 1;
    } // 1:Negras, 2: Blancas.
  }

  /**
   * Método que nos devuelve el mundo actual.
   */
  int[][] getMundo() {
    return mundo;
  }

  /*
  * Método que revisa si es valido colocar una ficha revisando las fichas a la izquierda de donde se quiere poner la ficha.
   * @param lista La lista de fichas a revisar.
   * @param iterador El indice desde el cual se quiere empezar a iterar.
   */
  boolean revisaIzquierda(List<Integer> lista, int iterador, int fichaActual) {
    ListIterator<Integer> listaIterador = lista.listIterator(iterador);
    int fichaContraria = getColorContraria(getColorActual());

    // Primero revisamos que si hay una ficha del color contrario del lado izquierdo, en caso contrario es un movimiento invalido.
    if (listaIterador.hasPrevious() && listaIterador.previous() == fichaContraria) {
      while (listaIterador.hasPrevious()) { 
        indice = listaIterador.previousIndex();
        listaIterador.next(); // regresamos el iterador donde estaba antes de pedir el indice.
        // Si encontramos una casilla sin fichas ya NO es un movimiento valido.
        if (listaIterador.previous() == 0) { 
          return false;
        } 
        // Revisamos en las casillas anteriores, si encontramos el color actual ya es un movimiento valido.
        if (listaIterador.previous() == fichaActual) { 
          return true;
        }
      }
    }
    return false;
  }

  /*
  * Método que revisa si es valido colocar una ficha revisando las fichas a la derecha de donde se quiere poner la ficha.
   * @param lista La lista de fichas a revisar.
   * @param iterador El indice desde el cual se quiere empezar a iterar.
   */
  boolean revisaDerecha(List<Integer> lista, int iterador, int fichaActual) {
    ListIterator<Integer> listaIterador = lista.listIterator(iterador);
    int fichaContraria = getColorContraria(getColorActual());

    if (listaIterador.hasNext()) {
      listaIterador.next();
    }
    // Primero revisamos que si hay una ficha del color contrario del lado derecho, en caso contrario es un movimiento invalido.
    if (listaIterador.hasNext() && listaIterador.next() == fichaContraria) {

      while (listaIterador.hasNext()) { 
        indice = listaIterador.nextIndex();
        listaIterador.previous(); // regresamos el iterador donde estaba antes de pedir el indice.
        // Si encontramos una casilla sin fichas ya NO es un movimiento valido.
        if (listaIterador.next() == 0) { 
          return false;
        } 
        // Revisamos en las casillas anteriores, si encontramos el color actual ya es un movimiento valido.
        if (listaIterador.next() == fichaActual) { 
          return true;
        }
      }
    }
    return false;
  }

  /*
  * Método que nos da la lista de fichas en la misma columna (vertical) de donde se quiere agregar la ficha.
   * @param posX Coordenada horizontal de la casilla a verificar
   * @param posY Coordenada vertical de la casilla a verificar
   */
  List<Integer> mismaColumna(int posX, int[][]mundo) {
    List<Integer> columna = new ArrayList<Integer>();

    for (int celda = 0; celda < dimension; celda++) {
      columna.add(mundo[posX][celda]);
    }
    return columna;
  }

  /*
  * Método que verifica si el movimiento en columnas es valido.
   * @param posX Coordenada horizontal de la casilla a verificar
   * @param posY Coordenada vertical de la casilla a verificar
   */
  boolean validoEnColumna(int posX, int posY, int[][]mundo) {
    List<Integer> columna = mismaColumna(posX, mundo);
    //Primero revisaremos el lado izquierdo desde la casilla a verificar.
    boolean valido = revisaIzquierda(columna, posY, getColorActual());
    boolean esValido = false;
    if (valido) {
      esValido = true;
      // Si ya sabemos que es un movimiento valido queremos que pinte las fichas del color actual.
      for (int i = posY - 1; i >= indice; i--) {
        mundo[posX][i] = getColorActual();
      }
    }
    valido = revisaDerecha(columna, posY, getColorActual());
    if (valido) {
      esValido = true;
      // Si ya sabemos que es un movimiento valido queremos que pinte las fichas del color actual.
      for (int i = posY + 1; i <= indice; i++) {
        mundo[posX][i] = getColorActual();
      }
    }
    return esValido;
  }

  /*
  * Método que verifica para las lineas disponibles de la ficha si es un movimiento valido.
   * Contempla todos los casos (columnas, filas y diagonales).
   * @param posX Coordenada horizontal de la casilla a verificar
   * @param posY Coordenada vertical de la casilla a verificar
   */
  boolean movimientoValido(int posX, int posY, int[][]mundo) {
    boolean columna = validoEnColumna(posX, posY, mundo);
    boolean fila = validoEnFila(posX, posY, mundo);
    boolean diagonalD = validoEnDiagonalDerecha(posX, posY, mundo);
    boolean diagonalI = validoEnDiagonalIzquierda(posX, posY, mundo);
    if ( columna || fila || diagonalD || diagonalI) {
      return true;
    }
    return false;
  }

  boolean tiroValido(int posX, int posY, int[][]mundo, int colorActual) {
    if (tiroFila(posX, posY, mundo, colorActual) || tiroColumna(posX, posY, mundo, colorActual) || 
      tiroDiagonalD(posX, posY, mundo, colorActual) || tiroDiagonalI(posX, posY, mundo, colorActual)) {
      return true;
    }
    return false;
  }

  /*
 * Método que dice si es un tiro valido en fila SIN pintar las fichas.
   */
  boolean tiroFila(int posX, int posY, int[][]mundo, int colorActual) {
    List<Integer> fila = mismaFila(posY, mundo);
    if (revisaIzquierda(fila, posX, colorActual) || revisaDerecha(fila, posX, colorActual)) return true;
    return false;
  }
  /*
 * Método que dice si es un tiro valido en columna SIN pintar las fichas.
   */
  boolean tiroColumna(int posX, int posY, int[][]mundo, int colorActual) {
    List<Integer> columna = mismaColumna(posX, mundo);
    if (revisaIzquierda(columna, posY, colorActual) || revisaDerecha(columna, posY, colorActual)) return true;
    return false;
  }
  /*
 * Método que dice si es un tiro valido en diagonal derecha (/) SIN pintar las fichas.
   */
  boolean tiroDiagonalD(int posX, int posY, int[][]mundo, int colorActual) {
    List<Integer> diagonalD = enDiagonalDerecha(posX, posY, mundo);
    if (revisaIzquierda(diagonalD, iteradorDiagonal, colorActual) || revisaDerecha(diagonalD, iteradorDiagonal, colorActual)) return true;
    return false;
  }
  /*
 * Método que dice si es un tiro valido en diagonal izquierda (\) SIN pintar las fichas.
   */
  boolean tiroDiagonalI(int posX, int posY, int[][]mundo, int colorActual) {
    List<Integer> diagonalI = enDiagonalIzquierda(posX, posY, mundo);
    if (revisaIzquierda(diagonalI, iteradorDiagonal, colorActual) || revisaDerecha(diagonalI, iteradorDiagonal, colorActual)) return true;
    return false;
  }



  /*
 * Método que nos da las fichas que están en la misma fila (horizontal) de la casilla a verificar.
   * @param posY Coordenada vertical de la casilla a verificar
   */
  List<Integer> mismaFila(int posY, int[][]mundo) {
    List<Integer> fila = new ArrayList<Integer>();

    for (int celda = 0; celda <  dimension; celda++) {
      fila.add(mundo[celda][posY]);
    }
    return fila;
  }

  /*
  * Método que verifica si el movimiento en filas es valido.
   * @param posX Coordenada horizontal de la casilla a verificar
   * @param posY Coordenada vertical de la casilla a verificar
   */
  boolean validoEnFila(int posX, int posY, int[][]mundo) {
    List<Integer> fila = mismaFila(posY, mundo);
    boolean valido = revisaIzquierda(fila, posX, getColorActual());
    boolean esValido = false;
    if (valido) {
      esValido = true;
      // Si ya sabemos que es un movimiento valido queremos que pinte las fichas del color actual.
      for (int i = posX - 1; i >= indice; i--) {
        mundo[i][posY] = getColorActual();
      }
    }
    valido = revisaDerecha(fila, posX, getColorActual());
    if (valido) {
      esValido = true;
      // Si ya sabemos que es un movimiento valido queremos que pinte las fichas del color actual.
      for (int i = posX + 1; i <= indice; i++) {
        mundo[i][posY] = getColorActual();
      }
    }
    return esValido;
  }

  /**
   * Método que nos da la lista de fichas que están en la diagonal derecha (/) empezando desde abajo
   * @param posX Coordenada horizontal de la casilla a verificar
   * @param posY Coordenada vertical de la casilla a verificar
   */
  List<Integer> enDiagonalDerecha(int posX, int posY, int[][]mundo) {
    List<Integer> diagonal = new ArrayList<Integer>();
    List<Integer> temp = new ArrayList<Integer>();
    iteradorDiagonal = 0;
    //Parte Izquierda (hacia abajo) empezando desde donde se da clic
    int valorFila = posX;
    int valorColumna = posY;
    while (valorFila >= 0 && valorColumna < dimension) {
      temp.add(mundo[valorFila][valorColumna]);
      valorFila--;
      valorColumna++;
    }
    //Necesitamos la reversa de la lista para tener las fichas desde el inicio inferior de la diagonal
    Collections.reverse(temp);
    for (int n : temp) {
      diagonal.add(n);
    }
    iteradorDiagonal = diagonal.size() -1;
    //Parte Derecha (hacia arriba) empezando desde donde se da clic
    valorFila = posX + 1;
    valorColumna = posY - 1;
    while (valorFila < dimension && valorColumna >= 0) {
      diagonal.add(mundo[valorFila][valorColumna]);
      valorFila++;
      valorColumna--;
    }
    return diagonal;
  }

  /**
   * Método que nos da la lista de fichas que están en la diagonal izquierda (\) empezando desde arriba
   * @param posX Coordenada horizontal de la casilla a verificar
   * @param posY Coordenada vertical de la casilla a verificar
   */
  List<Integer> enDiagonalIzquierda(int posX, int posY, int[][]mundo) {
    List<Integer> diagonal = new ArrayList<Integer>();
    List<Integer> temp = new ArrayList<Integer>();
    iteradorDiagonal = 0; 
    //Parte Izquierda (hacia arriba) empezando desde donde se da clic
    int valorFila = posX;
    int valorColumna = posY;
    while (valorFila >= 0 && valorColumna >= 0) {
      temp.add(mundo[valorFila][valorColumna]);
      valorFila--;
      valorColumna--;
    }
    //Necesitamos la reversa de la lista para tener las fichas desde el inicio superior de la diagonal
    Collections.reverse(temp);
    for (int n : temp) {
      diagonal.add(n);
    }
    iteradorDiagonal = diagonal.size() -1;
    //Parte Derecha (hacia abajo) empezando desde donde se da clic
    valorFila = posX + 1;
    valorColumna = posY + 1;
    while (valorFila < dimension && valorColumna < dimension) {
      diagonal.add(mundo[valorFila][valorColumna]);
      valorFila++;
      valorColumna++;
    }
    return diagonal;
  }

  /*
  * Método que verifica si el movimiento en diagonal derecha(/) es valido, y de ser asi pinta las fichas "atrapadas"
   * @param posX Coordenada horizontal de la casilla a verificar
   * @param posY Coordenada vertical de la casilla a verificar
   */
  boolean validoEnDiagonalDerecha(int posX, int posY, int[][]mundo) {
    List<Integer> diagonal = enDiagonalDerecha(posX, posY, mundo);
    boolean valido = revisaIzquierda(diagonal, iteradorDiagonal, getColorActual());
    boolean esValido = false;

    if (valido) {
      esValido = true;
      // Si ya sabemos que es un movimiento valido queremos que pinte las fichas del color actual.
      int valorFila = posX - 1;
      int valorColumna = posY + 1;
      while (valorFila >= 0 && valorColumna < dimension) {
        if (mundo[valorFila][valorColumna] == getColorActual() || mundo[valorFila][valorColumna] == 0) { 
          break;
        }
        mundo[valorFila][valorColumna] = getColorActual();
        valorFila--;
        valorColumna++;
      }
    }
    valido = revisaDerecha(diagonal, iteradorDiagonal, getColorActual());
    if (valido) {
      esValido = true;
      // Si ya sabemos que es un movimiento valido queremos que pinte las fichas del color actual.
      int valorFila = posX+1;
      int valorColumna = posY-1;
      while (valorFila < dimension && valorColumna >= 0 ) {
        if (mundo[valorFila][valorColumna] == getColorActual() || mundo[valorFila][valorColumna] == 0) { 
          break;
        }
        mundo[valorFila][valorColumna] = getColorActual();
        valorFila++;
        valorColumna--;
      }
    }
    return esValido;
  }

  /* Método que verifica si el movimiento en diagonal izquierda (\) es valido y de ser asi pinta las fichas "atrapadas"
   * @param posX Coordenada horizontal de la casilla a verificar
   * @param posY Coordenada vertical de la casilla a verificar
   */
  boolean validoEnDiagonalIzquierda(int posX, int posY, int[][]mundo) {
    List<Integer> diagonal = enDiagonalIzquierda(posX, posY, mundo);
    boolean valido = revisaIzquierda(diagonal, iteradorDiagonal, getColorActual());
    boolean esValido = false;

    if (valido) {
      esValido = true;
      // Si ya sabemos que es un movimiento valido queremos que pinte las fichas del color actual.
      int valorFila = posX - 1;
      int valorColumna = posY - 1;

      while (valorFila >= 0 && valorColumna >= 0) {
        if (mundo[valorFila][valorColumna] == getColorActual() || mundo[valorFila][valorColumna] == 0) { 
          break;
        }
        mundo[valorFila][valorColumna] = getColorActual();
        valorFila--;
        valorColumna--;
      }
    }
    valido = revisaDerecha(diagonal, iteradorDiagonal, getColorActual());
    if (valido) {
      esValido = true;
      // Si ya sabemos que es un movimiento valido queremos que pinte las fichas del color actual.
      int valorFila = posX+1;
      int valorColumna = posY+1;
      while (valorFila < dimension && valorColumna < dimension) {
        if (mundo[valorFila][valorColumna] == getColorActual() || mundo[valorFila][valorColumna] == 0) { 
          break;
        }
        mundo[valorFila][valorColumna] = getColorActual();
        valorFila++;
        valorColumna++;
      }
    }
    return esValido;
  }

  /**
   * Método que nos devuelve el turno actual. 
   * true para el turno de las negras y false para el turno de las blancas.
   */
  boolean getTurno() {
    return turno;
  }

  /**
   * Cuenta la cantidad de fichas de un jugador
   * @return La cantidad de fichas de ambos jugadores en el tablero como vector, 
   * donde x = jugador1, y = jugador2
   */
  PVector cantidadFichas(int[][]mundo) {
    PVector contador = new PVector();
    for (int i = 0; i < dimension; i++)
      for (int j = 0; j < dimension; j++) {
        if (mundo[i][j] == 1)
          contador.x += 1;
        if (mundo[i][j] == 2)
          contador.y += 1;
      }
    return contador;
  }

  /**
   * Método que nos devuelve todos los posibles movimientos de un jugador.
   * @param El tablero del que se quieren obtener las fichas
   * @param El color de las fichas que se contaran -> 1: Negras, 2: Blancas
   */
  List<List<Integer>> posiblesTiros(int[][] tablero, int colorFicha) {
    List<List<Integer>> fichas = new ArrayList<List<Integer>>();
    int lista = 0;
    //Recorre todo el tablero y checa para cada casilla si es un tiro valido para el color de ficha elegido.
    for (int i = 0; i < dimension; i++) {
      for (int j = 0; j < dimension; j++) {
        if (tiroValido(i, j, tablero, colorFicha) && !estaOcupado(i, j)) {
          fichas.add(new ArrayList<Integer>());
          fichas.get(lista).add(i);
          fichas.get(lista).add(j);
          lista++;
        }
      }
    }
    return fichas;
  }

  /**
   * Método que calcula que a cuantas casillas esta una casilla de la esquina más cercana.
   * @param posX El valor de la coordenada x en las casillas del tablero.
   * @param posY El valor de la coordenada y en las casillas del tablero.
   */
  int calculaEsquina(int posX, int posY) {
    int valor = 0;
    // Primer cuadrante del tablero
    if (posX > 3 && posY < 4) {
      valor = Math.max(7-posX, posY);
    }
    // Segundo cuadrante del tablero.
    if (posX < 4 && posY < 4) {
      valor = Math.max(posX, posY);
    }
    // Tercer cuadrante del tablero.
    if (posX < 4 && posY > 3) {
      valor = Math.max(posX, 7-posY);
    }
    // Cuarto cuadrante del tablero.
    if (posX > 3 && posY > 3) {
      valor = Math.max(7-posX, 7-posY);
    }
    return valor;
  }

  /**
   * Método que calcula cuantas lineas son validas la jugada de una ficha fijandose en filas, columnas y diagonales. (adyacencias)
   * @param posX El valor de la coordenada x en las casillas del tablero.
   * @param posY El valor de la coordenada y en las casillas del tablero.
   */
  int calculaAdyacencias(int posX, int posY, int[][]mundo, int colorActual) {
    int valor = 0;
    if (tiroFila(posX, posY, mundo, colorActual)) valor += 1; 
    if (tiroColumna(posX, posY, mundo, colorActual)) valor += 1; 
    if (tiroDiagonalD(posX, posY, mundo, colorActual)) valor += 1;  
    if (tiroDiagonalI(posX, posY, mundo, colorActual)) valor += 1; 
    return valor;
  }
  
  /**
  * HEURISTICA OTHELLO
  * Toma encuenta 3 criterios: el número de fichas ganadas, 
  * el número de adyacencias y que tan cerca de una esquina se encuentra.
  */
  float heuristica(int posX, int posY, int[][]mundo, int colorActual){
    int adyacencias = calculaAdyacencias(posX, posY, mundo, colorActual); //numero de adyacencias
    int esquinas = calculaEsquina(posX, posY); //numero de casillas para llegar a la esquina mas cercana
    PVector fichasTotales = cantidadFichas(mundo); //numero de fichas en el tablero actual.
    float fichas = 0;
    if(colorActual == 1){ fichas = fichasTotales.x; } else { fichas = fichasTotales.y; }
    if(esquinas == 1) { esquinas = 4; } // Para que evite caer en casillas adyacentes a las esquinas
    float valor = fichas + (adyacencias * 2) - esquinas; //Se multiplica por 2 para que sea un factor más importante que el número de fichas
    if(esquinas == 0) { valor = valor*2; } //Para asegurar que si puede tirar en una esquina lo haga
    return valor;
  }
}
