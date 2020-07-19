// 
// Decompiled by Procyon v0.5.36
// 

package Rule;

import javax.swing.JTextArea;

public class Fact
{
    BooleanRuleBase rb;
    String name;
    Clause fact;
    Boolean truth;
    boolean fired;
    
    Fact(final BooleanRuleBase Rb, final String Name, final Clause f) {
        this.fired = false;
        this.rb = Rb;
        this.name = Name;
        this.fact = f;
        this.rb.addFact(this);
        this.truth = null;
    }
    
    public void assertion(final BooleanRuleBase rb) {
        if (this.fired) {
            return;
        }
        rb.trace("\nAsserting fact " + this.name);
        this.truth = new Boolean(true);
        this.fired = true;
        if (this.fact.lhs == null) {
            ((EffectorClause)this.fact).perform(rb);
        }
        else {
            this.fact.lhs.setValue(this.fact.rhs);
        }
    }
    
    void display(final JTextArea textArea) {
        textArea.append(this.name + ": ");
        textArea.append(this.fact.toString() + "\n");
    }
}
