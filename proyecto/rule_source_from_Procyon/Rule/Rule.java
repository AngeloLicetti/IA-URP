// 
// Decompiled by Procyon v0.5.36
// 

package Rule;

import javax.swing.JTextArea;
import java.util.Enumeration;
import java.util.Vector;

public class Rule
{
    BooleanRuleBase rb;
    public String name;
    public Clause[] antecedents;
    public Clause consequent;
    Boolean truth;
    boolean fired;
    
    public Rule(final BooleanRuleBase rb, final String name, final Clause lhs, final Clause rhs) {
        this.fired = false;
        this.rb = rb;
        this.name = name;
        this.antecedents = new Clause[1];
        (this.antecedents[0] = lhs).addRuleRef(this);
        (this.consequent = rhs).addRuleRef(this);
        rhs.setConsequent();
        rb.ruleList.addElement(this);
        this.truth = null;
    }
    
    public Rule(final BooleanRuleBase rb, final String name, final Clause[] lhsClauses, final Clause rhs) {
        this.fired = false;
        this.rb = rb;
        this.name = name;
        this.antecedents = new Clause[lhsClauses.length];
        for (int i = 0; i < lhsClauses.length; ++i) {
            (this.antecedents[i] = lhsClauses[i]).addRuleRef(this);
        }
        (this.consequent = rhs).addRuleRef(this);
        rhs.setConsequent();
        rb.ruleList.addElement(this);
        this.truth = null;
    }
    
    public long numAntecedents() {
        return this.antecedents.length;
    }
    
    public static void checkRules(final Vector clauseRefs) {
        final Enumeration enum1 = clauseRefs.elements();
        while (enum1.hasMoreElements()) {
            final Clause temp = enum1.nextElement();
            final Enumeration enum2 = temp.ruleRefs.elements();
            while (enum2.hasMoreElements()) {
                enum2.nextElement().check();
            }
        }
    }
    
    Boolean check() {
        this.rb.trace("\nTesting rule " + this.name);
        for (int i = 0; i < this.antecedents.length; ++i) {
            if (this.antecedents[i].truth == null) {
                return this.truth = null;
            }
            if (!this.antecedents[i].truth) {
                return this.truth = new Boolean(false);
            }
        }
        return this.truth = new Boolean(true);
    }
    
    void fire() {
        this.rb.trace("\nFiring rule " + this.name);
        this.truth = new Boolean(true);
        this.fired = true;
        if (this.consequent.lhs == null) {
            ((EffectorClause)this.consequent).perform(this.rb);
        }
        else {
            this.consequent.lhs.setValue(this.consequent.rhs);
            checkRules(this.consequent.lhs.clauseRefs);
        }
    }
    
    Boolean backChain() {
        this.rb.trace("\nEvaluating rule " + this.name);
        for (int i = 0; i < this.antecedents.length; ++i) {
            if (this.antecedents[i].truth == null) {
                this.rb.backwardChain(this.antecedents[i].lhs.name);
            }
            if (this.antecedents[i].truth == null) {
                this.antecedents[i].lhs.askUser();
                this.truth = this.antecedents[i].check();
            }
            if (!this.antecedents[i].truth) {
                return this.truth = new Boolean(false);
            }
        }
        return this.truth = new Boolean(true);
    }
    
    void display(final JTextArea textArea) {
        textArea.append(this.name + ": IF ");
        for (int i = 0; i < this.antecedents.length; ++i) {
            final Clause nextClause = this.antecedents[i];
            textArea.append(nextClause.toString());
            if (i + 1 < this.antecedents.length) {
                textArea.append("\n     AND ");
            }
        }
        textArea.append("\n     THEN ");
        textArea.append(this.consequent.toString() + "\n");
    }
    
    void reset() {
        this.fired = false;
    }
}
