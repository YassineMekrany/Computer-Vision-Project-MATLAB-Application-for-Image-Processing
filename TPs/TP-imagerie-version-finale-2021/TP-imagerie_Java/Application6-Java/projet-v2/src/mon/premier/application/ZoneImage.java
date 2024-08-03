package mon.premier.application;

// mon.premier.application;

import java.awt.*;
import java.awt.color.ColorSpace;
import java.awt.geom.*;
import java.awt.image.*;
import java.io.File;
import java.io.IOException;
import javax.imageio.*;
import javax.swing.*;

public class ZoneImage extends JPanel {
   /**
	 * 
	 */
   private static final long serialVersionUID = 1L;
   private BufferedImage imageOriginale, source, image;
   public BufferedImage getSource() {
	return source;
}

public void setSource(BufferedImage source) {
	this.source = source;
}

public void setImageOriginale(BufferedImage imageOriginale) {
	this.imageOriginale = imageOriginale;
}

public void setImage(BufferedImage image) {
	this.image = image;
}
private int[] courbeInitiale = new int[256];
   private byte[] courbe = new byte[256];
   private int fortesDensit�s;
   private int hautesLumi�res;
   private int intensit�;
   private int contraste;
   private int d�calageNoir;
   private int d�calageBlanc;
   private Histogramme histogramme;
   private Historique historique = new Historique();
   private double r�duction;
   
   
   public ZoneImage(Panneau imageLue2){
	   
	   this.setSource(imageLue2.getImageBuffer());
	   this.setImageOriginale(imageLue2.getImageBuffer());
	   this.setImage(imageLue2.getImageBuffer());
	   imageOriginale = imageLue2.getImageBuffer();
	   source = imageLue2.getImageBuffer();
	   image = imageLue2.getImageBuffer();
   }
   
   // je l'ai modifi� en Histo pour le test de Palette-Histo
   public void setHistogramme(Histogramme histogramme) {
      this.histogramme = histogramme;
   }
   public void changeImageOriginale(BufferedImage image) {      
      imageOriginale = image;        
      retailler();
      copieSourceImage();
      historique.initialiser();
   }
   
