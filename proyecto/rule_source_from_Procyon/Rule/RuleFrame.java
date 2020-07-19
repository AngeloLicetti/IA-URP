// 
// Decompiled by Procyon v0.5.36
// 

package Rule;

import java.util.Vector;
import java.awt.Point;
import java.awt.Frame;
import java.awt.event.WindowEvent;
import java.awt.Component;
import javax.swing.AbstractButton;
import java.awt.Rectangle;
import java.awt.event.ActionListener;
import java.awt.Dimension;
import java.awt.LayoutManager;
import java.awt.event.ActionEvent;
import javax.swing.JComboBox;
import javax.swing.JRadioButtonMenuItem;
import java.awt.FlowLayout;
import javax.swing.JTextField;
import javax.swing.JLabel;
import javax.swing.ButtonGroup;
import javax.swing.JRadioButton;
import javax.swing.JTextArea;
import javax.swing.JScrollPane;
import javax.swing.JPanel;
import javax.swing.JMenuItem;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import java.awt.BorderLayout;
import javax.swing.JFrame;

public class RuleFrame extends JFrame
{
    BorderLayout borderLayout1;
    JMenuBar jMenuBar1;
    JMenu FileMenu;
    JMenuItem StartMenuItem;
    JMenuItem ResetMenuItem;
    JMenuItem ExitMenuItem;
    JMenu DataMenu;
    JMenuItem DefaultsMenuItem;
    JMenuItem SetValuesMenuItem;
    JPanel jPanel1;
    JPanel jPanel2;
    JPanel jPanel3;
    JScrollPane jScrollPane1;
    JTextArea traceTextArea;
    JRadioButton forwardChainRadioButton;
    JRadioButton backChainRadioButton;
    ButtonGroup buttonGroup;
    JLabel jLabel1;
    JLabel jLabel2;
    JTextField resultTextField;
    FlowLayout flowLayout1;
    BorderLayout borderLayout2;
    JMenu HelpMenu;
    JMenuItem AboutMenuItem;
    JMenu RuleBaseMenu;
    JRadioButtonMenuItem VehiclesRadioButtonMenuItem;
    JRadioButtonMenuItem BugsRadioButtonMenuItem;
    JRadioButtonMenuItem PlantsRadioButtonMenuItem;
    ButtonGroup ruleBaseButtonGroup;
    JComboBox GoalComboBox;
    static BooleanRuleBase bugs;
    static BooleanRuleBase plants;
    static BooleanRuleBase vehicles;
    static RuleBase currentRuleBase;
    
