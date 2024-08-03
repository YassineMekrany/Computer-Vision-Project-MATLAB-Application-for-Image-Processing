package com.pfe;

import java.awt.Dimension;

import javax.swing.Icon;
import javax.swing.JButton;

public class ButtonBarreOutils extends JButton{
	public ButtonBarreOutils (Icon icon,Icon rolloverIcon,String toolTipText){
		super(icon);
		setRolloverIcon(rolloverIcon);
		setPreferredSize(new Dimension(this.getIcon().getIconWidth(), this.getIcon().getIconHeight()));
		setMinimumSize(new Dimension(this.getIcon().getIconWidth(), this.getIcon().getIconHeight()));
		setBorderPainted(false);
		setToolTipText(toolTipText);
	}
}
