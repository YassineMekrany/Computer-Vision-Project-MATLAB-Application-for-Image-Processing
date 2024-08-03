package mon.premier.application;

// mon.premier.application;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.geom.*;
import javax.swing.*;
import java.awt.*;

public class Palette extends JPanel {
   /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String titre;
   protected Panneau zone;
   
   public Palette(String titre, int hauteur, Panneau zone) {
      this.titre = titre;
      this.zone = zone;
      this.setPreferredSize(new Dimension(256, hauteur));
      this.setBorder(BorderFactory.createRaisedBevelBorder());      
      this.add(new JLabel("                 "));
   }
   protected void paintComponent(Graphics g) {
      Graphics2D zone = (Graphics2D) g;
      zone.setPaint(Color.green);
      zone.fill(new Rectangle2D.Double(0, 0, 256, 25));
      zone.setPaint(Color.black);
      zone.setFont(new Font("SansSerif", Font.BOLD+Font.ITALIC, 16));
      zone.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
      zone.drawString(titre, 10, 20);
   }
}

class PaletteNiveaux extends Palette {
   /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public PaletteNiveaux(Panneau image) {
      super("Réglage des niveaux", 220, image);
      try {
         this.add(new Réglage("Intensité : Assombrir..............................Eclaircir", image, "intensitéLumineuse", -70, 70));
         this.add(new Réglage("Noir profond (pour augmenter le contraste)", image, "réglerDécalageNoir", 0, 70));
         this.add(new Réglage("Blanc le plus intense (pour le contraste)", image, "réglerDécalageBlanc", 0, 70));
      }
      catch (Exception e) {
         e.printStackTrace();
      }
   }
}

class PaletteAtténuation extends Palette {
   /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public PaletteAtténuation(Panneau image) {
      super("Atténuation des extrêmes", 160, image);
      try {
         this.add(new Réglage("Eclaircir les parties les plus sombres", image, "atténuationFortesDensités", 0, 70));
         this.add(new Réglage("Diminuer les hautes lumières (parties claires)", image, "diminutionHautesLumières", 0, 70));
      }
      catch (Exception e) {
         e.printStackTrace();
      }
   }
}

class PaletteAccentuation extends Palette  {
   /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private JPanel saturation = new JPanel();
   private BoutonSaturation plus;
   private BoutonSaturation moins; 

   public PaletteAccentuation(Panneau image) {
      super("Accentuations", 160, image);
      try {
         this.add(new Réglage("Contraste", image, "réglerContraste", -20, 40));
         saturation.setBorder(BorderFactory.createTitledBorder("Saturation (Augmenter les couleurs)"));
         moins = new BoutonSaturation("-", image, -10);
         plus = new BoutonSaturation("+", image, 10);
         saturation.add(moins);
         saturation.add(plus);
         this.add(saturation);
      }
      catch (Exception e) {
         e.printStackTrace();
      }
   }
}

class BoutonSaturation extends JButton implements ActionListener {
   /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Panneau zone;
   private int valeur;
   
   public BoutonSaturation(String libellé, Panneau zone, int valeur) {
      super(libellé);
      this.zone = zone;
      this.valeur = valeur;
      setPreferredSize(new Dimension(128, 25));
      addActionListener(this);
   }
   public void actionPerformed(ActionEvent e) {
      zone.saturation(valeur);
   }
}

class PaletteHistogramme extends Palette {
   
	private static final long serialVersionUID = 1L;
	private Histogramme histogramme;
   
	public PaletteHistogramme(Panneau zone) {
	      super("Histogramme", 220, zone);
	      histogramme = new Histogramme(zone);
	      zone.setHistogramme(histogramme);
	      this.add(histogramme);
   }
}//*/