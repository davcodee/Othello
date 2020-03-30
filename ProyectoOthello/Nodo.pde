import java.util.*;
public class Nodo{

    public LinkedList<Nodo> hijos;
    private Tablero tablero;



    public Nodo(Tablero t){

        this.tablero = t;
        hijos = new LinkedList<Nodo>();
    }


    public void setDato(Tablero t){
        this.tablero = t;
    }

    public Tablero getDato(){
        return this.tablero;
    }

    public LinkedList<Nodo> getHjos(){
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
    public void agregaHijo(Nodo n){
        hijos.add(n);
    }


}
