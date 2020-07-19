// 
// Decompiled by Procyon v0.5.36
// 

package Rule;

import java.util.Enumeration;
import javax.swing.JTextArea;
import java.util.Stack;
import java.util.Vector;
import java.util.Hashtable;

public class BooleanRuleBase implements RuleBase
{
    String name;
    Hashtable variableList;
    Clause[] clauseVarList;
    Vector ruleList;
    Vector conclusionVarList;
    Rule rulePtr;
    Clause clausePtr;
    Stack goalClauseStack;
    Hashtable effectors;
    Hashtable sensors;
    Vector factList;
    JTextArea textArea1;
    public Vector matchList2;
    
    @Override
    public void setDisplay(final JTextArea txtArea) {
        this.textArea1 = txtArea;
    }
    
    public BooleanRuleBase(final String name) {
        this.variableList = new Hashtable();
        this.ruleList = new Vector();
        this.goalClauseStack = new Stack();
        this.matchList2 = new Vector();
        this.name = name;
    }
    
    @Override
    public void trace(final String text) {
        if (this.textArea1 != null) {
            this.textArea1.append(text);
        }
    }
    
    @Override
    public void displayVariables(final JTextArea textArea) {
        final Enumeration enum1 = this.variableList.elements();
        while (enum1.hasMoreElements()) {
            final RuleVariable temp = enum1.nextElement();
            textArea.append("\n" + temp.name + " value = " + temp.value);
        }
    }
    
    @Override
    public void displayRules(final JTextArea textArea) {
        textArea.append("\n" + this.name + " Rule Base: " + "\n");
        Enumeration enum1 = this.ruleList.elements();
        while (enum1.hasMoreElements()) {
            final Rule temp = enum1.nextElement();
            temp.display(textArea);
        }
        if (this.factList != null) {
            enum1 = this.factList.elements();
            while (enum1.hasMoreElements()) {
                final Fact temp2 = enum1.nextElement();
                temp2.display(textArea);
            }
        }
    }
    
    public void displayConflictSet(final Vector ruleSet) {
        this.trace("\n -- Rules in conflict set:\n");
        final Enumeration enum1 = ruleSet.elements();
        while (enum1.hasMoreElements()) {
            final Rule temp = enum1.nextElement();
            this.trace(temp.name + "(" + temp.numAntecedents() + "), ");
        }
    }
    
    @Override
    public void reset() {
        this.trace("\n --- Setting all " + this.name + " variables to null");
        Enumeration enum1 = this.variableList.elements();
        while (enum1.hasMoreElements()) {
            final RuleVariable temp = enum1.nextElement();
            temp.setValue(null);
        }
        if (this.factList != null) {
            enum1 = this.factList.elements();
            while (enum1.hasMoreElements()) {
                final Fact temp2 = enum1.nextElement();
                temp2.fired = false;
            }
        }
        final Enumeration enum2 = this.ruleList.elements();
        while (enum2.hasMoreElements()) {
            final Rule temp3 = enum2.nextElement();
            temp3.reset();
        }
    }
    
    @Override
    public void backwardChain(final String goalVarName) {
        final RuleVariable goalVar = this.variableList.get(goalVarName);
        final Enumeration goalClauses = goalVar.clauseRefs.elements();
        while (goalClauses.hasMoreElements()) {
            final Clause goalClause = goalClauses.nextElement();
            if (!goalClause.consequent) {
                continue;
            }
            this.goalClauseStack.push(goalClause);
            final Rule goalRule = goalClause.getRule();
            final Boolean ruleTruth = goalRule.backChain();
            if (ruleTruth == null) {
                this.trace("\nRule " + goalRule.name + " is null, can't determine truth value.");
            }
            else if (ruleTruth) {
                goalVar.setValue(goalClause.rhs);
                goalVar.setRuleName(goalRule.name);
                this.goalClauseStack.pop();
                this.trace("\nRule " + goalRule.name + " is true, setting " + goalVar.name + ": = " + goalVar.value);
                if (this.goalClauseStack.empty()) {
                    this.trace("\n +++ Found Solution for goal: " + goalVar.name);
                    break;
                }
                continue;
            }
            else {
                this.goalClauseStack.pop();
                this.trace("\nRule " + goalRule.name + " is false, can't set " + goalVar.name);
            }
        }
        if (goalVar.value == null) {
            this.trace("\n +++ Could Not Find Solution for goal: " + goalVar.name);
        }
    }
    
