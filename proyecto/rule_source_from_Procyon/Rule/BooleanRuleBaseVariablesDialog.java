// 
// Decompiled by Procyon v0.5.36
// 

package Rule;

import javax.swing.event.ListSelectionEvent;
import java.util.Enumeration;
import java.util.Vector;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.LayoutManager;
import java.awt.Frame;
import javax.swing.JComboBox;
import javax.swing.JScrollPane;
import javax.swing.JList;
import javax.swing.JLabel;
import javax.swing.JButton;
import java.awt.BorderLayout;
import javax.swing.JPanel;
import javax.swing.event.ListSelectionListener;
import javax.swing.JDialog;

public class BooleanRuleBaseVariablesDialog extends JDialog implements ListSelectionListener
{
    JPanel panel1;
    BorderLayout borderLayout1;
    JPanel jPanel1;
    JButton closeButton;
    JPanel jPanel2;
    JLabel jLabel1;
    JLabel jLabel2;
    JList variableList;
    BooleanRuleBase ruleBase;
    JScrollPane jScrollPane1;
    boolean fillingComboBox;
    JComboBox valueComboBox;
    JLabel jLabel3;
    
    public BooleanRuleBaseVariablesDialog(final Frame frame, final String title, final boolean modal) {
        super(frame, title, modal);
        this.panel1 = new JPanel();
        this.borderLayout1 = new BorderLayout();
        this.jPanel1 = new JPanel();
        this.closeButton = new JButton();
        this.jPanel2 = new JPanel();
        this.jLabel1 = new JLabel();
        this.jLabel2 = new JLabel();
        this.variableList = new JList();
        this.ruleBase = null;
        this.jScrollPane1 = new JScrollPane();
        this.fillingComboBox = false;
        this.valueComboBox = new JComboBox();
        this.jLabel3 = new JLabel();
        try {
            this.jbInit();
            this.pack();
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    
    public BooleanRuleBaseVariablesDialog() {
        this((Frame)null, "", false);
    }
    
    void jbInit() throws Exception {
        this.panel1.setLayout(this.borderLayout1);
        this.closeButton.setText("Close");
        this.closeButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(final ActionEvent e) {
                BooleanRuleBaseVariablesDialog.this.closeButton_actionPerformed(e);
            }
        });
        this.jPanel2.setLayout(null);
        this.jLabel1.setText("Variable");
        this.jLabel1.setBounds(new Rectangle(24, 21, 126, 17));
        this.jLabel2.setText("Value");
        this.jLabel2.setBounds(new Rectangle(216, 22, 41, 17));
        this.variableList.setSelectionMode(0);
        this.variableList.addListSelectionListener(this);
        this.panel1.setMinimumSize(new Dimension(405, 320));
        this.panel1.setPreferredSize(new Dimension(405, 320));
        this.jScrollPane1.setBounds(new Rectangle(20, 48, 186, 183));
        this.valueComboBox.setBounds(new Rectangle(224, 50, 157, 27));
        this.valueComboBox.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(final ActionEvent e) {
                BooleanRuleBaseVariablesDialog.this.valueComboBox_actionPerformed(e);
            }
        });
        this.jLabel3.setText("Select variable to display/change value in combo box.");
        this.jLabel3.setBounds(new Rectangle(25, 241, 364, 16));
        this.getContentPane().add(this.panel1);
        this.panel1.add(this.jPanel1, "South");
        this.jPanel1.add(this.closeButton, null);
        this.panel1.add(this.jPanel2, "Center");
        this.jPanel2.add(this.jScrollPane1, null);
        this.jScrollPane1.getViewport().add(this.variableList, null);
        this.jPanel2.add(this.jLabel1, null);
        this.jPanel2.add(this.jLabel2, null);
        this.jPanel2.add(this.valueComboBox, null);
        this.jPanel2.add(this.jLabel3, null);
    }
    
    protected void initialize() {
        final Vector vars = new Vector();
        final Enumeration enum1 = this.ruleBase.variableList.elements();
        while (enum1.hasMoreElements()) {
            vars.addElement(enum1.nextElement());
        }
        this.variableList.setListData(vars);
    }
    
    void closeButton_actionPerformed(final ActionEvent e) {
        this.dispose();
    }
    
    public void setRuleBase(final BooleanRuleBase ruleBase) {
        this.ruleBase = ruleBase;
        this.initialize();
    }
    
    @Override
    public void valueChanged(final ListSelectionEvent e) {
        final RuleVariable ruleVar = this.variableList.getSelectedValue();
        this.fillingComboBox = true;
        if (this.valueComboBox.getItemCount() > 0) {
            this.valueComboBox.removeAllItems();
        }
        this.valueComboBox.addItem("<null>");
        final Enumeration labels = ruleVar.labels.elements();
        while (labels.hasMoreElements()) {
            this.valueComboBox.addItem(labels.nextElement());
        }
        final String value = ruleVar.getValue();
        if (value == null) {
            this.valueComboBox.setSelectedItem("<null>");
        }
        else {
            this.valueComboBox.setSelectedItem(value);
        }
        this.fillingComboBox = false;
    }
    
    void valueComboBox_actionPerformed(final ActionEvent e) {
        if (this.fillingComboBox) {
            return;
        }
        final RuleVariable ruleVar = this.variableList.getSelectedValue();
        final String varValue = (String)this.valueComboBox.getSelectedItem();
        if (varValue == null || varValue.equals("<null>")) {
            ruleVar.setValue(null);
        }
        else {
            ruleVar.setValue(varValue);
        }
    }
}
