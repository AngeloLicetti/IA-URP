// 
// Decompiled by Procyon v0.5.36
// 

package Rule;

public class SensorEffectorTest implements Sensor, Effector
{
    public static void main(final String[] args) {
        final SensorEffectorTest seTest = new SensorEffectorTest();
        seTest.test();
    }
    
    private void test() {
        final BooleanRuleBase rb = new BooleanRuleBase("test");
        this.initVehiclesRuleBase(rb);
        rb.setVariableValue("vehicle", null);
        rb.setVariableValue("vehicleType", null);
        rb.initializeFacts();
        rb.forwardChain();
    }
    
    public void initVehiclesRuleBase(final BooleanRuleBase rb) {
        final RuleVariable vehicle = new RuleVariable(rb, "vehicle");
        vehicle.setLabels("Bicycle Tricycle MotorCycle Sports_Car Sedan MiniVan Sports_Utility_Vehicle");
        vehicle.setPromptText("What kind of vehicle is it?");
        final RuleVariable vehicleType = new RuleVariable(rb, "vehicleType");
        vehicleType.setLabels("cycle automobile");
        vehicleType.setPromptText("What type of vehicle is it?");
        final RuleVariable size = new RuleVariable(rb, "size");
        size.setLabels("small medium large");
        size.setPromptText("What size is the vehicle?");
        final RuleVariable motor = new RuleVariable(rb, "motor");
        motor.setLabels("yes no");
        motor.setPromptText("Does the vehicle have a motor?");
        final RuleVariable num_wheels = new RuleVariable(rb, "num_wheels");
        num_wheels.setLabels("2 3 4");
        num_wheels.setPromptText("How many wheels does it have?");
        final RuleVariable num_doors = new RuleVariable(rb, "num_doors");
        num_doors.setLabels("2 3 4");
        num_doors.setPromptText("How many doors does it have?");
        final Condition cEquals = new Condition("=");
        final Condition cNotEquals = new Condition("!=");
        final Condition cLessThan = new Condition("<");
        final Rule Bicycle = new Rule(rb, "bicycle", new Clause[] { new Clause(vehicleType, cEquals, "cycle"), new Clause(num_wheels, cEquals, "2"), new Clause(motor, cEquals, "no") }, new Clause(vehicle, cEquals, "Bicycle"));
        final Rule Tricycle = new Rule(rb, "tricycle", new Clause[] { new Clause(vehicleType, cEquals, "cycle"), new Clause(num_wheels, cEquals, "3"), new Clause(motor, cEquals, "no") }, new Clause(vehicle, cEquals, "Tricycle"));
        final Rule Motorcycle = new Rule(rb, "motorcycle", new Clause[] { new Clause(vehicleType, cEquals, "cycle"), new Clause(num_wheels, cEquals, "2"), new Clause(motor, cEquals, "yes") }, new Clause(vehicle, cEquals, "Motorcycle"));
        final Rule SportsCar = new Rule(rb, "sportsCar", new Clause[] { new Clause(vehicleType, cEquals, "automobile"), new Clause(size, cEquals, "small"), new Clause(num_doors, cEquals, "2") }, new Clause(vehicle, cEquals, "Sports_Car"));
        final Rule Sedan = new Rule(rb, "sedan", new Clause[] { new Clause(vehicleType, cEquals, "automobile"), new Clause(size, cEquals, "medium"), new Clause(num_doors, cEquals, "4") }, new Clause(vehicle, cEquals, "Sedan"));
        final Rule MiniVan = new Rule(rb, "miniVan", new Clause[] { new Clause(vehicleType, cEquals, "automobile"), new Clause(size, cEquals, "medium"), new Clause(num_doors, cEquals, "3") }, new Clause(vehicle, cEquals, "MiniVan"));
        final Rule SUV = new Rule(rb, "SUV", new Clause[] { new Clause(vehicleType, cEquals, "automobile"), new Clause(size, cEquals, "large"), new Clause(num_doors, cEquals, "4") }, new Clause(vehicle, cEquals, "Sports_Utility_Vehicle"));
        final Rule Cycle = new Rule(rb, "Cycle", new Clause(num_wheels, cLessThan, "4"), new Clause(vehicleType, cEquals, "cycle"));
        final Rule Automobile = new Rule(rb, "Automobile", new Clause[] { new Clause(num_wheels, cEquals, "4"), new Clause(motor, cEquals, "yes") }, new Clause(vehicleType, cEquals, "automobile"));
        final Rule EffectorTest = new Rule(rb, "EffectorTest", new Clause(num_wheels, cEquals, "4"), new EffectorClause("display", "It has 4 wheels!"));
        rb.addEffector(this, "display");
        final RuleVariable sensor_var = new RuleVariable(rb, "sensor_var");
        sensor_var.setLabels("2 3 4");
        sensor_var.setPromptText("What does the sensor say?");
        rb.variableList.put(sensor_var.name, sensor_var);
        final Rule SensorTest = new Rule(rb, "SensorTest", new Clause[] { new Clause(num_wheels, cEquals, "4"), new SensorClause("sensor_var", sensor_var) }, new EffectorClause("display", "It's an automobile!!!!"));
        rb.addSensor(this, "sensor_var");
        final Fact f1 = new Fact(rb, "f1", new Clause(num_wheels, cEquals, "4"));
        final Fact f2 = new Fact(rb, "f2", new SensorClause("sensor_var", sensor_var));
        final Fact f3 = new Fact(rb, "f3", new EffectorClause("display", "Just the facts man !"));
    }
    
    public long display(final String arg) {
        System.out.println("Effector display = " + arg);
        return 0L;
    }
    
    public Boolean sensor_var() {
        return new Boolean(true);
    }
    
    @Override
    public long effector(final Object obj, final String eName, final String args) {
        System.out.println("Effector " + eName + " called with args " + args);
        return 1L;
    }
    
    @Override
    public Boolean sensor(final Object obj, final String sName, final RuleVariable lhs) {
        System.out.println("Sensor " + sName + " called with lhs = " + lhs);
        return new Boolean(true);
    }
}
