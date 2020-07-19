// 
// Decompiled by Procyon v0.5.36
// 

package Rule;

import java.util.Vector;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.LayoutManager;
import java.awt.Frame;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JButton;
import java.awt.BorderLayout;
import javax.swing.JPanel;
import javax.swing.JDialog;

public class RuleVarDialog extends JDialog
{
    JPanel panel1;
    BorderLayout borderLayout1;
    JPanel jPanel1;
    JPanel jPanel2;
    JButton OKButton;
    JLabel PromptLabel;
    JLabel jLabel2;
    JComboBox ValueComboBox;
    RuleVariable ruleVar;
    
    public RuleVarDialog(final Frame frame, final String title, final boolean modal) {
        super(frame, title, modal);
        this.panel1 = new JPanel();
        this.borderLayout1 = new BorderLayout();
        this.jPanel1 = new JPanel();
        this.jPanel2 = new JPanel();
        this.OKButton = new JButton();
        this.PromptLabel = new JLabel();
        this.jLabel2 = new JLabel();
        this.ValueComboBox = new JComboBox();
        try {
            this.jbInit();
            this.pack();
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    
    public RuleVarDialog() {
        this((Frame)null, "", false);
    }
    
    void jbInit() throws Exception {
        this.panel1.setLayout(this.borderLayout1);
        this.OKButton.setText("OK");
        this.OKButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(final ActionEvent e) {
                RuleVarDialog.this.OKButton_actionPerformed(e);
            }
        });
        this.PromptLabel.setText("What ?");
        this.PromptLabel.setBounds(new Rectangle(32, 29, 341, 17));
        this.jPanel2.setLayout(null);
        this.jLabel2.setText("Value = ");
        this.jLabel2.setBounds(new Rectangle(36, 79, 67, 17));
        this.ValueComboBox.setBounds(new Rectangle(104, 79, 226, 24));
        this.ValueComboBox.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(final ActionEvent e) {
                RuleVarDialog.this.ValueComboBox_actionPerformed(e);
            }
        });
        this.panel1.setMinimumSize(new Dimension(400, 200));
        this.panel1.setPreferredSize(new Dimension(400, 200));
        this.getContentPane().add(this.panel1);
        this.panel1.add(this.jPanel1, "South");
        this.jPanel1.add(this.OKButton, null);
        this.panel1.add(this.jPanel2, "Center");
        this.jPanel2.add(this.PromptLabel, null);
        this.jPanel2.add(this.jLabel2, null);
        this.jPanel2.add(this.ValueComboBox, null);
    }
    
    void OKButton_actionPerformed(final ActionEvent e) {
        this.dispose();
    }
    
    void ValueComboBox_actionPerformed(final ActionEvent e) {
    }
    
    public void setData(final RuleVariable ruleVar) {
        this.ruleVar = ruleVar;
        this.PromptLabel.setText(ruleVar.getPromptText());
        final Vector labels = ruleVar.getLabels();
        if (labels != null) {
            for (int i = 0; i < labels.size(); ++i) {
                this.ValueComboBox.addItem(labels.elementAt(i));
            }
            this.ValueComboBox.setEditable(false);
        }
        else {
            this.ValueComboBox.setEditable(true);
        }
    }
    
    public String getData() {
        return (String)this.ValueComboBox.getSelectedItem();
    }
}
