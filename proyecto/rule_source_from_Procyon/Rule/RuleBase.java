// 
// Decompiled by Procyon v0.5.36
// 

package Rule;

import java.util.Vector;
import javax.swing.JTextArea;

public interface RuleBase
{
    void setDisplay(final JTextArea p0);
    
    void trace(final String p0);
    
    void displayVariables(final JTextArea p0);
    
    void displayRules(final JTextArea p0);
    
    void reset();
    
    void backwardChain(final String p0);
    
    void forwardChain();
    
    Vector getGoalVariables();
}
