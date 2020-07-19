package Controladores;

import Rule.*;
import java.util.Scanner;

public class SistemaDeProduccion {
    
    static Scanner in = new Scanner(System.in);
    
    static BooleanRuleBase memoriaDeTrabajo = new BooleanRuleBase("");
    
    //"ATRIBUTOS" DE OBJETO-ATRIBUTO-VALOR DEL SISTEMA DE PRODUCCION
    static Condition igual = new Condition("=");
    static Condition diferente = new Condition("!=");
    static Condition mayor = new Condition(">");
    static Condition menor = new Condition("<");

    //"OBJETOS" DE OBJETO-ATRIBUTO-VALOR DEL SISTEMA DE PRODUCCION
    public RuleVariable Edad = new RuleVariable(memoriaDeTrabajo, "Edad");
    public RuleVariable DeudasVigentes = new RuleVariable(memoriaDeTrabajo, "DeudasVigentes");
    public RuleVariable MayorDeEdad = new RuleVariable(memoriaDeTrabajo, "MayorDeEdad");
    public RuleVariable DemasiadoViejo = new RuleVariable(memoriaDeTrabajo, "DemasiadoViejo");
    public RuleVariable IngresosEstables = new RuleVariable(memoriaDeTrabajo, "IngresosEstables");
    public RuleVariable CuotasPagables = new RuleVariable(memoriaDeTrabajo, "CuotasPagables");
    public RuleVariable PrestamosAnteriores = new RuleVariable(memoriaDeTrabajo, "PrestamosAnteriores");
    public RuleVariable RetrasosPrestamosAnteriores = new RuleVariable(memoriaDeTrabajo, "RetrasosPrestamosAnteriores");
    public RuleVariable CuotaInicialPagable = new RuleVariable(memoriaDeTrabajo, "CuotaInicialPagable");
    public RuleVariable AptoParaSimulacion = new RuleVariable(memoriaDeTrabajo, "AptoParaSimulacion");
    public RuleVariable MontoSimulacion = new RuleVariable(memoriaDeTrabajo, "MontoSimulacion");
    public RuleVariable AptoParaEvaluacion = new RuleVariable(memoriaDeTrabajo, "AptoParaEvaluacion");
    public RuleVariable DocumentosCorrectos = new RuleVariable(memoriaDeTrabajo, "DocumentosCorrectos");
    public RuleVariable PagadorPuntual = new RuleVariable(memoriaDeTrabajo, "PagadorPuntual");
    public RuleVariable PagosRetrasados = new RuleVariable(memoriaDeTrabajo, "PagosRetrasados");
    public RuleVariable Moroso = new RuleVariable(memoriaDeTrabajo, "Moroso");
    public RuleVariable Rechazado = new RuleVariable(memoriaDeTrabajo, "Rechazado");
    public RuleVariable PreAprobado = new RuleVariable(memoriaDeTrabajo, "PreAprobado");
    public RuleVariable RequiereExperto = new RuleVariable(memoriaDeTrabajo, "RequiereExperto");
    public RuleVariable Aprobado = new RuleVariable(memoriaDeTrabajo, "Aprobado");
    
    //PROCEDIMIENTOS PARA OBTENER EL "VALOR" DE OBJETO-ATRIBUTO-VALOR DEL SISTEMA DE PRODUCCION
    void getAptoParaSimulacion(int edad, String deudasVigentes, String ingresosEstables){
        Edad.setValue(Integer.toString(edad));
        DeudasVigentes.setValue(deudasVigentes);
        IngresosEstables.setValue(ingresosEstables);
        memoriaDeTrabajo.forwardChain();
    }

    //REGLAS
    Rule rMayorDeEdad = new Rule(memoriaDeTrabajo, "rmayorDeEdad",
        new Clause[]{
            new Clause (Edad, mayor, Integer.toString(ReglasDelNegocio.edadMayorDe))
        },
        new Clause (MayorDeEdad, igual, "s")
    );
    
