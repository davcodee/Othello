import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

/**
 * Definición de un tablero para el juego de Othello
 * @author Rodrigo Colín
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
   * El indice hasta el cual se pintara, si es un movimiento valido.
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
  int getColorContraria() {
    boolean turnoActual = getTurno(); // Obtenemos el turno para saber de que color seran las fichas a revisar.
    if (turnoActual) { 
      return 2;
    } else { 
      return 1;
    } // 1:Negras, 2: Blancas.
  }


  /*
  * Método que revisa si es valido colocar una ficha revisando las fichas a la izquierda.
   * @param lista La lista de fichas a revisar.
   * @param iterador El indice desde el cual se quiere empezar a iterar.
   */
  boolean revisaIzquierda(List<Integer> lista, int iterador) {
    ListIterator<Integer> listaIterador = lista.listIterator(iterador);
    int fichaActual = getColorActual(); 
    int fichaContraria = getColorContraria();

    // Primero revisamos que si hay una ficha del color del lado izquierdo, en caso contrario es un movimiento invalido.
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
  * Método que revisa si es valido colocar una ficha revisando las fichas a la derecha.
   * @param lista La lista de fichas a revisar.
   * @param iterador El indice desde el cual se quiere empezar a iterar.
   */
  boolean revisaDerecha(List<Integer> lista, int iterador) {
    ListIterator<Integer> listaIterador = lista.listIterator(iterador);
    int fichaActual = getColorActual(); 
    int fichaContraria = getColorContraria();
    listaIterador.next();
    // Primero revisamos que si hay una ficha del color del lado derecho, en caso contrario es un movimiento invalido.
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
  * Método que nos da las fichas en la misma columna (vertical)
   * @param posX Coordenada horizontal de la casilla a verificar
   * @param posY Coordenada vertical de la casilla a verificar
   */
  List<Integer> mismaColumna(int posX) {
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
  boolean validoEnColumna(int posX, int posY) {
    List<Integer> columna = mismaColumna(posX);
    boolean valido = revisaIzquierda(columna, posY);
    boolean esValido = false;
    if (valido) {
      esValido = true;
      // Si ya sabemos que es un movimiento valido queremos que pinte las fichas del color actual.
      for (int i = posY - 1; i >= indice; i--) {
        mundo[posX][i] = getColorActual();
      }
    }
    valido = revisaDerecha(columna, posY);

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
  boolean movimientoValido(int posX, int posY) {
    // SOLO SE HA IMPLEMENTADO PARA FILAS Y COLUMNAS
    if ( validoEnColumna(posX, posY) || validoEnFila(posX, posY)) {
      return true;
    }
    return false;
  }

  /*
 * Método que nos da las fichas que están en la misma fila (horizontal)
   * @param posY Coordenada vertical de la casilla a verificar
   */
  List<Integer> mismaFila(int posY) {
    List<Integer> fila = new ArrayList<Integer>();

    for (int celda = 0; celda <  dimension; celda++) {
      fila.add(mundo[celda][posY]);
    }
    println("fila" + fila);
    return fila;
  }
  
  /*
  * Método que verifica si el movimiento en filas es valido.
   * @param posX Coordenada horizontal de la casilla a verificar
   * @param posY Coordenada vertical de la casilla a verificar
   */
  boolean validoEnFila(int posX, int posY) {
    List<Integer> fila = mismaFila(posY);
    boolean valido = revisaIzquierda(fila, posX);
    boolean esValido = false;
    if (valido) {
      esValido = true;
      // Si ya sabemos que es un movimiento valido queremos que pinte las fichas del color actual.
      for (int i = posX - 1; i >= indice; i--) {
        mundo[i][posY] = getColorActual();
      }
    }
    valido = revisaDerecha(fila, posX);

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
   * Método que nos da las fichas que están en la diagonal (/)
   * INCOMPLETO
   */
  boolean enDiagonalDerecha(int posX, int posY) {
    List<Integer> diagonal = new ArrayList<Integer>();

    for (int celdaX = 0; celdaX <  dimension; celdaX++) {
      for (int celdaY = 0; celdaY < dimension; celdaY++) {
        diagonal.add(mundo[celdaX][posY]);
      }
    }

    boolean valido = revisaIzquierda(diagonal, posX);
    if (valido) {
      // Si ya sabemos que es un movimiento valido queremos que pinte las fichas del color actual.
      for (int i = posX - 1; i >= indice; i--) {
        mundo[i][posY] = getColorActual();
      }
    }
    return Valido;
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
  PVector cantidadFichas() {
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
}
