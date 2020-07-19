// 
// Decompiled by Procyon v0.5.36
// 

package Rule;

import java.util.Vector;

public class EffectorClause extends Clause
{
    Effector object;
    String effectorName;
    String arguments;
    
    public EffectorClause(final String eName, final String args) {
        this.ruleRefs = new Vector();
        this.truth = new Boolean(true);
        this.consequent = true;
        this.effectorName = eName;
        this.arguments = args;
    }
    
    public String display() {
        return "effector(" + this.effectorName + "," + this.arguments + ") ";
    }
    
    public Boolean perform(final BooleanRuleBase rb) {
        (this.object = (Effector)rb.getEffectorObject(this.effectorName)).effector(this, this.effectorName, this.arguments);
        return this.truth;
    }
}
