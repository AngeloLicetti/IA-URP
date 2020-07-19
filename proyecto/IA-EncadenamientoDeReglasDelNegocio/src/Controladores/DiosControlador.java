package Controladores;

import javax.swing.JOptionPane;

public class DiosControlador {
    public static void ingresarDatosFase1(SistemaDeProduccion sp, int edad, String deudasVigentes, String ingresosEstables){
        sp.getAptoParaSimulacion(edad, deudasVigentes, ingresosEstables);
    }
    
    public static void guardarReglas(int edadMayorDe, int edadDemasiadoViejo, int retrasosMinimosParaConsiderarseMoroso, int interes, double montoExperto, String moneda){
        ReglasDelNegocio.edadMayorDe = edadMayorDe;
        ReglasDelNegocio.edadDemasiadoViejo = edadDemasiadoViejo;
        ReglasDelNegocio.retrasosMinimosParaConsiderarseMoroso = retrasosMinimosParaConsiderarseMoroso;
        ReglasDelNegocio.interes = interes;
        ReglasDelNegocio.montoExperto = montoExperto;
        ReglasDelNegocio.moneda = moneda;
    }
}
