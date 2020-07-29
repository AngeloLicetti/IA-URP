expert.newRule("edad_adecuada")
    .ifGreater("edad", 17)
    .andLess("edad", 70)
    .thenEquals("edad_adecuada", "s")
    .build();
    
expert.newRule("deudas_vigentes")
    .ifEquals("prestamos_anteriores", "n")
    .thenEquals("deudas_vigentes", "n")
    .build();

expert.newRule("deudas_vigentes")
    .ifEquals("prestamos_anteriores", "s")
    .andEquals("prestamos_pagados", "s")
    .thenEquals("deudas_vigentes", "n")
    .build();

expert.newRule("ingresos_estables")
    .ifEquals("trabajador_de_empresa", "s")
    .andGreater("meses_antiguedad_trabajo", 17)
    .thenEquals("ingresos_estables", "s")
    .build();    

expert.newRule("apto_para_simulacion")
    .ifEquals("edad_adecuada", "s")
    .andEquals("deudas_vigentes", "n")
    .andEquals("ingresos_estables", "s")
    .thenEquals("apto_para_simulacion", "s")
    .build();

expert.newRule("apto_para_evaluacion")
    .ifEquals("apto_para_simulacion", "s")
    .andEquals("cuotas_pagables", "s")
    .thenEquals("apto_para_evaluacion", "s")
    .build();

expert.newRule("moroso")
    .ifEquals("prestamos_anteriores", "s")
    .andEquals("pagador_puntual", "s")
    .thenEquals("moroso", "n")
    .build();

expert.newRule("moroso")
    .ifEquals("prestamos_anteriores", "n")
    .thenEquals("moroso", "n")
    .build();

expert.newRule("pre_aprobado")
    .ifEquals("apto_para_evaluacion", "s")
    .andEquals("documentos_correctos", "s")
    .andEquals("moroso", "n")
    .thenEquals("pre_aprobado", "s")
    .build();

expert.newRule("aprobado")
    .ifEquals("pre_aprobado", "s")
    .andEquals("cuota_inicial_pagable", "s")
    .andEquals("requiere_experto", "n")
    .thenEquals("aprobado", "s")
    .build();