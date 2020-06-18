/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package resoluciondeproblemas;

import consola.ES;
import static resoluciondeproblemas.LlenarMostrarMatriz.llenarMat;
import static resoluciondeproblemas.LlenarMostrarMatriz.mostrarMat;

/**
 *
 * @author Pc
 */
public class RotarMatriz {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {

        // TODO code application logic here
        int [][]mat = {{1,2,3,4,5},{6,7,8,9,10},{11,12,13,14,15},{16,17,18,19,20},{21,22,23,24,25}};
        int n = 25;
        ES.escribe("MATRIZ:");
        mostrarMat(mat, n);
        //-------------------------
        rotarMatriz(mat, 1, 2, 3, 2);
        ES.escribe("\n");
        ES.escribe("\n");
        ES.escribe("MATRIZ ROTADA:");
        mostrarMat(mat, n);
    }
    
    public static void rotarMatriz(int[][] M, int FC, int X, int P, int D){
        //FC: índice de fila o columna (de 0 a más)
        //X: 1= FC es de filas; 2= FC es de columnas
        //P: cantidad de posiciones a rotar
        //D: dirección de rotación
        //1 = arriba a abajo / izquierda a derecha
        //2 = abajo a arriba / derecha a izquierda
        if(FC >= M.length){
            return;
        }
        if(X==1){
            rotarFila(M, FC, P, D);
        }
        else if(X==2){
            rotarColumna(M, FC, P, D);
        }
    }
    
    public static void rotarFila(int[][] matriz, int indice, int posiciones, int direccion){
        int[] fila = matriz[indice];
        for(int i = 0; i < posiciones; i++){
            fila = rotarFilaUnaPosicion(fila, direccion);
        }
        matriz[indice] = fila;
    }
    
    public static int[] rotarFilaUnaPosicion(int[] fila, int direccion){
        if(direccion==1){
            return rotarFilaUnaPosicionDerecha(fila);
        }
        else if(direccion==2){
            return rotarFilaUnaPosicionIzquierda(fila);
        }
        else{
            return fila;
        }
    }
    
    public static int[] rotarFilaUnaPosicionDerecha(int[] fila){
        int temp = fila[fila.length-1];
        int filaAux[] = new int[fila.length];
        for(int i = 1; i<filaAux.length; i++){
            filaAux[i] = fila[i-1];
        }
        filaAux[0] = temp;
        return filaAux;
    }
    
    public static int[] rotarFilaUnaPosicionIzquierda(int[] fila){
        int temp = fila[0];
        int filaAux[] = new int[fila.length];
        for(int i=1; i<fila.length; i++){
            filaAux[i-1] = fila[i];
        }
        filaAux[filaAux.length-1] = temp;
        return filaAux;
    }
    
    public static void rotarColumna(int[][] matriz, int indice, int posiciones, int direccion){
        for(int i = 0; i < posiciones; i++){
            rotarColumnaUnaPosicion(matriz, indice, direccion);
        }
    }
    
    public static void rotarColumnaUnaPosicion(int[][] matriz, int indice, int direccion){
        if(direccion==1){
            rotarColumnaUnaPosicionAbajo(matriz, indice);
        }
        else if(direccion==2){
            rotarColumnaUnaPosicionArriba(matriz, indice);
        }
    }
    
    public static void rotarColumnaUnaPosicionAbajo(int[][] matriz, int indice){
        int temp = matriz[matriz.length-1][indice];
        for(int i = matriz.length -1; i>0; i--){
            matriz[i][indice] = matriz[i-1][indice];
        }
        matriz[0][indice] = temp;
    }
    
    public static void rotarColumnaUnaPosicionArriba(int[][] matriz, int indice){
        int temp = matriz[0][indice];
        for(int i = 0; i<matriz.length - 1; i++){
            matriz[i][indice] = matriz[i+1][indice];
        }
        matriz[matriz.length-1][indice] = temp;
    }
}