   private void copieSourceImage() {
      this.image = new BufferedImage(source.getWidth(), source.getHeight(), source.getType());
      Graphics2D dessin = this.image.createGraphics();
      dessin.drawImage(source, null, null);
      repaint();
      r�glerHistogramme();      
   }
   private void retailler() {
      double r�duction =  this.getWidth()>this.getHeight() ? (double)this.getWidth()/imageOriginale.getWidth() : (double)this.getHeight()/imageOriginale.getHeight() ;      
      this.source = new BufferedImage((int)(imageOriginale.getWidth()*r�duction), (int)(imageOriginale.getHeight()*r�duction), imageOriginale.getType()); 
      AffineTransform retailler = AffineTransform.getScaleInstance(r�duction, r�duction);
      int interpolation = AffineTransformOp.TYPE_NEAREST_NEIGHBOR;
      AffineTransformOp retaillerImage = new AffineTransformOp(retailler, interpolation);
      retaillerImage.filter(imageOriginale, source);        
   }
   public void reinitialiser() {
      retailler();
      copieSourceImage();
      historique.initialiser();
   }
   public void changerTaille() {
      String valeur = JOptionPane.showInputDialog("Nouvelle largeur de l'image ?", 1024);
      r�duction =  Double.parseDouble(valeur)/imageOriginale.getWidth();   
      source = new BufferedImage((int)(imageOriginale.getWidth()*r�duction), (int)(imageOriginale.getHeight()*r�duction), imageOriginale.getType()); 
      AffineTransform retailler = AffineTransform.getScaleInstance(r�duction, r�duction);
      int interpolation = AffineTransformOp.TYPE_NEAREST_NEIGHBOR;
      AffineTransformOp retaillerImage = new AffineTransformOp(retailler, interpolation);
      retaillerImage.filter(imageOriginale, source);       
      copieSourceImage();
      historique.ajout("changerTaille");
   }
   public void sauvegarder() throws IOException {
      BufferedImage transfert;
      String fichier = JOptionPane.showInputDialog("Nom du fichier ?", "image.jpg");     
      
      if (historique.existe("changerTaille")) {
         transfert = new BufferedImage((int)(imageOriginale.getWidth()*r�duction), (int)(imageOriginale.getHeight()*r�duction), imageOriginale.getType()); 
         AffineTransform retailler = AffineTransform.getScaleInstance(r�duction, r�duction);
         int interpolation = AffineTransformOp.TYPE_BICUBIC;
         AffineTransformOp retaillerImage = new AffineTransformOp(retailler, interpolation);
         retaillerImage.filter(imageOriginale, transfert);                
      }
      else {
         transfert = new BufferedImage(imageOriginale.getWidth(), imageOriginale.getHeight(), imageOriginale.getType());
         Graphics2D surface = transfert.createGraphics();
         surface.drawImage(transfert, null, null);
      }
         
      if (historique.existe("n�gatif")) {
         byte[] inverser = new byte[256];
         for (int i=0; i<256; i++) inverser[i] = (byte) (255-i);
         ByteLookupTable table = new ByteLookupTable(0, inverser);
         LookupOp inversion = new LookupOp(table, null);
         inversion.filter(transfert, transfert);   
      }
      
      if (historique.existe("noirEtBlanc")) {
         ColorConvertOp gris = new ColorConvertOp(ColorSpace.getInstance(ColorSpace.CS_GRAY), null);
         gris.filter(transfert, transfert);           
      }
      
      if (historique.existe("rotationGauche")) {
         BufferedImage autre = new BufferedImage(transfert.getHeight(), transfert.getWidth(), transfert.getType());
         double centreDeRotation = transfert.getWidth()/2; 
         AffineTransform pivoter = AffineTransform.getRotateInstance(Math.toRadians(-90), centreDeRotation, centreDeRotation);
         AffineTransformOp pivoterImage = new AffineTransformOp(pivoter, null);
         pivoterImage.filter(transfert, autre);          
         transfert = autre;         
      }
      
      if (historique.existe("rotationDroite")) {
         BufferedImage autre = new BufferedImage(transfert.getHeight(), transfert.getWidth(), transfert.getType());
         double centreDeRotation = transfert.getHeight()/2;
         AffineTransform pivoter = AffineTransform.getRotateInstance(Math.toRadians(90), centreDeRotation, centreDeRotation);
         AffineTransformOp pivoterImage = new AffineTransformOp(pivoter, null);
         pivoterImage.filter(transfert, autre);          
         transfert = autre;         
      }

      int[] courbeInitiale = new int[256];
      for (int i=0; i<256; i++) 
         courbeInitiale[i] = (int) ((255-fortesDensit�s-hautesLumi�res)*(i-d�calageNoir)/(255-d�calageNoir-d�calageBlanc)+intensit�*Math.sin((i-d�calageNoir)*Math.PI/(255-d�calageNoir-d�calageBlanc))-contraste*Math.sin((i-d�calageNoir)*2*Math.PI/(255-d�calageNoir-d�calageBlanc))+fortesDensit�s);

      for (int i=0; i<256; i++) {
         if (courbeInitiale[i]<0)               courbe[i] = (byte)0;
         else if (courbeInitiale[i]>255)   courbe[i] = (byte)255;
         else                                             courbe[i] = (byte)courbeInitiale[i];
      }
     
      BufferedImage image = new BufferedImage(transfert.getWidth(), transfert.getHeight(), transfert.getType());
      ByteLookupTable table = new ByteLookupTable(0, courbe);
      LookupOp op�ration = new LookupOp(table, null);
      op�ration.filter(transfert, image);   
      
      ImageIO.write(image, "JPEG", new File(fichier));
   }
   
   public BufferedImage getImageOriginale() {
      return image;
   }
   public BufferedImage getImage() {
      return image;
   }
   protected void paintComponent(Graphics g) {
      Graphics2D surface = (Graphics2D)g;
      if (image!=null) surface.drawImage(image, 0, 0, null);
   }   
   