    public Vector match(final boolean test) {
        final Vector matchList = new Vector();
        final Enumeration enum1 = this.ruleList.elements();
        while (enum1.hasMoreElements()) {
            final Rule testRule = enum1.nextElement();
            if (test) {
                testRule.check();
            }
            if (testRule.truth == null) {
                continue;
            }
            if (!testRule.truth || testRule.fired) {
                continue;
            }
            matchList.addElement(testRule);
        }
        this.displayConflictSet(matchList);
        return matchList;
    }
    
    public Rule selectRule(final Vector ruleSet) {
        final Enumeration enum1 = ruleSet.elements();
        Rule bestRule = enum1.nextElement();
        long max = bestRule.numAntecedents();
        while (enum1.hasMoreElements()) {
            final Rule nextRule = enum1.nextElement();
            final long numClauses;
            if ((numClauses = nextRule.numAntecedents()) > max) {
                max = numClauses;
                bestRule = nextRule;
            }
        }
        return bestRule;
    }
    
    @Override
    public void forwardChain() {
        Vector conflictRuleSet = new Vector();
        conflictRuleSet = this.match(true);
        this.matchList2 = conflictRuleSet;
        while (conflictRuleSet.size() > 0) {
            final Rule selected = this.selectRule(conflictRuleSet);
            selected.fire();
            conflictRuleSet = this.match(false);
        }
    }
    
    public void addEffector(final Object obj, final String effectorName) {
        if (this.effectors == null) {
            this.effectors = new Hashtable();
        }
        this.effectors.put(effectorName, obj);
    }
    
    public Object getEffectorObject(final String effectorName) {
        return this.effectors.get(effectorName);
    }
    
    public void addSensor(final Object obj, final String sensorName) {
        if (this.sensors == null) {
            this.sensors = new Hashtable();
        }
        this.sensors.put(sensorName, obj);
    }
    
    public Object getSensorObject(final String sensorName) {
        return this.sensors.get(sensorName);
    }
    
    public void initializeFacts() {
        if (this.factList != null) {
            final Enumeration enum1 = this.factList.elements();
            while (enum1.hasMoreElements()) {
                final Fact fact = enum1.nextElement();
                fact.assertion(this);
            }
        }
    }
    
    public void addFact(final Fact fact) {
        if (this.factList == null) {
            this.factList = new Vector();
        }
        this.factList.addElement(fact);
    }
    
    public void addVariable(final RuleVariable variable) {
        this.variableList.put(variable.getName(), variable);
    }
    
    public Hashtable getVariables() {
        return (Hashtable)this.variableList.clone();
    }
    
    @Override
    public Vector getGoalVariables() {
        final Vector goalVars = new Vector();
        final Enumeration enum1 = this.variableList.elements();
        while (enum1.hasMoreElements()) {
            final RuleVariable ruleVar = enum1.nextElement();
            final Vector goalClauses = ruleVar.clauseRefs;
            if (goalClauses != null && goalClauses.size() != 0) {
                goalVars.addElement(ruleVar);
            }
        }
        return goalVars;
    }
    
    public RuleVariable getVariable(final String name) {
        if (this.variableList.containsKey(name)) {
            return this.variableList.get(name);
        }
        return null;
    }
    
    public void setVariableValue(final String name, final String value) {
        final RuleVariable variable = this.getVariable(name);
        if (variable != null) {
            variable.setValue(value);
        }
        else {
            System.out.println("BooleanRuleBase: Can't set value, variable " + name + " is not defined!");
        }
    }
}