    public RuleFrame() {
        this.borderLayout1 = new BorderLayout();
        this.jMenuBar1 = new JMenuBar();
        this.FileMenu = new JMenu();
        this.StartMenuItem = new JMenuItem();
        this.ResetMenuItem = new JMenuItem();
        this.ExitMenuItem = new JMenuItem();
        this.DataMenu = new JMenu();
        this.DefaultsMenuItem = new JMenuItem();
        this.SetValuesMenuItem = new JMenuItem();
        this.jPanel1 = new JPanel();
        this.jPanel2 = new JPanel();
        this.jPanel3 = new JPanel();
        this.jScrollPane1 = new JScrollPane();
        this.traceTextArea = new JTextArea();
        this.forwardChainRadioButton = new JRadioButton();
        this.backChainRadioButton = new JRadioButton();
        this.buttonGroup = new ButtonGroup();
        this.jLabel1 = new JLabel();
        this.jLabel2 = new JLabel();
        this.resultTextField = new JTextField();
        this.flowLayout1 = new FlowLayout();
        this.borderLayout2 = new BorderLayout();
        this.HelpMenu = new JMenu();
        this.AboutMenuItem = new JMenuItem();
        this.RuleBaseMenu = new JMenu();
        this.VehiclesRadioButtonMenuItem = new JRadioButtonMenuItem();
        this.BugsRadioButtonMenuItem = new JRadioButtonMenuItem();
        this.PlantsRadioButtonMenuItem = new JRadioButtonMenuItem();
        this.ruleBaseButtonGroup = new ButtonGroup();
        this.GoalComboBox = new JComboBox();
        this.enableEvents(64L);
        try {
            (RuleFrame.vehicles = new BooleanRuleBase("Vehicles Rule Base")).setDisplay(this.traceTextArea);
            this.initVehiclesRuleBase(RuleFrame.vehicles);
            RuleFrame.currentRuleBase = RuleFrame.vehicles;
            (RuleFrame.bugs = new BooleanRuleBase("Bugs Rule Base")).setDisplay(this.traceTextArea);
            this.initBugsRuleBase(RuleFrame.bugs);
            (RuleFrame.plants = new BooleanRuleBase("Plants Rule Base")).setDisplay(this.traceTextArea);
            this.initPlantsRuleBase(RuleFrame.plants);
            this.jbInit();
            this.VehiclesRadioButtonMenuItem_actionPerformed(null);
            RuleFrame.currentRuleBase.displayRules(this.traceTextArea);
            RuleFrame.currentRuleBase.displayVariables(this.traceTextArea);
            this.forwardChainRadioButton.setSelected(true);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void jbInit() throws Exception {
        this.getContentPane().setLayout(this.borderLayout1);
        this.setSize(new Dimension(507, 522));
        this.setTitle("Rule Application");
        this.FileMenu.setText("File");
        this.StartMenuItem.setText("Start");
        this.StartMenuItem.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(final ActionEvent e) {
                RuleFrame.this.StartMenuItem_actionPerformed(e);
            }
        });
        this.ResetMenuItem.setText("Reset");
        this.ResetMenuItem.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(final ActionEvent e) {
                RuleFrame.this.ResetMenuItem_actionPerformed(e);
            }
        });
        this.ExitMenuItem.setText("Exit");
        this.ExitMenuItem.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(final ActionEvent e) {
                RuleFrame.this.ExitMenuItem_actionPerformed(e);
            }
        });
        this.DataMenu.setText("Data");
        this.DefaultsMenuItem.setText("Use default values");
        this.DefaultsMenuItem.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(final ActionEvent e) {
                RuleFrame.this.DefaultsMenuItem_actionPerformed(e);
            }
        });
        this.SetValuesMenuItem.setText("Set values...");
        this.SetValuesMenuItem.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(final ActionEvent e) {
                RuleFrame.this.SetValuesMenuItem_actionPerformed(e);
            }
        });
        this.jPanel1.setPreferredSize(new Dimension(400, 100));
        this.jPanel1.setLayout(null);
        this.forwardChainRadioButton.setText("Forward chain");
        this.forwardChainRadioButton.setBounds(new Rectangle(19, 19, 103, 25));
        this.backChainRadioButton.setText("Backward chain");
        this.backChainRadioButton.setBounds(new Rectangle(17, 48, 154, 25));
        this.jPanel2.setLayout(this.borderLayout2);
        this.HelpMenu.setText("Help");
        this.AboutMenuItem.setText("About");
        this.AboutMenuItem.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(final ActionEvent e) {
                RuleFrame.this.AboutMenuItem_actionPerformed(e);
            }
        });
        this.RuleBaseMenu.setText("RuleBase");
        this.VehiclesRadioButtonMenuItem.setText("Vehicles");
        this.VehiclesRadioButtonMenuItem.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(final ActionEvent e) {
                RuleFrame.this.VehiclesRadioButtonMenuItem_actionPerformed(e);
            }
        });
        this.VehiclesRadioButtonMenuItem.setSelected(true);
        this.BugsRadioButtonMenuItem.setText("Bugs");
        this.BugsRadioButtonMenuItem.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(final ActionEvent e) {
                RuleFrame.this.BugsRadioButtonMenuItem_actionPerformed(e);
            }
        });
        this.PlantsRadioButtonMenuItem.setText("Plants");
        this.PlantsRadioButtonMenuItem.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(final ActionEvent e) {
                RuleFrame.this.PlantsRadioButtonMenuItem_actionPerformed(e);
            }
        });
        this.ruleBaseButtonGroup.add(this.VehiclesRadioButtonMenuItem);
        this.ruleBaseButtonGroup.add(this.BugsRadioButtonMenuItem);
        this.ruleBaseButtonGroup.add(this.PlantsRadioButtonMenuItem);
        this.GoalComboBox.setBounds(new Rectangle(170, 51, 126, 23));
        this.buttonGroup.add(this.forwardChainRadioButton);
        this.buttonGroup.add(this.backChainRadioButton);
        this.jLabel1.setText("Goal");
        this.jLabel1.setBounds(new Rectangle(171, 28, 106, 17));
        this.jLabel2.setText("Result");
        this.jLabel2.setBounds(new Rectangle(313, 29, 103, 17));
        this.resultTextField.setBounds(new Rectangle(312, 51, 176, 21));
        this.jPanel3.setLayout(this.flowLayout1);
        this.flowLayout1.setHgap(20);
        this.jMenuBar1.add(this.FileMenu);
        this.jMenuBar1.add(this.RuleBaseMenu);
        this.jMenuBar1.add(this.DataMenu);
        this.jMenuBar1.add(this.HelpMenu);
        this.FileMenu.add(this.StartMenuItem);
        this.FileMenu.addSeparator();
        this.FileMenu.add(this.ResetMenuItem);
        this.FileMenu.addSeparator();
        this.FileMenu.add(this.ExitMenuItem);
        this.DataMenu.add(this.DefaultsMenuItem);
        this.DataMenu.add(this.SetValuesMenuItem);
        this.getContentPane().add(this.jPanel1, "North");
        this.jPanel1.add(this.forwardChainRadioButton, null);
        this.jPanel1.add(this.backChainRadioButton, null);
        this.jPanel1.add(this.resultTextField, null);
        this.jPanel1.add(this.GoalComboBox, null);
        this.jPanel1.add(this.jLabel1, null);
        this.jPanel1.add(this.jLabel2, null);
        this.getContentPane().add(this.jPanel2, "Center");
        this.jPanel2.add(this.jScrollPane1, "Center");
        this.jScrollPane1.getViewport().add(this.traceTextArea, null);
        this.getContentPane().add(this.jPanel3, "South");
        this.HelpMenu.add(this.AboutMenuItem);
        this.RuleBaseMenu.add(this.VehiclesRadioButtonMenuItem);
        this.RuleBaseMenu.add(this.BugsRadioButtonMenuItem);
        this.RuleBaseMenu.add(this.PlantsRadioButtonMenuItem);
        this.setJMenuBar(this.jMenuBar1);
    }
    
    @Override
    protected void processWindowEvent(final WindowEvent e) {
        super.processWindowEvent(e);
        if (e.getID() == 201) {
            System.exit(0);
        }
        if (e.getID() == 205) {
            e.getWindow().repaint();
        }
    }
    
    public void initBugsRuleBase(final BooleanRuleBase rb) {
        final RuleVariable bugClass = new RuleVariable(rb, "bugClass");
        bugClass.setLabels("arachnid insect");
        bugClass.setPromptText("What is the bug class?");
        final RuleVariable insectType = new RuleVariable(rb, "insectType");
        insectType.setLabels("beetle orthoptera");
        insectType.setPromptText("What is the insect type?");
        final RuleVariable species = new RuleVariable(rb, "species");
        species.setLabels("Spider Tick Ladybug Japanese_Beetle Cricket Praying_Mantis");
        species.setPromptText("What is the species?");
        final RuleVariable color = new RuleVariable(rb, "color");
        color.setLabels("orange_and_black green_and_black black");
        color.setPromptText("What color is the bug?");
        final RuleVariable size = new RuleVariable(rb, "size");
        size.setLabels("small large");
        size.setPromptText("What size is the bug?");
        final RuleVariable leg_length = new RuleVariable(rb, "leg_length");
        leg_length.setLabels("short long");
        leg_length.setPromptText("What is the leg length?");
        final RuleVariable antennae = new RuleVariable(rb, "antennae");
        antennae.setLabels("0 2");
        antennae.setPromptText("How many antennae does it have?");
        final RuleVariable shape = new RuleVariable(rb, "shape");
        shape.setLabels("round elongated");
        shape.setPromptText("What shape is the bug's body?");
        final RuleVariable legs = new RuleVariable(rb, "legs");
        legs.setLabels("6 8");
        legs.setPromptText("How many legs does it have?");
        final RuleVariable wings = new RuleVariable(rb, "wings");
        wings.setLabels("0 2");
        wings.setPromptText("How many wings does it have?");
        final Condition cEquals = new Condition("=");
        final Condition cNotEquals = new Condition("!=");
        final Rule Spider = new Rule(rb, "spider", new Clause[] { new Clause(bugClass, cEquals, "arachnid"), new Clause(leg_length, cEquals, "long") }, new Clause(species, cEquals, "Spider"));
        final Rule Tick = new Rule(rb, "tick", new Clause[] { new Clause(bugClass, cEquals, "arachnid"), new Clause(leg_length, cEquals, "short") }, new Clause(species, cEquals, "Tick"));
        final Rule Ladybug = new Rule(rb, "ladybug", new Clause[] { new Clause(insectType, cEquals, "beetle"), new Clause(color, cEquals, "orange_and_black") }, new Clause(species, cEquals, "Ladybug"));
        final Rule JapaneseBeetle = new Rule(rb, "Japanese_Beetle", new Clause[] { new Clause(insectType, cEquals, "beetle"), new Clause(color, cEquals, "green_and_black") }, new Clause(species, cEquals, "Japanese_Beetle"));
        final Rule Cricket = new Rule(rb, "cricket", new Clause[] { new Clause(insectType, cEquals, "orthoptera"), new Clause(color, cEquals, "black") }, new Clause(species, cEquals, "Cricket"));
        final Rule PrayingMantis = new Rule(rb, "praying_mantis", new Clause[] { new Clause(insectType, cEquals, "orthoptera"), new Clause(color, cEquals, "green"), new Clause(size, cEquals, "large") }, new Clause(species, cEquals, "Praying_Mantis"));
        final Rule ClassArachnid1 = new Rule(rb, "class_is_Arachnid1", new Clause[] { new Clause(antennae, cEquals, "0"), new Clause(legs, cEquals, "8") }, new Clause(bugClass, cEquals, "arachnid"));
        final Rule ClassArachnid2 = new Rule(rb, "class_is_Arachnid2", new Clause(wings, cEquals, "0"), new Clause(bugClass, cEquals, "arachnid"));
        final Rule ClassInsect1 = new Rule(rb, "class_is_Insect1", new Clause[] { new Clause(antennae, cEquals, "2"), new Clause(legs, cEquals, "6") }, new Clause(bugClass, cEquals, "insect"));
        final Rule ClassInsect2 = new Rule(rb, "class_is_Insect2", new Clause(wings, cEquals, "2"), new Clause(bugClass, cEquals, "insect"));
        final Rule TypeBeetle = new Rule(rb, "typeBeetle", new Clause[] { new Clause(bugClass, cEquals, "insect"), new Clause(size, cEquals, "small"), new Clause(shape, cEquals, "round") }, new Clause(insectType, cEquals, "beetle"));
        final Rule TypeOrthoptera = new Rule(rb, "typeOrthoptera", new Clause[] { new Clause(bugClass, cEquals, "insect"), new Clause(size, cNotEquals, "small"), new Clause(shape, cEquals, "elongated") }, new Clause(insectType, cEquals, "orthoptera"));
    }
    
    public void initPlantsRuleBase(final BooleanRuleBase rb) {
        final RuleVariable family = new RuleVariable(rb, "family");
        family.setLabels("cypress pine bald_cypress ");
        family.setPromptText("What family is it?");
        final RuleVariable treeClass = new RuleVariable(rb, "treeClass");
        treeClass.setLabels("angiosperm gymnosperm");
        treeClass.setPromptText("What tree class is it?");
        final RuleVariable plantType = new RuleVariable(rb, "plantType");
        plantType.setLabels("herb vine tree shrub");
        plantType.setPromptText("What type of plant is it?");
        final RuleVariable stem = new RuleVariable(rb, "stem");
        stem.setLabels("woody green");
        stem.setPromptText("What type of stem does it have?");
        final RuleVariable stemPosition = new RuleVariable(rb, "stemPosition");
        stemPosition.setLabels("upright creeping");
        stemPosition.setPromptText("What is the stem position?");
        final RuleVariable one_main_trunk = new RuleVariable(rb, "one_main_trunk");
        one_main_trunk.setLabels("yes no");
        one_main_trunk.setPromptText("Does it have one main trunk?");
        final RuleVariable broad_and_flat_leaves = new RuleVariable(rb, "broad_and_flat_leaves");
        broad_and_flat_leaves.setLabels("yes no");
        broad_and_flat_leaves.setPromptText("Are the leaves broad and flat?");
        final RuleVariable leaf_shape = new RuleVariable(rb, "leaf_shape");
        leaf_shape.setLabels("needlelike scalelike");
        leaf_shape.setPromptText("What shape are the leaves?");
        final RuleVariable needle_pattern = new RuleVariable(rb, "needle_pattern");
        needle_pattern.setLabels("random even");
        needle_pattern.setPromptText("What is the needle pattern?");
        final RuleVariable silver_bands = new RuleVariable(rb, "silver_bands");
        silver_bands.setLabels("yes no");
        silver_bands.setPromptText("Does it have silver bands?");
        final Condition cEquals = new Condition("=");
        final Condition cNotEquals = new Condition("!=");
        final Rule Cypress = new Rule(rb, "cypress", new Clause[] { new Clause(treeClass, cEquals, "gymnosperm"), new Clause(leaf_shape, cEquals, "scalelike") }, new Clause(family, cEquals, "cypress"));
        final Rule Pine1 = new Rule(rb, "pine1", new Clause[] { new Clause(treeClass, cEquals, "gymnosperm"), new Clause(leaf_shape, cEquals, "needlelike"), new Clause(needle_pattern, cEquals, "random") }, new Clause(family, cEquals, "pine"));
        final Rule Pine2 = new Rule(rb, "pine2", new Clause[] { new Clause(treeClass, cEquals, "gymnosperm"), new Clause(leaf_shape, cEquals, "needlelike"), new Clause(needle_pattern, cEquals, "even"), new Clause(silver_bands, cEquals, "yes") }, new Clause(family, cEquals, "pine"));
        final Rule BaldCypress = new Rule(rb, "baldCypress", new Clause[] { new Clause(treeClass, cEquals, "gymnosperm"), new Clause(leaf_shape, cEquals, "needlelike"), new Clause(needle_pattern, cEquals, "even"), new Clause(silver_bands, cEquals, "no") }, new Clause(family, cEquals, "bald_cypress"));
        final Rule Angiosperm = new Rule(rb, "angiosperm", new Clause[] { new Clause(plantType, cEquals, "tree"), new Clause(broad_and_flat_leaves, cEquals, "yes") }, new Clause(treeClass, cEquals, "angiosperm"));
        final Rule Gymnosperm = new Rule(rb, "gymnosperm", new Clause[] { new Clause(plantType, cEquals, "tree"), new Clause(broad_and_flat_leaves, cEquals, "no") }, new Clause(treeClass, cEquals, "gymnosperm"));
        final Rule Herb = new Rule(rb, "herb", new Clause(stem, cEquals, "green"), new Clause(plantType, cEquals, "herb"));
        final Rule Vine = new Rule(rb, "vine", new Clause[] { new Clause(stem, cEquals, "woody"), new Clause(stemPosition, cEquals, "creeping") }, new Clause(plantType, cEquals, "vine"));
        final Rule Tree = new Rule(rb, "tree", new Clause[] { new Clause(stem, cEquals, "woody"), new Clause(stemPosition, cEquals, "upright"), new Clause(one_main_trunk, cEquals, "yes") }, new Clause(plantType, cEquals, "tree"));
        final Rule Shrub = new Rule(rb, "shrub", new Clause[] { new Clause(stem, cEquals, "woody"), new Clause(stemPosition, cEquals, "upright"), new Clause(one_main_trunk, cEquals, "no") }, new Clause(plantType, cEquals, "shrub"));
    }
    
    public void initVehiclesRuleBase(final BooleanRuleBase rb) {
        final RuleVariable vehicle = new RuleVariable(rb, "vehicle");
        vehicle.setLabels("Bicycle Tricycle MotorCycle Sports_Car Sedan MiniVan Sports_Utility_Vehicle");
        vehicle.setPromptText("What kind of vehicle is it?");
        final RuleVariable vehicleType = new RuleVariable(rb, "vehicleType");
        vehicleType.setLabels("cycle automobile");
        vehicleType.setPromptText("What type of vehicle is it?");
        final RuleVariable size = new RuleVariable(rb, "size");
        size.setLabels("small medium large");
        size.setPromptText("What size is the vehicle?");
        final RuleVariable motor = new RuleVariable(rb, "motor");
        motor.setLabels("yes no");
        motor.setPromptText("Does the vehicle have a motor?");
        final RuleVariable num_wheels = new RuleVariable(rb, "num_wheels");
        num_wheels.setLabels("2 3 4");
        num_wheels.setPromptText("How many wheels does it have?");
        final RuleVariable num_doors = new RuleVariable(rb, "num_doors");
        num_doors.setLabels("2 3 4");
        num_doors.setPromptText("How many doors does it have?");
        final Condition cEquals = new Condition("=");
        final Condition cNotEquals = new Condition("!=");
        final Condition cLessThan = new Condition("<");
        final Rule Bicycle = new Rule(rb, "bicycle", new Clause[] { new Clause(vehicleType, cEquals, "cycle"), new Clause(num_wheels, cEquals, "2"), new Clause(motor, cEquals, "no") }, new Clause(vehicle, cEquals, "Bicycle"));
        final Rule Tricycle = new Rule(rb, "tricycle", new Clause[] { new Clause(vehicleType, cEquals, "cycle"), new Clause(num_wheels, cEquals, "3"), new Clause(motor, cEquals, "no") }, new Clause(vehicle, cEquals, "Tricycle"));
        final Rule Motorcycle = new Rule(rb, "motorcycle", new Clause[] { new Clause(vehicleType, cEquals, "cycle"), new Clause(num_wheels, cEquals, "2"), new Clause(motor, cEquals, "yes") }, new Clause(vehicle, cEquals, "Motorcycle"));
        final Rule SportsCar = new Rule(rb, "sportsCar", new Clause[] { new Clause(vehicleType, cEquals, "automobile"), new Clause(size, cEquals, "small"), new Clause(num_doors, cEquals, "2") }, new Clause(vehicle, cEquals, "Sports_Car"));
        final Rule Sedan = new Rule(rb, "sedan", new Clause[] { new Clause(vehicleType, cEquals, "automobile"), new Clause(size, cEquals, "medium"), new Clause(num_doors, cEquals, "4") }, new Clause(vehicle, cEquals, "Sedan"));
        final Rule MiniVan = new Rule(rb, "miniVan", new Clause[] { new Clause(vehicleType, cEquals, "automobile"), new Clause(size, cEquals, "medium"), new Clause(num_doors, cEquals, "3") }, new Clause(vehicle, cEquals, "MiniVan"));
        final Rule SUV = new Rule(rb, "SUV", new Clause[] { new Clause(vehicleType, cEquals, "automobile"), new Clause(size, cEquals, "large"), new Clause(num_doors, cEquals, "4") }, new Clause(vehicle, cEquals, "Sports_Utility_Vehicle"));
        final Rule Cycle = new Rule(rb, "Cycle", new Clause(num_wheels, cLessThan, "4"), new Clause(vehicleType, cEquals, "cycle"));
        final Rule Automobile = new Rule(rb, "Automobile", new Clause[] { new Clause(num_wheels, cEquals, "4"), new Clause(motor, cEquals, "yes") }, new Clause(vehicleType, cEquals, "automobile"));
    }
    
    public void demoVehiclesFC(final BooleanRuleBase rb) {
        this.traceTextArea.append("\n --- Setting Values for Vehicles ForwardChain Demo ---\n ");
        rb.setVariableValue("vehicle", null);
        rb.setVariableValue("vehicleType", null);
        rb.setVariableValue("size", "medium");
        rb.setVariableValue("num_wheels", "4");
        rb.setVariableValue("num_doors", "3");
        rb.setVariableValue("motor", "yes");
        rb.displayVariables(this.traceTextArea);
    }
    
    public void demoVehiclesBC(final BooleanRuleBase rb) {
        this.traceTextArea.append("\n --- Setting Values for Vehicles BackwardChain Demo ---\n ");
        rb.setVariableValue("vehicle", null);
        rb.setVariableValue("vehicleType", null);
        rb.setVariableValue("size", "medium");
        rb.setVariableValue("num_wheels", "4");
        rb.setVariableValue("num_doors", "3");
        rb.setVariableValue("motor", "yes");
        rb.displayVariables(this.traceTextArea);
    }
    
    public void demoBugsBC(final BooleanRuleBase rb) {
        this.traceTextArea.append("\n --- Setting Values for Bugs BackwardChain Demo ---");
        rb.setVariableValue("wings", "2");
        rb.setVariableValue("legs", "6");
        rb.setVariableValue("shape", "round");
        rb.setVariableValue("antennae", "2");
        rb.setVariableValue("color", "orange_and_black");
        rb.setVariableValue("leg_length", "long");
        rb.setVariableValue("size", "small");
        rb.displayVariables(this.traceTextArea);
    }
    
    public void demoBugsFC(final BooleanRuleBase rb) {
        this.traceTextArea.append("\n --- Setting Values for Bugs ForwardChain Demo ---\n");
        rb.setVariableValue("bugClass", null);
        rb.setVariableValue("insectType", null);
        rb.setVariableValue("wings", "2");
        rb.setVariableValue("legs", "6");
        rb.setVariableValue("shape", "round");
        rb.setVariableValue("antennae", "2");
        rb.setVariableValue("color", "orange_and_black");
        rb.setVariableValue("leg_length", "long");
        rb.setVariableValue("size", "small");
        rb.displayVariables(this.traceTextArea);
    }
    
    public void demoPlantsBC(final BooleanRuleBase rb) {
        this.traceTextArea.append("\n --- Setting Values for Plants BackwardChain Demo ---\n ");
        rb.setVariableValue("stem", "woody");
        rb.setVariableValue("stemPosition", "upright");
        rb.setVariableValue("one_main_trunk", "yes");
        rb.setVariableValue("broad_and_flat_leaves", "no");
        rb.setVariableValue("leaf_shape", "needlelike");
        rb.setVariableValue("needle_pattern", "random");
        rb.displayVariables(this.traceTextArea);
    }
    
    public void demoPlantsFC(final BooleanRuleBase rb) {
        this.traceTextArea.append("\n --- Setting Values for Plants ForwardChain Demo --- \n ");
        rb.setVariableValue("stem", "woody");
        rb.setVariableValue("stemPosition", "upright");
        rb.setVariableValue("one_main_trunk", "yes");
        rb.setVariableValue("broad_and_flat_leaves", "no");
        rb.setVariableValue("leaf_shape", "needlelike");
        rb.setVariableValue("needle_pattern", "random");
        rb.displayVariables(this.traceTextArea);
    }
    
    void StartMenuItem_actionPerformed(final ActionEvent e) {
        String goal = null;
        final RuleVariable goalVar = (RuleVariable)this.GoalComboBox.getSelectedItem();
        this.traceTextArea.append("\n --- Starting Inferencing Cycle --- \n");
        RuleFrame.currentRuleBase.displayVariables(this.traceTextArea);
        if (this.forwardChainRadioButton.isSelected()) {
            RuleFrame.currentRuleBase.forwardChain();
        }
        if (this.backChainRadioButton.isSelected()) {
            if (RuleFrame.currentRuleBase instanceof BooleanRuleBase) {
                if (goalVar == null) {
                    this.traceTextArea.append("Goal variable is not defined!");
                }
                else {
                    goal = goalVar.getName();
                }
            }
            RuleFrame.currentRuleBase.backwardChain(goal);
        }
        RuleFrame.currentRuleBase.displayVariables(this.traceTextArea);
        this.traceTextArea.append("\n --- Ending Inferencing Cycle --- \n");
        if (goalVar != null) {
            Object result = goalVar.getValue();
            if (result == null) {
                result = "null";
            }
            this.resultTextField.setText((String)result);
        }
    }
    
    void ResetMenuItem_actionPerformed(final ActionEvent e) {
        this.traceTextArea.setText("");
        RuleFrame.currentRuleBase.reset();
    }
    
    void ExitMenuItem_actionPerformed(final ActionEvent e) {
        System.exit(0);
    }
    
    void SetValuesMenuItem_actionPerformed(final ActionEvent e) {
        if (RuleFrame.currentRuleBase instanceof BooleanRuleBase) {
            final BooleanRuleBaseVariablesDialog dlg = new BooleanRuleBaseVariablesDialog(this, "Set Boolean Rule Base Variables", true);
            dlg.setRuleBase((BooleanRuleBase)RuleFrame.currentRuleBase);
            final Point loc = this.getLocation();
            dlg.setLocation(loc.x + 20, loc.y + 20);
            dlg.show();
        }
    }
    
    void DefaultsMenuItem_actionPerformed(final ActionEvent e) {
        if (this.forwardChainRadioButton.isSelected()) {
            if (RuleFrame.currentRuleBase == RuleFrame.vehicles) {
                this.demoVehiclesFC((BooleanRuleBase)RuleFrame.currentRuleBase);
            }
            if (RuleFrame.currentRuleBase == RuleFrame.plants) {
                this.demoPlantsFC((BooleanRuleBase)RuleFrame.currentRuleBase);
            }
            if (RuleFrame.currentRuleBase == RuleFrame.bugs) {
                this.demoBugsFC((BooleanRuleBase)RuleFrame.currentRuleBase);
            }
        }
        else {
            if (RuleFrame.currentRuleBase == RuleFrame.vehicles) {
                this.demoVehiclesBC((BooleanRuleBase)RuleFrame.currentRuleBase);
            }
            if (RuleFrame.currentRuleBase == RuleFrame.plants) {
                this.demoPlantsBC((BooleanRuleBase)RuleFrame.currentRuleBase);
            }
            if (RuleFrame.currentRuleBase == RuleFrame.bugs) {
                this.demoBugsBC((BooleanRuleBase)RuleFrame.currentRuleBase);
            }
        }
    }
    
    void switchRuleBase() {
        this.traceTextArea.setText("");
        this.resultTextField.setText("");
        RuleFrame.currentRuleBase.reset();
        RuleFrame.currentRuleBase.displayRules(this.traceTextArea);
        RuleFrame.currentRuleBase.displayVariables(this.traceTextArea);
        if (this.GoalComboBox.getItemCount() > 0) {
            this.GoalComboBox.removeAllItems();
        }
        final Vector goalVars = RuleFrame.currentRuleBase.getGoalVariables();
        for (int i = 0; i < goalVars.size(); ++i) {
            this.GoalComboBox.addItem(goalVars.elementAt(i));
        }
    }
    
    void AboutMenuItem_actionPerformed(final ActionEvent e) {
        final AboutDialog dlg = new AboutDialog(this, "About Rule Application", true);
        final Point loc = this.getLocation();
        dlg.setLocation(loc.x + 50, loc.y + 50);
        dlg.show();
    }
    
    void VehiclesRadioButtonMenuItem_actionPerformed(final ActionEvent e) {
        RuleFrame.currentRuleBase = RuleFrame.vehicles;
        this.setTitle("Rule Application - Vehicles Rule Base");
        this.switchRuleBase();
        this.GoalComboBox.setSelectedItem(((BooleanRuleBase)RuleFrame.currentRuleBase).getVariable("vehicle"));
    }
    
    void BugsRadioButtonMenuItem_actionPerformed(final ActionEvent e) {
        RuleFrame.currentRuleBase = RuleFrame.bugs;
        this.setTitle("Rule Application - Bugs Rule Base");
        this.switchRuleBase();
        this.GoalComboBox.setSelectedItem(((BooleanRuleBase)RuleFrame.currentRuleBase).getVariable("species"));
    }
    
    void PlantsRadioButtonMenuItem_actionPerformed(final ActionEvent e) {
        RuleFrame.currentRuleBase = RuleFrame.plants;
        this.setTitle("Rule Application - Plants Rule Base");
        this.switchRuleBase();
        this.GoalComboBox.setSelectedItem(((BooleanRuleBase)RuleFrame.currentRuleBase).getVariable("family"));
    }
}
