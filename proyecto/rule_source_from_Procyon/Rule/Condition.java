// 
// Decompiled by Procyon v0.5.36
// 

package Rule;

public class Condition
{
    int index;
    String symbol;
    
    public Condition(final String symbol) {
        this.symbol = symbol;
        if (symbol.equals("=")) {
            this.index = 1;
        }
        else if (symbol.equals(">")) {
            this.index = 2;
        }
        else if (symbol.equals("<")) {
            this.index = 3;
        }
        else if (symbol.equals("!=")) {
            this.index = 4;
        }
        else {
            this.index = -1;
        }
    }
    
    @Override
    public String toString() {
        return this.symbol;
    }
}
