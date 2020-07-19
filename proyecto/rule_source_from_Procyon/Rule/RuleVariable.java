// 
// Decompiled by Procyon v0.5.36
// 

package Rule;

import java.util.Enumeration;
import java.awt.Frame;
import javax.swing.JFrame;
import java.util.Vector;

public class RuleVariable extends Variable
{
    protected BooleanRuleBase rb;
    protected Vector clauseRefs;
    protected String promptText;
    protected String ruleName;
    
    public RuleVariable(final BooleanRuleBase rb, final String name) {
        super(name);
        (this.rb = rb).addVariable(this);
        this.clauseRefs = new Vector();
    }
    
    @Override
    public void setValue(final String value) {
        this.value = value;
        this.updateClauses();
    }
    
    public String askUser() {
        String answer = null;
        final JFrame frame = new JFrame();
        final RuleVarDialog dlg = new RuleVarDialog(frame, "Ask User for Value", true);
        dlg.setLocation(200, 200);
        dlg.setData(this);
        dlg.show();
        answer = dlg.getData();
        this.setValue(answer);
        return this.value;
    }
    
    public void addClauseRef(final Clause ref) {
        this.clauseRefs.addElement(ref);
    }
    
    public void updateClauses() {
        final Enumeration enum1 = this.clauseRefs.elements();
        while (enum1.hasMoreElements()) {
            enum1.nextElement().check();
        }
    }
    
    public void setRuleName(final String ruleName) {
        this.ruleName = ruleName;
    }
    
    public String getRuleName() {
        return this.name;
    }
    
    public void setPromptText(final String prompText) {
        this.promptText = prompText;
    }
    
    public String getPromptText() {
        return this.promptText;
    }
    
    @Override
    public void computeStatistics(final String inValue) {
    }
    
    @Override
    public int normalize(final String inValue, final float[] outArray, final int inx) {
        return inx;
    }
}
