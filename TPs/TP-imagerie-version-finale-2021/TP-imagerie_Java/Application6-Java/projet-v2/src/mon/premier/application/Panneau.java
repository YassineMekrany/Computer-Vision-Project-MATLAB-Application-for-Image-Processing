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
	   private int fortesDensit�s;
	   private int hautesLumi�res;
	   private int intensit�;
	   private int contraste;
	   private int d�calageNoir;
	   private int d�calageBlanc;

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
	public void r�glerHistogramme() {
	      histogramme.repaint();      
	}
		public void saturation(int valeur) {
		      float saturation = (valeur+100)/(float)100F;
		      WritableRaster trame = source.getRaster();
		      ColorModel mod�le = source.getColorModel();
		    
		      for (int y=0; y < source.getHeight(); y++)
		         for (int x=0; x<source.getWidth(); x++) {
		            Object donn�es = trame.getDataElements(x, y, null);
		            float[] hsb = new float[3];
		            Color.RGBtoHSB(mod�le.getRed(donn�es), mod�le.getGreen(donn�es), mod�le.getBlue(donn�es), hsb);
		            Object changement = mod�le.getDataElements(Color.HSBtoRGB(hsb[0], hsb[1]*saturation, hsb[2]), null);
		            trame.setDataElements(x, y, changement);
		         }
		      calcul();
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
		      //op�ration.filter(source, image);   
		      repaint();      
		   }
}
