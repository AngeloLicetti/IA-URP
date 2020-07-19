// 
// Decompiled by Procyon v0.5.36
// 

package Rule;

import java.util.Vector;

public class SensorClause extends Clause
{
    Sensor object;
    String sensorName;
    
    SensorClause(final String sName, final RuleVariable Lhs) {
        this.lhs = Lhs;
        this.cond = new Condition("=");
        this.rhs = " ";
        this.lhs.addClauseRef(this);
        this.ruleRefs = new Vector();
        this.truth = null;
        this.consequent = false;
        this.sensorName = sName;
    }
    
    public String display() {
        return "sensor(" + this.sensorName + "," + this.rhs + ") ";
    }
    
    @Override
    public Boolean check() {
        if (this.consequent) {
            return null;
        }
        if (this.lhs.value == null) {
            final BooleanRuleBase rb = this.ruleRefs.firstElement().rb;
            this.object = (Sensor)rb.getSensorObject(this.sensorName);
            this.truth = this.object.sensor(this, this.sensorName, this.lhs);
        }
        return this.truth;
    }
}
