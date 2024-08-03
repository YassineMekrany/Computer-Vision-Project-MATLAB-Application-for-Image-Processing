package mon.premier.application;

// mon.premier.application;

import java.awt.*;
import java.awt.event.*;
import java.lang.reflect.Method;
import javax.swing.*;
import javax.swing.event.*;

class Réglage extends JPanel {
   /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
   private Glissière glissière;
   private JLabel valeur = new JLabel("0");
   private JCheckBox actif = new JCheckBox();
   
   public Réglage(String titre, Panneau image, String méthode, int minimum, int maximum) throws NoSuchMethodException {
      glissière = new Glissière(valeur, actif, image, méthode, minimum, maximum);
      this.setBorder(BorderFactory.createTitledBorder(titre));
      valeur.setBorder(BorderFactory.createEtchedBorder());
      valeur.setPreferredSize(new Dimension(30, 20));
      valeur.setHorizontalAlignment(SwingConstants.CENTER);
      actif.setSelected(true);
      this.add(actif);
      this.add(valeur);
      this.add(glissière);
   }
}

class Glissière extends JSlider implements ChangeListener, ActionListener {
   /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
   private JLabel valeur;
   private JCheckBox actif;
   private Panneau image;
   private Method méthode;
   
   public Glissière(JLabel valeur, JCheckBox actif, Panneau image, String méthode, int minimum, int maximum) 
         throws NoSuchMethodException {
	      super(JSlider.HORIZONTAL, minimum, maximum, 0);
	      this.valeur = valeur;
	      this.actif = actif;
	      this.image = image;
	      this.méthode = image.getClass().getMethod(méthode, int.class);
	      addChangeListener(this);
	      actif.addActionListener(this);
	      this.addMouseListener(new RelachementSouris(image));
	   }
	   public void stateChanged(ChangeEvent e) {
	      try {
	         méthode.invoke(image, this.getValue());
	         valeur.setText(""+this.getValue());
	      } 
	      catch (Exception ex) {
	         ex.printStackTrace();
	      }    
	   }
	   public void actionPerformed(ActionEvent e) {
	      this.setEnabled(actif.isSelected());
	      valeur.setText(""+(actif.isSelected() ? getValue() : 0));
	      try {
	         méthode.invoke(image, actif.isSelected() ? getValue() : 0);
	      } 
	      catch (Exception ex) {
	         ex.printStackTrace();
	      } 
	      image.réglerHistogramme();
	   }
}

class RelachementSouris extends MouseAdapter {
   private Panneau zone;
   
   public RelachementSouris(Panneau zone) {
      this.zone = zone;
   }
   public void mouseReleased(MouseEvent e) {
      zone.réglerHistogramme();
   }
}