    Rule rMayorDeEdad2 = new Rule(memoriaDeTrabajo, "rmayorDeEdad2",
        new Clause[]{
            new Clause (Edad, menor, Integer.toString(ReglasDelNegocio.edadMayorDe))
        },
        new Clause (MayorDeEdad, igual, "n")
    );
    
    Rule rMayorDeEdad3 = new Rule(memoriaDeTrabajo, "rmayorDeEdad3",
        new Clause[]{
            new Clause (Edad, igual, Integer.toString(ReglasDelNegocio.edadMayorDe))
        },
        new Clause (MayorDeEdad, igual, "n")
    );

    Rule rDemasiadoViejo = new Rule(memoriaDeTrabajo, "rDemasiadoViejo",
        new Clause[]{
            new Clause (Edad, menor, Integer.toString(ReglasDelNegocio.edadDemasiadoViejo))
        },
        new Clause (DemasiadoViejo, igual, "n")
    );

    Rule rAptoParaSimulacion = new Rule(memoriaDeTrabajo, "rAptoParaSimulacion",
        new Clause[]{
            new Clause (DeudasVigentes, igual, "n"),
            new Clause (MayorDeEdad, igual, "s"),
            new Clause (DemasiadoViejo, igual, "n"),
            new Clause (IngresosEstables, igual, "s")
        },
        new Clause (AptoParaSimulacion, igual, "s")
    );
    
    Rule rNoAptoParaSimulacion = new Rule(memoriaDeTrabajo, "rNoAptoParaSimulacion",
        new Clause[]{
            new Clause (DeudasVigentes, diferente, "n"),
            new Clause (MayorDeEdad, diferente, "s"),
            new Clause (DemasiadoViejo, diferente, "n"),
            new Clause (IngresosEstables, diferente, "s")
        },
        new Clause (AptoParaSimulacion, igual, "n")
    );

    Rule rAptoParaEvaluacion = new Rule(memoriaDeTrabajo, "rAptoParaEvaluacion",
        new Clause[]{
            new Clause (AptoParaSimulacion, igual, "s"),
            new Clause (CuotasPagables, igual, "s")
        },
        new Clause (AptoParaEvaluacion, igual, "s")
    );

    Rule rMoroso1 = new Rule(memoriaDeTrabajo, "rMoroso1",
        new Clause[]{
            new Clause (PrestamosAnteriores, igual, "s"),
            new Clause(PagadorPuntual, igual, "n"),
            new Clause (RetrasosPrestamosAnteriores, menor, Integer.toString(ReglasDelNegocio.retrasosMinimosParaConsiderarseMoroso))
        },
        new Clause (Moroso, igual, "s")
    );

    Rule rMoroso2 = new Rule(memoriaDeTrabajo, "rMoroso2",
        new Clause[]{
            new Clause (PrestamosAnteriores, igual, "s"),
            new Clause(PagadorPuntual, igual, "s")
        },
        new Clause (Moroso, igual, "n")
    );

    Rule rMoroso3 = new Rule(memoriaDeTrabajo, "rMoroso3",
        new Clause[]{
            new Clause (PrestamosAnteriores, igual, "n")
        },
        new Clause (Moroso, igual, "n")
    );

    Rule rPreAprobado = new Rule(memoriaDeTrabajo, "rPreAprobado",
        new Clause[]{
            new Clause (AptoParaEvaluacion, igual, "s"),
            new Clause(DocumentosCorrectos, igual, "s"),
            new Clause (Moroso, igual, "n")
        },
        new Clause (AptoParaSimulacion, igual, "s")
    );

    Rule rRequiereExperto = new Rule(memoriaDeTrabajo, "rRequiereExperto",
        new Clause[]{
            new Clause (MontoSimulacion, mayor, Double.toString(ReglasDelNegocio.montoExperto))
        },
        new Clause (RequiereExperto, igual, "s")
    );

    Rule rAprobado = new Rule(memoriaDeTrabajo, "rAprobado",
        new Clause[]{
            new Clause (PreAprobado, igual, "s"),
            new Clause(CuotaInicialPagable, igual, "s"),
            new Clause (RequiereExperto, igual, "n")
        },
        new Clause (Aprobado, igual, "s")
    );
}
