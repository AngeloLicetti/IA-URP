// 
// Decompiled by Procyon v0.5.36
// 

package Rule;

import java.awt.Component;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.Rectangle;
import java.awt.Dimension;
import java.awt.LayoutManager;
import java.awt.Frame;
import javax.swing.JButton;
import javax.swing.JLabel;
import java.awt.BorderLayout;
import javax.swing.JPanel;
import javax.swing.JDialog;

public class AboutDialog extends JDialog
{
    JPanel panel1;
    BorderLayout borderLayout1;
    JPanel jPanel2;
    JLabel jLabel1;
    JLabel jLabel2;
    JLabel jLabel3;
    JLabel jLabel4;
    JLabel jLabel5;
    JButton OKButton;
    
    public AboutDialog(final Frame frame, final String title, final boolean modal) {
        super(frame, title, modal);
        this.panel1 = new JPanel();
        this.borderLayout1 = new BorderLayout();
        this.jPanel2 = new JPanel();
        this.jLabel1 = new JLabel();
        this.jLabel2 = new JLabel();
        this.jLabel3 = new JLabel();
        this.jLabel4 = new JLabel();
        this.jLabel5 = new JLabel();
        this.OKButton = new JButton();
        try {
            this.jbInit();
            this.pack();
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    
    public AboutDialog() {
        this((Frame)null, "", false);
    }
    
    void jbInit() throws Exception {
        this.panel1.setLayout(this.borderLayout1);
        this.panel1.setMinimumSize(new Dimension(420, 250));
        this.panel1.setPreferredSize(new Dimension(420, 250));
        this.jPanel2.setLayout(null);
        this.jLabel1.setHorizontalAlignment(0);
        this.jLabel1.setText("");
        this.jLabel1.setBounds(new Rectangle(1, 10, 400, 22));
        this.jLabel2.setHorizontalAlignment(0);
        this.jLabel2.setText("Constructing Intelligent Agents Using Java");
        this.jLabel2.setBounds(new Rectangle(2, 27, 398, 38));
        this.jLabel3.setHorizontalAlignment(0);
        this.jLabel3.setText("John Wiley & Sons, Inc. ");
        this.jLabel3.setBounds(new Rectangle(0, 66, 401, 22));
        this.jLabel4.setHorizontalAlignment(0);
        this.jLabel4.setText("Technical support: support@bigusbooks.com");
        this.jLabel4.setBounds(new Rectangle(2, 106, 400, 26));
        this.jLabel5.setHorizontalAlignment(0);
        this.jLabel5.setText("(c) Copyright Joseph P. Bigus and Jennifer Bigus, 1997, 2000");
        this.jLabel5.setBounds(new Rectangle(1, 139, 398, 48));
        this.OKButton.setText("OK");
        this.OKButton.setBounds(new Rectangle(155, 207, 79, 27));
        this.OKButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(final ActionEvent e) {
                AboutDialog.this.OKButton_actionPerformed(e);
            }
        });
        this.getContentPane().add(this.panel1);
        this.panel1.add(this.jPanel2, "Center");
        this.jPanel2.add(this.jLabel1, null);
        this.jPanel2.add(this.OKButton, null);
        this.jPanel2.add(this.jLabel2, null);
        this.jPanel2.add(this.jLabel3, null);
        this.jPanel2.add(this.jLabel4, null);
        this.jPanel2.add(this.jLabel5, null);
    }
    
    void OKButton_actionPerformed(final ActionEvent e) {
        this.dispose();
    }
}
