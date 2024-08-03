package mon.premier.application;

// mon.premier.application;

import java.awt.*;
import java.awt.event.*;
import java.lang.reflect.Method;
import javax.swing.*;
import javax.swing.event.*;

class R�glage extends JPanel {
   /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
   private Glissi�re glissi�re;
   private JLabel valeur = new JLabel("0");
   private JCheckBox actif = new JCheckBox();
   
   public R�glage(String titre, Panneau image, String m�thode, int minimum, int maximum) throws NoSuchMethodException {
      glissi�re = new Glissi�re(valeur, actif, image, m�thode, minimum, maximum);
      this.setBorder(BorderFactory.createTitledBorder(titre));
      valeur.setBorder(BorderFactory.createEtchedBorder());
      valeur.setPreferredSize(new Dimension(30, 20));
      valeur.setHorizontalAlignment(SwingConstants.CENTER);
      actif.setSelected(true);
      this.add(actif);
      this.add(valeur);
      this.add(glissi�re);
   }
}

class Glissi�re extends JSlider implements ChangeListener, ActionListener {
   /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
   private JLabel valeur;
   private JCheckBox actif;
   private Panneau image;
   private Method m�thode;
   
   public Glissi�re(JLabel valeur, JCheckBox actif, Panneau image, String m�thode, int minimum, int maximum) 
         throws NoSuchMethodException {
	      super(JSlider.HORIZONTAL, minimum, maximum, 0);
	      this.valeur = valeur;
	      this.actif = actif;
	      this.image = image;
	      this.m�thode = image.getClass().getMethod(m�thode, int.class);
	      addChangeListener(this);
	      actif.addActionListener(this);
	      this.addMouseListener(new RelachementSouris(image));
	   }
	   public void stateChanged(ChangeEvent e) {
	      try {
	         m�thode.invoke(image, this.getValue());
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
	         m�thode.invoke(image, actif.isSelected() ? getValue() : 0);
	      } 
	      catch (Exception ex) {
	         ex.printStackTrace();
	      } 
	      image.r�glerHistogramme();
	   }
}

class RelachementSouris extends MouseAdapter {
   private Panneau zone;
   
   public RelachementSouris(Panneau zone) {
      this.zone = zone;
   }
   public void mouseReleased(MouseEvent e) {
      zone.r�glerHistogramme();
   }
}