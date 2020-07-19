// 
// Decompiled by Procyon v0.5.36
// 

package Rule;

import java.util.Enumeration;
import java.util.StringTokenizer;
import java.util.Vector;

public abstract class Variable
{
    protected String name;
    protected String value;
    protected Vector labels;
    protected int column;
    
    public Variable() {
    }
    
    public Variable(final String name) {
        this.name = name;
        this.value = null;
    }
    
    public String getName() {
        return this.name;
    }
    
    public void setValue(final String value) {
        this.value = value;
    }
    
    public String getValue() {
        return this.value;
    }
    
    public void setLabels(final String newLabels) {
        this.labels = new Vector();
        final StringTokenizer tok = new StringTokenizer(newLabels, " ");
        while (tok.hasMoreTokens()) {
            this.labels.addElement(new String(tok.nextToken()));
        }
    }
    
    public String getLabel(final int index) {
        return this.labels.elementAt(index);
    }
    
    public Vector getLabels() {
        return (Vector)this.labels.clone();
    }
    
    public String getLabelsAsString() {
        String labelList = new String();
        final Enumeration enum1 = this.labels.elements();
        while (enum1.hasMoreElements()) {
            labelList = labelList + enum1.nextElement() + " ";
        }
        return labelList;
    }
    
    public int getIndex(final String label) {
        int index = -1;
        if (this.labels == null) {
            return index;
        }
        for (int i = 0; i < this.labels.size(); ++i) {
            if (label.equals(this.labels.elementAt(i))) {
                index = i;
                break;
            }
        }
        return index;
    }
    
    public boolean categorical() {
        return this.labels != null;
    }
    
    @Override
    public String toString() {
        return this.name;
    }
    
    public void setColumn(final int column) {
        this.column = column;
    }
    
    public abstract void computeStatistics(final String p0);
    
    public abstract int normalize(final String p0, final float[] p1, final int p2);
    
    public int normalizedSize() {
        return 1;
    }
    
    public String getDecodedValue(final float[] act, final int index) {
        return String.valueOf(act[index]);
    }
}
