package consola;
import java.io.*;
public class ES {
    private static BufferedReader in;
    static{
        in = new BufferedReader(
                    new InputStreamReader(System.in));  
    }
    public static void escribe(String s){
        System.out.print(s);
    }
    public static String leeString(){
        String buffer = null;
        try {
            buffer = in.readLine();
        }catch(IOException e){
            System.err.println("ES.leeString(): " + e);
        }
        return buffer;
    }
    
    public static int leeInt(){
        return Integer.parseInt(leeString());
    }
   
    public static void main(String[] args) {
       escribe("ingrese su nombre: ");
       escribe("Hola " + leeString() + "\n\n");
       escribe("ingrese su edad: ");
       escribe("Tu tienes " + leeInt() + " a�os\n");
    }
}
