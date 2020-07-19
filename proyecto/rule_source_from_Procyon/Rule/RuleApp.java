// 
// Decompiled by Procyon v0.5.36
// 

package Rule;

import javax.swing.UIManager;

public class RuleApp
{
    boolean packFrame;
    
    public RuleApp() {
        this.packFrame = false;
        final RuleFrame frame = new RuleFrame();
        if (this.packFrame) {
            frame.pack();
        }
        else {
            frame.validate();
        }
        frame.setVisible(true);
    }
    
    public static void main(final String[] args) {
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        }
        catch (Exception ex) {}
        new RuleApp();
    }
}
