import java.util.*;
public class Nodo{

    /*Hijos de nuesto nodo*/
    public LinkedList<Nodo> hijos;
    /*Tablero de nuestro nodo*/
    private Tablero tablero;
    /*Valor Eurístico de nuestro nodo*/
    private int value;



    public Nodo(Tablero t){

        this.tablero = t;
        hijos = new LinkedList<Nodo>();
        //TODO : aplicar la heuríritca
        value = 0 ;
       
     }


    public void setDato(Tablero t){
        this.tablero = t;
    }

    public Tablero getDato(){
        return this.tablero;
    }
    
     public void setValue(int value){
       this.value = value;
     }
     public int getValue(){
        return value;
     }  
     
    

    public LinkedList<Nodo> getHijos(){
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
