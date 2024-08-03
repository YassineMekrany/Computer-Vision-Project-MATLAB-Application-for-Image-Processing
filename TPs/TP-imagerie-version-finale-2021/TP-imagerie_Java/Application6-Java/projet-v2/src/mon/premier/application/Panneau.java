package mon.premier.application;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.awt.image.ByteLookupTable;
import java.awt.image.ColorModel;
import java.awt.image.LookupOp;
import java.awt.image.WritableRaster;
import java.io.File;
import javax.swing.JPanel;

public class Panneau extends JPanel {
	
	private BufferedImage imageBuffer, source;
	private Histogramme histogramme;
	
	   private int[] courbeInitiale = new int[256];
	   private byte[] courbe = new byte[256];
	   private int fortesDensités;
	   private int hautesLumières;
	   private int intensité;
	   private int contraste;
	   private int décalageNoir;
	   private int décalageBlanc;

	Image image=new Image();
	
	public Panneau() {
		// TODO Auto-generated constructor stub
	}
	public Histogramme getHistogramme() {
		return histogramme;
	}
	public void setHistogramme(Histogramme histogramme) {
		this.histogramme = histogramme;
	}
	public void setImage(File fichierImage){
		image.chargerImage(fichierImage);
	}
	public void setImage(Image image){
		this.image=image;
	}
	public Image getImage(){
		return image;
	}
	public BufferedImage getImageBuffer() {
		imageBuffer = image.getBufferedImage();
		return imageBuffer;
	}
	public void setImageBuffer(BufferedImage imageBuffer) {
		this.imageBuffer = imageBuffer;
	}
	
	@Override
	protected void paintComponent(Graphics g) {
		
			System.out.println("dessin");
			image.dessiner(g);
			this.setPreferredSize(image.getDimention());	
	}	
	public void réglerHistogramme() {
	      histogramme.repaint();      
	}
		public void saturation(int valeur) {
		      float saturation = (valeur+100)/(float)100F;
		      WritableRaster trame = source.getRaster();
		      ColorModel modèle = source.getColorModel();
		    
		      for (int y=0; y < source.getHeight(); y++)
		         for (int x=0; x<source.getWidth(); x++) {
		            Object données = trame.getDataElements(x, y, null);
		            float[] hsb = new float[3];
		            Color.RGBtoHSB(modèle.getRed(données), modèle.getGreen(données), modèle.getBlue(données), hsb);
		            Object changement = modèle.getDataElements(Color.HSBtoRGB(hsb[0], hsb[1]*saturation, hsb[2]), null);
		            trame.setDataElements(x, y, changement);
		         }
		      calcul();
		   }
		
		  public void calcul() {
		      for (int i=0; i<256; i++) 
		         courbeInitiale[i] = (int) ((255-fortesDensités-hautesLumières)*(i-décalageNoir)/(255-décalageNoir-décalageBlanc)+intensité*Math.sin((i-décalageNoir)*Math.PI/(255-décalageNoir-décalageBlanc))-contraste*Math.sin((i-décalageNoir)*2*Math.PI/(255-décalageNoir-décalageBlanc))+fortesDensités);
		      réajuster();
		      traiterImage();
		   }   
		   private void réajuster() {
		      for (int i=0; i<256; i++) {
		         if (courbeInitiale[i]<0)	courbe[i] = (byte)0;
		         else if (courbeInitiale[i]>255)   courbe[i] = (byte)255;
		         else	courbe[i] = (byte)courbeInitiale[i];
		      }
		   }   
		   private void traiterImage() {
		      ByteLookupTable table = new ByteLookupTable(0, courbe);
		      LookupOp opération = new LookupOp(table, null);
		      //opération.filter(source, image);   
		      repaint();      
		   }
}
