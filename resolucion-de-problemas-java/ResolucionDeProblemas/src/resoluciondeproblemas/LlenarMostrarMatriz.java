/*P014.java */
package resoluciondeproblemas;
import consola.ES;
public class LlenarMostrarMatriz {
    
    public static int llenarMat(int m[][]){
        return llenarMatAux(m, 0);
    }
    
    public static int llenarMatAux(int m[][], int i){
        if(i==indiceMaximoMat(m)+1){return i;}
        ES.escribe("sig: ");
        int f = fila(m,i);
        int c = columna(m,i);
        m[f][c]=ES.leeInt();
        if(m[f][c]<0){return i;}
        return llenarMatAux(m, i+1);
    }
    
    public static void mostrarMat(int m[][], int n){
        mostrarMatAux(m, n, 0);
    }
    
    public static void mostrarMatAux(int m[][], int n, int i){
        if(i==n){return;}
        int f = fila(m,i);
        int c = columna(m,i);
        if(c==0){
            ES.escribe("\n");
        }
        ES.escribe(m[f][c]+" ");
        mostrarMatAux(m, n, i+1);
    }
    
    public static int indiceMaximoMat(int m[][]){
        return m.length*m[0].length-1;
    }
    
    public static int fila(int [][]m, int i){
        return i/m[0].length;
    }
    
    public static int columna(int [][]m, int i){
        return i%m[0].length;
    }
    
    public static void main(String[] args) {
        final int MAX_M = 4;
        final int MAX_N = 3;
        int [][]mat = new int[MAX_M][MAX_N];
        int n;
        //----------------------------------
        n = llenarMat(mat);
        mostrarMat(mat, n);
    }    
}