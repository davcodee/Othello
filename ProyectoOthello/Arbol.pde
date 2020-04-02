

import java.util.*;
public class Arbol{

    /* Raíz de nuesto nod*/
    public  Nodo raiz;


    public Arbol(Nodo nodo){
        this.raiz = nodo;
    }
    
    


    /*
     * Método que agrega elementos a un árbol dado un nodo
     */
    public void agrega(Nodo padre, Nodo elemento){
        if (raiz == null){
            raiz = elemento;
        }else{
            if (raiz.getDato().equals(padre)){
                raiz.agregaHijo(elemento);
            }else{
          
                for( Nodo n : padre.hijos){
                   if (n.getDato().equals(elemento)) {
                        padre.hijos.add(n);
                    } else {
                        buscaNodo(n, elemento);
                    }
                } 
               
            }
        }
    }


    /*
    *  Método que agrega  un nodo hijo directamente a la raíz.
    */
    public void agregaRaiz(Nodo n){
        raiz.agregaHijo(n);
    }



    /*
     *   Método que elimina un elemento del arbol
     */
    public void elimina(Nodo padre ,Nodo nodo){
        if(padre.getDato().equals(nodo)){
            padre = null;
        }else{

            for( Nodo n : padre.hijos){
                if(n.getDato().equals(nodo)){
                    padre.hijos.remove(nodo);
                }else{
                    buscaNodo(n, nodo);
                }
            }
           

        }
        return;
    }


  
    /*
    * Método que regresa  un nodo dado su padre
    */
    public Nodo buscaNodo(Nodo padre, Nodo n){
        if(padre.getDato().equals(n)){
            return padre;
        }else{

            for (Nodo nodo: padre.hijos){
                if(nodo.getDato().equals(n)){
                    return nodo;
                }else{
                    buscaNodo(nodo, n);
                }
            }

        }
        return raiz;
    }
}
