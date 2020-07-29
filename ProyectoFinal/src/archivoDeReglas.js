expert.newRule("bici")
    .ifEquals("tipo_de_vehiculo", "no_carro")
    .andEquals("numero_de_llantas", 2)
    .andEquals("tiene_motor", "no")
    .thenEquals("vehiculo", "bici")
    .build();

expert.newRule("triciclo")
    .ifEquals("tipo_de_vehiculo", "no_carro")
    .andEquals("numero_de_llantas", 3)
    .andEquals("tiene_motor", "no")
    .thenEquals("vehiculo", "triciclo")
    .build();

expert.newRule("moto")
    .ifEquals("tipo_de_vehiculo", "no_carro")
    .andEquals("numero_de_llantas", 2)
    .andEquals("tiene_motor", "yes")
    .thenEquals("vehiculo", "moto")
    .build();

expert.newRule("deportivo")
    .ifEquals("tipo_de_vehiculo", "carro")
    .andEquals("tamaño", "medium")
    .andEquals("numero_de_puertas", 2)
    .thenEquals("vehiculo", "deportivo")
    .build();

expert.newRule("Sedan")
    .ifEquals("tipo_de_vehiculo", "carro")
    .andEquals("tamaño", "medium")
    .andEquals("numero_de_puertas", 4)
    .thenEquals("vehiculo", "Sedan")
    .build();

expert.newRule("MiniVan")
    .ifEquals("tipo_de_vehiculo", "carro")
    .andEquals("tamaño", "medium")
    .andEquals("numero_de_puertas", 3)
    .thenEquals("vehiculo", "MiniVan")
    .build();

expert.newRule("SUV")
    .ifEquals("tipo_de_vehiculo", "carro")
    .andEquals("tamaño", "large")
    .andEquals("numero_de_puertas", 4)
    .thenEquals("vehiculo", "SUV")
    .build();

expert.newRule("con_llantas")
    .ifLess("numero_de_llantas", 4)
    .thenEquals("tipo_de_vehiculo", "no_carro")
    .build();

expert.newRule("carro")
    .ifEquals("numero_de_llantas", 4)
    .andEquals("tiene_motor", "yes")
    .thenEquals("tipo_de_vehiculo", "carro")
    .build();