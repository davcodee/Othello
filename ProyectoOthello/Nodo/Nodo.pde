import java.util.*;
public class Nodo<Tablero>{

    public LinkedList<Nodo<Tablero>> hijos;
    private Tablero tablero;



    public Nodo(Tablero t){

        this.tablero = t;
        hijos = new LinkedList<Nodo<Tablero>>();
    }


    public void setDato(Tablero t){
        this.tablero = t;
    }

    public Tablero getDato(){
        return this.tablero;
    }

    public LinkedList<Nodo<Tablero>> getHjos(){
        return hijos;
    }
    /*
     * Método que nos dice si un nodo es hoja.
     */
    public Boolean esHoja(){
        return hijos.size() == 0;
    }

    /*
     * Método que agrega un nodo hijo
     */
    public void agregaHijo(Nodo<Tablero> n){
        hijos.add(n);
    }


}
