package mon.premier.application;

// mon.premier.application;

import java.awt.*;
import java.awt.geom.*;
import java.awt.image.*;
import javax.swing.*;

public class Histogramme extends JPanel {
   /**
	 * 
	 */
   private static final long serialVersionUID = 1L;
   private Panneau zone;   
   private final int largeur = 256;
   private final int hauteur = 180;
   private Graphics2D dessin;
   private int[] rouge;
   private int[] vert;
   private int[] bleu;
   private int[] rvb;
   
   public Histogramme(Panneau zone) {
      this.zone = zone;
      this.setPreferredSize(new Dimension(largeur, hauteur));
   }
   protected void paintComponent(Graphics surface) {
      super.paintComponent(surface);
      if (zone.getImageBuffer()!=null) {
         dessin = (Graphics2D) surface;
         récupérerRVB();
         tracerHistogrammes();
      }
   }
   private void récupérerRVB() {
      rouge = new int[256];
      vert = new int[256];
      bleu = new int[256];
      rvb = new int[256];
      
     BufferedImage image = zone.getImageBuffer();
     Raster trame = image.getRaster();
     ColorModel modèle = image.getColorModel();
     for (int y=0; y<image.getHeight(); y++)
       for (int x=0; x<image.getWidth(); x++) {
         Object données = trame.getDataElements(x, y, null);
         rouge[modèle.getRed(données)]++;
         vert[modèle.getGreen(données)]++;
         bleu[modèle.getBlue(données)]++;
       }     
     for (int i=0; i<256; i++)
        rvb[i] = (rouge[i]+vert[i]+bleu[i])/2;
}
   
   private void tracerHistogrammes() {
      Rectangle2D rectangle = new Rectangle2D.Double(0, 0, largeur-1, hauteur-1);
      dessin.draw(rectangle);
      dessin.setPaint(new Color(1F, 1F, 1F, 0.2F));
      dessin.fill(rectangle);      
      changerAxes();
      dessin.setPaint(new Color(1F, 0F, 0F, 0.4F));
      tracerHistogramme(rouge);
      dessin.setPaint(new Color(0F, 1F, 0F, 0.4F));
      tracerHistogramme(vert);
      dessin.setPaint(new Color(0F, 0F, 1F, 0.4F));
      tracerHistogramme(bleu);
      dessin.setPaint(new Color(0F, 0F, 0F, 0.4F));
      tracerHistogramme(rvb);
   }

   private void changerAxes() {
      dessin.translate(0, hauteur);
      double surfaceImage = zone.getImageBuffer().getWidth()*zone.getImageBuffer().getHeight();
      double surfaceHistogramme = largeur*hauteur;
      dessin.scale(1, -surfaceHistogramme/surfaceImage/3.7);      
   }   
   
   private void tracerHistogramme(int[] couleur) {
      for (int i=0; i<255; i++) 
         dessin.drawLine(i, 0, i, couleur[i]);              
   }  
}

