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
        //------------------------
        rotarFilaOColumna(mat, 1, 2, 3, 2);
        ES.escribe("\n");
        ES.escribe("\n");
        ES.escribe("MATRIZ ROTADA:");
        mostrarMat(mat, n);
    }
    
    public static void rotarFilaOColumna(int[][] M, int FC, int X, int P, int D){
        for( ; P>0; P--){
            rotarUnaVez(M, FC, X, D);
        }
    }
    
    public static void rotarUnaVez(int[][] M, int FC, int X, int D){
        if(X==1){
            rotarFila(M, FC, D);
        }
        else{
            rotarColumna(M, FC, D);
        }
    }
    
    public static void rotarFila(int[][] M, int FC, int D){
        if(D==1){
            rotarFilaIzquierdaADerecha(M, FC);
        }
        else{
            rotarFilaDerechaAIzquierda(M, FC);
        }
    }
    
    public static void rotarColumna(int[][] M, int FC, int D){
        if(D==1){
            rotarColumnaArribaAAbajo(M, FC);
        }
        else{
            rotarColumnaAbajoAArriba(M, FC);
        }
    }
    
    public static void rotarFilaIzquierdaADerecha(int[][] M, int FC){
        int temp = M[FC][M.length-1];
        for(int i=M.length-1; i>0; i--){
            M[FC][i] = M[FC][i-1];
        }
        M[FC][0] = temp;
    }
    
    public static void rotarFilaDerechaAIzquierda(int[][] M, int FC){
        int temp = M[FC][0];
        for(int i=0; i<M.length-1; i++){
            M[FC][i] = M[FC][i+1];
        }
        M[FC][M.length-1] = temp;
    }
    
    public static void rotarColumnaArribaAAbajo(int[][] M, int FC){
        int temp = M[M.length-1][FC];
        for(int i=M.length-1; i>0; i--){
            M[i][FC] = M[i-1][FC];
        }
        M[0][FC] = temp;
    }
    
    public static void rotarColumnaAbajoAArriba(int[][] M, int FC){
        int temp = M[0][FC];
        for(int i=0; i<M.length-1; i++){
            M[i][FC] = M[i+1][FC];
        }
        M[M.length-1][FC] = temp;
    }
}
