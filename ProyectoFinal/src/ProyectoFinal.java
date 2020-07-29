import com.github.cschen1205.ess.engine.*;
import com.github.cschen1205.ess.enums.*;
import com.github.cschen1205.ess.js.*;
import static com.sun.corba.se.impl.util.Utility.printStackTrace;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
//import java.nio.file.Paths;
import java.util.Scanner;
import java.util.Vector;

public class ProyectoFinal {
    public static void main(String[] args) {
        BackwardChainWithNullMemory();
    }
    
    public static void BackwardChainWithNullMemory()
    {
        JSRuleInferenceEngine jsRie = cargarArchivoDeReglas();
        RuleInferenceEngine rie = jsRie.getRie();
        
        System.out.println("Inferencia con memoria de trabajo inicialmente vacía:");
        System.out.println("-----------------------------------------------------:");
        rie.clearFacts();

        Vector<Clause> unproved_conditions= new Vector<>();

        Clause conclusion=null;
        while(conclusion==null)
        {
            conclusion=rie.infer("vehiculo", unproved_conditions);
            if(conclusion==null)
            {
                if(unproved_conditions.size()==0)
                {
                    break;
                }
                Clause c=unproved_conditions.get(0);
                System.out.println("Necesito saber si "+c);
                unproved_conditions.clear();
                String value=showInputDialog("Por favor responde esto: "+c.getVariable()+"?");
                rie.addFact(new EqualsClause(c.getVariable(), value));
                System.out.println("-----------------------------------------------------:");
            }
        }

        System.out.println("Conclusión: "+conclusion);
        System.out.println("Memoria de trabajo: ");
        System.out.println(rie.getFacts());
    }

    private static String showInputDialog(String question) {
        Scanner scanner = new Scanner(System.in);
        System.out.print(question + " ");
        return scanner.next();
    }
    
    private static JSRuleInferenceEngine cargarArchivoDeReglas(){
        JSRuleInferenceEngine engine = new JSRuleInferenceEngine();
        try{
            String currentDirectory = System.getProperty("user.dir");
            String fileName = currentDirectory + "\\src\\archivoDeReglas.js";
            File tempFile = new File(fileName);
            boolean exists = tempFile.exists();
            String jsContent = new String ( Files.readAllBytes( Paths.get(fileName) ) );
            engine.loadString(jsContent);
            engine.buildRules();
        }
        catch (Exception e){
            printStackTrace();
        }
        return engine;
    }
}
