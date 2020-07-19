
import Rule.*;

public class SistemaExperto {

    BooleanRuleBase basedereglas = new BooleanRuleBase("basedereglas");

    RuleVariable Zapatillas;
    RuleVariable Zapatos;
    RuleVariable Pico;
    RuleVariable Collar;
    RuleVariable Maricon;
    RuleVariable Resultadofinal;
    RuleVariable OrejasRedondas;
    RuleVariable ResultadoCalzado;
    RuleVariable ResultadoPico;
    RuleVariable ResultadoCollar;
    RuleVariable ResultadoOrejasRedondas;
    String resultado = "";

    public String ObtenerCalzado(String zapatillas, String zapatos) {
        basedeconocimiento();
        Zapatillas.setValue(zapatillas);
        Zapatos.setValue(zapatos);
        basedereglas.forwardChain();

        resultado = ResultadoCalzado.getValue();
        return resultado;
    }

    public String Obtene(String zapatillas, String zapatos, String orejas, String m) {
        basedeconocimiento();
        Zapatillas.setValue(zapatillas);
        Zapatos.setValue(zapatos);
        OrejasRedondas.setValue(orejas);
        Maricon.setValue(m);
        basedereglas.forwardChain();

        resultado = Resultadofinal.getValue();
        return resultado;
    }

    public String ObtenerResultadoPico(String resultadoCalzado, String pico) {
        basedeconocimiento();
        ResultadoCalzado.setValue(resultadoCalzado);
        Pico.setValue(pico);
        basedereglas.forwardChain();

        resultado = ResultadoPico.getValue();
        return resultado;
    }

    public String ObtenerResultadoOrejas(String resultadoCalzado, String orejasredondas) {
        basedeconocimiento();
        ResultadoCalzado.setValue(resultadoCalzado);
        OrejasRedondas.setValue(orejasredondas);
        basedereglas.forwardChain();
        resultado = ResultadoOrejasRedondas.getValue();
        return resultado;
    }

    public String ObtenerResultadoCollar(String resultadoCalzado, String collar) {
        basedeconocimiento();
        ResultadoCalzado.setValue(resultadoCalzado);
        Collar.setValue(collar);
        basedereglas.forwardChain();

        resultado = ResultadoCollar.getValue();
        return resultado;
    }

    public void basedeconocimiento() {
        Zapatillas = new RuleVariable(basedereglas, "");
        Zapatos = new RuleVariable(basedereglas, "");
        Pico = new RuleVariable(basedereglas, "");
        Collar = new RuleVariable(basedereglas, "");
        OrejasRedondas = new RuleVariable(basedereglas, "");
        ResultadoCalzado = new RuleVariable(basedereglas, "");
        ResultadoPico = new RuleVariable(basedereglas, "");
        ResultadoCollar = new RuleVariable(basedereglas, "");
        ResultadoOrejasRedondas = new RuleVariable(basedereglas, "");

        Maricon = new RuleVariable(basedereglas, "");
        Resultadofinal = new RuleVariable(basedereglas, "");
        Condition igual = new Condition("=");

        Rule reglauno = new Rule(basedereglas, "reglauno",
                new Clause[]{
                    new Clause(Zapatillas, igual, "si"),
                    new Clause(Zapatos, igual, "no")},
                new Clause(ResultadoCalzado, igual, "TieneZapatillas")
        );

        Rule reglados = new Rule(basedereglas, "reglados",
                new Clause[]{
                    new Clause(Zapatillas, igual, "no"),
                    new Clause(Zapatos, igual, "si")},
                new Clause(ResultadoCalzado, igual, "TieneZapatos")
        );

        Rule reglatres = new Rule(basedereglas, "reglatres",
                new Clause[]{
                    new Clause(Zapatillas, igual, "no"),
                    new Clause(Zapatos, igual, "no")},
                new Clause(ResultadoCalzado, igual, "NoTieneCalzado")
        );

        Rule reglacuatro = new Rule(basedereglas, "reglacuatro",
                new Clause[]{
                    new Clause(ResultadoCalzado, igual, "TieneZapatillas"),
                    new Clause(Pico, igual, "si")},
                new Clause(ResultadoPico, igual, "Daysi")
        );

        Rule reglacinco = new Rule(basedereglas, "reglacinco",
                new Clause[]{
                    new Clause(ResultadoCalzado, igual, "TieneZapatillas"),
                    new Clause(Pico, igual, "no")},
                new Clause(ResultadoPico, igual, "Minnie")
        );

        Rule reglaseis = new Rule(basedereglas, "reglaseis",
                new Clause[]{
                    new Clause(ResultadoCalzado, igual, "TieneZapatos"),
                    new Clause(OrejasRedondas, igual, "si")},
                new Clause(ResultadoOrejasRedondas, igual, "Mickey")
        );

        Rule reglasiete = new Rule(basedereglas, "reglasiete",
                new Clause[]{
                    new Clause(ResultadoCalzado, igual, "TieneZapatos"),
                    new Clause(OrejasRedondas, igual, "no")},
                new Clause(ResultadoOrejasRedondas, igual, "Goofy")
        );

        Rule reglaocho = new Rule(basedereglas, "reglaocho",
                new Clause[]{
                    new Clause(ResultadoCalzado, igual, "NoTieneCalzado"),
                    new Clause(Collar, igual, "si")},
                new Clause(ResultadoCollar, igual, "Pluto")
        );

        Rule reglanueve = new Rule(basedereglas, "reglaocho",
                new Clause[]{
                    new Clause(ResultadoOrejasRedondas, igual, "Goofy"),
                    new Clause(Maricon, igual, "si")},
                new Clause(Resultadofinal, igual, "Plutomaricon")
        );

    }

    public static void main(String[] args) {
        SistemaExperto ro = new SistemaExperto();
        System.out.println("" + ro.Obtene("no", null, "no", "si"));
    }

}
