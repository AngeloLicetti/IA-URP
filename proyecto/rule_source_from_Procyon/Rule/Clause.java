// 
// Decompiled by Procyon v0.5.36
// 

package Rule;

import java.util.Vector;

public class Clause
{
    Vector ruleRefs;
    public RuleVariable lhs;
    String rhs;
    Condition cond;
    boolean consequent;
    Boolean truth;
    
    public Clause(final RuleVariable lhs, final Condition cond, final String rhs) {
        this.lhs = lhs;
        this.cond = cond;
        this.rhs = rhs;
        lhs.addClauseRef(this);
        this.ruleRefs = new Vector();
        this.truth = null;
        this.consequent = false;
    }
    
    public Clause() {
    }
    
    @Override
    public String toString() {
        return this.lhs.name + this.cond.toString() + this.rhs + " ";
    }
    
    public void addRuleRef(final Rule ref) {
        this.ruleRefs.addElement(ref);
    }
    
    public Boolean check() {
        if (this.consequent) {
            return this.truth = null;
        }
        if (this.lhs.value == null) {
            return this.truth = null;
        }
        Double lhsNumericValue = null;
        Double rhsNumericValue = null;
        boolean bothNumeric = true;
        try {
            lhsNumericValue = Double.valueOf(this.lhs.value);
            rhsNumericValue = Double.valueOf(this.rhs);
        }
        catch (Exception e) {
            bothNumeric = false;
        }
        switch (this.cond.index) {
            case 1: {
                if (bothNumeric) {
                    this.truth = new Boolean(lhsNumericValue.compareTo(rhsNumericValue) == 0);
                    break;
                }
                this.truth = new Boolean(this.lhs.value.equalsIgnoreCase(this.rhs));
                break;
            }
            case 2: {
                if (bothNumeric) {
                    this.truth = new Boolean(lhsNumericValue.compareTo(rhsNumericValue) > 0);
                    break;
                }
                this.truth = new Boolean(this.lhs.value.compareTo(this.rhs) > 0);
                break;
            }
            case 3: {
                if (bothNumeric) {
                    this.truth = new Boolean(lhsNumericValue.compareTo(rhsNumericValue) < 0);
                    break;
                }
                this.truth = new Boolean(this.lhs.value.compareTo(this.rhs) < 0);
                break;
            }
            case 4: {
                if (bothNumeric) {
                    this.truth = new Boolean(lhsNumericValue.compareTo(rhsNumericValue) != 0);
                    break;
                }
                this.truth = new Boolean(this.lhs.value.compareTo(this.rhs) != 0);
                break;
            }
        }
        return this.truth;
    }
    
    public void setConsequent() {
        this.consequent = true;
    }
    
    public Rule getRule() {
        if (this.consequent) {
            return this.ruleRefs.firstElement();
        }
        return null;
    }
    
    public String getClauseString() {
        return this.rhs;
    }
}