   public void att�nuationFortesDensit�s(int valeur) {
	  fortesDensit�s = valeur;
      calcul();
   }   
   public void diminutionHautesLumi�res(int valeur) {
      hautesLumi�res = valeur;
      calcul();      
   }
   public void intensit�Lumineuse(int valeur) {
      intensit� = valeur;
      calcul();            
   }
   public void r�glerContraste(int valeur) {
      contraste = valeur;
      calcul();                
   }
   public void r�glerD�calageNoir(int valeur) {
      d�calageNoir = valeur;
      calcul();                      
   }
   public void r�glerD�calageBlanc(int valeur) {
      d�calageBlanc = valeur;
      calcul();                      
   }
   public void saturation(int valeur) {
      float saturation = (valeur + 100)/(float)100F;
      WritableRaster trame = source.getRaster();
      ColorModel mod�le = source.getColorModel();
    
      for (int y=0; y<source.getHeight(); y++)
         for (int x=0; x<source.getWidth(); x++) {
            Object donn�es = trame.getDataElements(x, y, null);
            float[] hsb = new float[3];
            Color.RGBtoHSB(mod�le.getRed(donn�es), mod�le.getGreen(donn�es), mod�le.getBlue(donn�es), hsb);
            Object changement = mod�le.getDataElements(Color.HSBtoRGB(hsb[0], hsb[1]*saturation, hsb[2]), null);
            trame.setDataElements(x, y, changement);
         }
      calcul();
   }
   public void n�gatif() {
      byte[] inverser = new byte[256];
      for (int i=0; i<256; i++) inverser[i] = (byte) (255-i);
      ByteLookupTable table = new ByteLookupTable(0, inverser);
      LookupOp inversion = new LookupOp(table, null);
      inversion.filter(source, source);
      calcul();
      historique.ajout("n�gatif");      
   }
   public void noirEtBlanc() {
      ColorConvertOp gris = new ColorConvertOp(ColorSpace.getInstance(ColorSpace.CS_GRAY), null);
      gris.filter(source, source);      
      calcul();
      historique.ajout("noirEtBlanc");
   }
   public void rotationGauche() {     
      BufferedImage transfert = new BufferedImage(source.getHeight(), source.getWidth(), source.getType());
      double centreDeRotation = source.getWidth()/2; 
      AffineTransform pivoter = AffineTransform.getRotateInstance(Math.toRadians(-90), centreDeRotation, centreDeRotation);
      AffineTransformOp pivoterImage = new AffineTransformOp(pivoter, null);
      pivoterImage.filter(source, transfert);          
      source = transfert;
      copieSourceImage();
      historique.ajout("rotationGauche");
   }
   public void rotationDroite() {
      BufferedImage transfert = new BufferedImage(source.getHeight(), source.getWidth(), source.getType());
      double centreDeRotation = source.getHeight()/2;
      AffineTransform pivoter = AffineTransform.getRotateInstance(Math.toRadians(90), centreDeRotation, centreDeRotation);
      AffineTransformOp pivoterImage = new AffineTransformOp(pivoter, null);
      pivoterImage.filter(source, transfert);          
      source = transfert;
      copieSourceImage();      
      historique.ajout("rotationDroite");
   }
   
   public void calcul() {
      for (int i=0; i<256; i++) 
         courbeInitiale[i] = (int) ((255-fortesDensit�s-hautesLumi�res)*(i-d�calageNoir)/(255-d�calageNoir-d�calageBlanc)+intensit�*Math.sin((i-d�calageNoir)*Math.PI/(255-d�calageNoir-d�calageBlanc))-contraste*Math.sin((i-d�calageNoir)*2*Math.PI/(255-d�calageNoir-d�calageBlanc))+fortesDensit�s);
      r�ajuster();
      traiterImage();
   }   
   private void r�ajuster() {
      for (int i=0; i<256; i++) {
         if (courbeInitiale[i]<0)	courbe[i] = (byte)0;
         else if (courbeInitiale[i]>255)   courbe[i] = (byte)255;
         else	courbe[i] = (byte)courbeInitiale[i];
      }
   }   
   private void traiterImage() {
      ByteLookupTable table = new ByteLookupTable(0, courbe);
      LookupOp op�ration = new LookupOp(table, null);
      op�ration.filter(source, image);   
      repaint();      
   }
   public void r�glerHistogramme() {
      histogramme.repaint();      
   }
}
