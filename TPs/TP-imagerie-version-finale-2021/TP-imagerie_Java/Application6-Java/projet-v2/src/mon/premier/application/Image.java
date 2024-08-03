package mon.premier.application;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.awt.image.ColorModel;
import java.awt.image.ConvolveOp;
import java.awt.image.Kernel;
import java.awt.image.Raster;
import java.awt.image.RescaleOp;
import java.awt.image.WritableRaster;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;

public class Image {
	
	private BufferedImage imagebf;
	WritableRaster trameModifiable;
	ColorModel modeleCouleur ;
	Raster tramePixel;
	
	public Image() {
		// TODO Auto-generated constructor stub
	}
	
	public boolean chargerImage(File fichierImage){
		try {
			imagebf = ImageIO.read(fichierImage);
//			System.out.println(imagebf.getType());
			modeleCouleur=imagebf.getColorModel();
			 tramePixel = imagebf.getRaster();
			return true;
		} catch (IOException e) {
			e.printStackTrace();
			return false;
		}
	}
	
	
	public void enregistrerImage(File fichierImage)
	{
		String format ="png";
		try {
			ImageIO.write(imagebf, format, fichierImage);
		} catch (IOException e) {
			e.printStackTrace();
		}

	}
///////////////////////////////////////////////////
	public Image rgb2gray(){
		Image img=new Image();
		BufferedImage imageGris = new BufferedImage(imagebf.getWidth(), imagebf.getHeight(), BufferedImage.TYPE_USHORT_GRAY);
		Graphics2D surfaceImg = imageGris.createGraphics();
		surfaceImg.drawImage(imagebf, null, null);	  
		img.setBufferedImage(imageGris);
		
		return img;
	}
	
	public Image binaire(){
		Image img=new Image();
		BufferedImage imageGris = new BufferedImage(imagebf.getWidth(), imagebf.getHeight(), BufferedImage.TYPE_BYTE_BINARY);
		Graphics2D surfaceImg = imageGris.createGraphics();
		surfaceImg.drawImage(imagebf, null, null);	  
		img.setBufferedImage(imageGris);
		
		return img;
	}
	public BufferedImage getBufferedImage(){
		return imagebf;
	}
	
	
	
	public Image inverser(){
		Image img=new Image();
		img.setBufferedImage(new BufferedImage(imagebf.getWidth(),imagebf.getHeight(),imagebf.getType()));
		 trameModifiable = img.getBufferedImage().getRaster();
//		 modeleCouleur = imagebf.getColorModel();
//		 tramePixel = imagebf.getRaster();
		 int red=0,green=0,blue=0;
		 for (int i = 0; i < imagebf.getHeight(); i++) {
			for (int j = 0; j < imagebf.getWidth(); j++) {
				Object objCouleur=tramePixel.getDataElements(j, i, null);
				

				 red=modeleCouleur.getRed(objCouleur);
				 green=modeleCouleur .getGreen(objCouleur);
				blue=modeleCouleur .getBlue(objCouleur);
				red=255-red;
				green=255-green;
				blue=255-blue;
                int[]t=new int[]{red,green,blue};	
              
				trameModifiable.setPixel(j, i, t);
			
			}
		}
		
		
		return img;
	}
	
	public int max(){
		int max=0;
		
		for (int i = 0; i < imagebf.getWidth(); i++) {
			for (int j = 0; j < imagebf.getHeight(); j++) {
				Object objCouleur=tramePixel.getDataElements(i, j, null);
				int l=modeleCouleur.getRed(objCouleur);
				if (l>max) max=l;
			}
		}
		
		return  max;
	}
	
//	public int[] max_(){
//		int[] max=new int[3];
//		
//		for (int i = 0; i < imagebf.getWidth(); i++) {
//			for (int j = 0; j < imagebf.getHeight(); j++) {
//				Object objCouleur=tramePixel.getDataElements(i, j, null);
//				int r=modeleCouleur.getRed(objCouleur);
//				int b=modeleCouleur.getBlue(objCouleur);
//				int g=modeleCouleur.getGreen(objCouleur);
//				if (r>max[0]) max[0]=r;
//				if (g>max[1]) max[1]=g;
//				if (b>max[2]) max[2]=b;
//			}
//		}
//		
//		return  max;
//	}
//	public int max_gray(){
//		int max=0;
//		
//		for (int i = 0; i < imagebf.getWidth(); i++) {
//			for (int j = 0; j < imagebf.getHeight(); j++) {
//				Object objCouleur=tramePixel.getDataElements(i, j, null);
//				int l=modeleCouleur.getRed(objCouleur);
//				if (l>max) max=l;
//			}
//		}
//		
//		return  max;
//	}
	
	public int min(){
		int min=255;
		
		for (int i = 0; i < imagebf.getWidth(); i++) {
			for (int j = 0; j < imagebf.getHeight(); j++) {
				Object objCouleur=tramePixel.getDataElements(i, j, null);
				int l=modeleCouleur.getRed(objCouleur);
				if (l<min) min=l;
			}
		}
		
		return  min;
	}
	
//	public int[] min_(){
//	int[] min=new int[3];
//		
//		for (int i = 0; i < imagebf.getWidth(); i++) {
//			for (int j = 0; j < imagebf.getHeight(); j++) {
//				Object objCouleur=tramePixel.getDataElements(i, j, null);
//				int r=modeleCouleur.getRed(objCouleur);
//				int b=modeleCouleur.getBlue(objCouleur);
//				int g=modeleCouleur.getGreen(objCouleur);
//				if (r<min[0]) min[0]=r;
//				if (g<min[1]) min[1]=g;
//				if (b<min[2]) min[2]=b;
//			}
//		}
//		
//		return  min;
//	}
	
	public Image improveContrast(){
		Image image=new Image();
		BufferedImage imgbuffer=new BufferedImage(imagebf.getWidth(),imagebf.getHeight(),imagebf.getType());
		int max=max();// calcule de maximum
		int min=min();//calcul de minumu
		System.out.println(max + " " + min);
		double m=0.5;
		if(max-min!=0)
		 m=255/(max-min); // calcul de m et b pr la transf linéaire  : i'=m*i+b
		double b=-(m*min);
		 RescaleOp operation = new RescaleOp((float)m, (float)b, null); 
		 operation.filter(imagebf, imgbuffer);		
		image.setBufferedImage(imgbuffer);
		return image;
	}
	
	public Image improveContrast_2(){
		Image image=new Image();
		
		BufferedImage imgbuffer=new BufferedImage(imagebf.getWidth(),imagebf.getHeight(),imagebf.getType());
		float[] histogramR=new float[256];
		float[] histogramG=new float[256];
		float[] histogramB=new float[256];
		float[] histogramCumulR=new float[257];
		float[] histogramCumulG=new float[257];
		float[] histogramCumulB=new float[257];
		
		trameModifiable=imgbuffer.getRaster();
		int red=0,green=0,blue=0;
		
		for (int i = 0; i < imagebf.getWidth(); i++) {
			for (int j = 0; j < imagebf.getHeight(); j++) {
				Object objetColor=tramePixel.getDataElements(i, j, null);
				
				red=modeleCouleur.getRed(objetColor);
				histogramR[red]++;
				
				green=modeleCouleur.getGreen(objetColor);
				histogramG[green]++;
					 
				blue=modeleCouleur.getBlue(objetColor);
				histogramB[blue]++;
			}
		}
		
		for (int i = 0; i < histogramR.length; i++) {
		
			histogramR[i]=histogramR[i]/(imagebf.getWidth()*imagebf.getHeight());//normalisation
			
			histogramCumulR[i+1]=histogramCumulR[i]+histogramR[i]; // calcul de l'histo cumulé
			
			histogramG[i]=histogramG[i]/(imagebf.getWidth()*imagebf.getHeight());//normalisation
			
			histogramCumulG[i+1]=histogramCumulG[i]+histogramG[i]; // calcul de l'histo cumulé
			
			histogramB[i]=histogramB[i]/(imagebf.getWidth()*imagebf.getHeight());//normalisation
			
			histogramCumulB[i+1]=histogramCumulB[i]+histogramB[i]; // calcul de l'histo cumulé
			
		}
		
		for (int i = 0; i < imagebf.getWidth(); i++) {
			for (int j = 0; j < imagebf.getHeight(); j++) {
				Object objetColor=tramePixel.getDataElements(i, j, null);
				red=modeleCouleur.getRed(objetColor);
				green=modeleCouleur .getGreen(objetColor);
				blue=modeleCouleur .getBlue(objetColor);
				red=(int) ((int)255*histogramCumulR[red+1]);
				green=(int) (255*histogramCumulG[green+1]);
				blue=(int) (255*histogramCumulB[blue+1]);
                int[]t=new int[]{red,green,blue};	
              
				trameModifiable.setPixel(i, j, t);
			}
		}
		
		image.setBufferedImage(imgbuffer);
		return image;
	}
	
	
	////
	public Image filtreMediane(){

		Image image =new Image();
		BufferedImage imgbuffer=new BufferedImage(imagebf.getWidth(),imagebf.getHeight(),imagebf.getType());
		float[][] tabR=new float[3][3];
		float[][] tabG=new float[3][3];
		float[][] tabB=new float[3][3];
	
		trameModifiable=imgbuffer.getRaster();
		int red=0,green=0,blue=0;
		
		for (int i = 1; i < imagebf.getWidth()-1; i++) {
			for (int j = 1; j < imagebf.getHeight()-1; j++) {
				//pour chak pixel (i,j) on va chercher le voisinage pour calculer la valeur mediane
				
				
				if(j!=1){
					tabR[0]=tabR[1];
					tabR[1]=tabR[2];
					tabB[0]=tabB[1];
					tabB[1]=tabB[2];
					tabG[0]=tabG[1];
					tabG[1]=tabG[2];
					for (int k = i-1; k <= i+1; k++) {
							
								Object objetColor=tramePixel.getDataElements(k, j+1, null);
								
								red=modeleCouleur.getRed(objetColor);
								tabR[2][(k-i+1)]=red;
								
								green=modeleCouleur.getGreen(objetColor);
								tabG[2][(k-i+1)]=green;
									 
								blue=modeleCouleur.getBlue(objetColor);
								tabB[2][(k-i+1)]=blue;
								
								
							
						}
				}else { 
					for (int k2 = j-1; k2 <= j+1; k2++) {
							 for (int k = i-1; k <= i+1; k++) {
								Object objetColor=tramePixel.getDataElements(k, k2, null);// on changer le parcour pour aller horizontalement comme en tableau pr faciliter le trait dans la 1er boucle 
								
								red=modeleCouleur.getRed(objetColor);
								tabR[(k-i+1)][(k2-j+1)]=red;
								
								green=modeleCouleur.getGreen(objetColor);
								tabG[(k-i+1)][(k2-j+1)]=green;
									 
								blue=modeleCouleur.getBlue(objetColor);
								tabB[(k-i+1)][(k2-j+1)]=blue;
								
								
							}
						}
					
					}
					
					
				
				//trie des tablaux
				//aprés trie on prend le mediane et on le met dans le pixel (i,j)
				float medianer=trie_Med(tabR);
				float medianeg=trie_Med(tabG);
				float medianeb=trie_Med(tabB); 
				
				int[]t=new int[]{(int)medianer,(int)medianeg,(int)medianeb};	
              
				trameModifiable.setPixel(i, j, t);
				
			}
		}
		image.setBufferedImage(imgbuffer);
		
		return image;
	}
	////
	private float trie_Med(float tabi[][]){
			float [] tab=new float[9];
			
			for (int i = 0; i < 3; i++) {
				tab[i]=tabi[i][0];
//				System.out.println("--"+tab[i]);
			}

			for (int i = 0; i < 3; i++) {
				tab[i+3]=tabi[i][1];
//				System.out.println("--"+tab[i+3]);
			}

			for (int i = 0; i < 3; i++) {
				tab[i+6]=tabi[i][2];
//				System.out.println("--"+tab[i+6]);
			}
		
			 for (int j=1; j<tab.length; j++) {
			      float x = tab[j];
			      int i = j-1;
			      // x doit être inséré dans le tableau ordonné 0..j-1
			      while (i>=0 && tab[i]>x) {
			        tab[i+1] = tab[i];
			        i = i-1;
			      }
			      tab[i+1] = x;
			    }

//		System.out.println(tab[4]);
		return tab[4];
	}
		//////////////////////////
	////
	public Image filtreMediane2(){
		Image image =new Image();
		BufferedImage imgbuffer=new BufferedImage(imagebf.getWidth(),imagebf.getHeight(),imagebf.getType());
		float[][] tabR=new float[5][5];
		float[][] tabG=new float[5][5];
		float[][] tabB=new float[5][5];
	
		trameModifiable=imgbuffer.getRaster();
		int red=0,green=0,blue=0;
		
		for (int i = 2; i < imagebf.getWidth()-2; i++) {
			for (int j = 2; j < imagebf.getHeight()-2; j++) {
				//pour chak pixel (i,j) on va chercher le voisinage pour calculer la valeur mediane
				
				
				if(j!=1){
					tabR[0]=tabR[1];
					tabR[1]=tabR[2];
					tabR[2]=tabR[3];
					tabR[3]=tabR[4];
					
					tabB[0]=tabB[1];
					tabB[1]=tabB[2];
					tabB[2]=tabB[3];
					tabB[3]=tabB[4];
					
					
					tabG[0]=tabG[1];
					tabG[1]=tabG[2];
					tabG[2]=tabG[3];
					tabG[3]=tabG[4];
					
					
					for (int k = i-2; k <= i+2; k++) {
							
								Object objetColor=tramePixel.getDataElements(k, j+1, null);
								
								red=modeleCouleur.getRed(objetColor);
								tabR[4][(k-i+2)]=red;
								
								green=modeleCouleur.getGreen(objetColor);
								tabG[4][(k-i+2)]=green;
									 
								blue=modeleCouleur.getBlue(objetColor);
								tabB[4][(k-i+2)]=blue;
								
								
							
						}
				}else { 
					for (int k2 = j-2; k2 <= j+2; k2++) {
							 for (int k = i-2; k <= i+2; k++) {
								Object objetColor=tramePixel.getDataElements(k, k2, null);// on changer le parcour pour aller horizontalement comme en tableau pr faciliter le trait dans la 1er boucle 
								
								red=modeleCouleur.getRed(objetColor);
								tabR[(k-i+2)][(k2-j+2)]=red;
								
								green=modeleCouleur.getGreen(objetColor);
								tabG[(k-i+2)][(k2-j+2)]=green;
									 
								blue=modeleCouleur.getBlue(objetColor);
								tabB[(k-i+2)][(k2-j+2)]=blue;
								
								
							}
						}
					
					}
					
					
				
				//trie des tablaux
				//aprés trie on prend le mediane et on le met dans le pixel (i,j)
				float medianer=trie_Med2(tabR);
				float medianeg=trie_Med2(tabG);
				float medianeb=trie_Med2(tabB); 
				
				int[]t=new int[]{(int)medianer,(int)medianeg,(int)medianeb};	
              
				trameModifiable.setPixel(i, j, t);
				
			}
		}
		image.setBufferedImage(imgbuffer);
		
		return image;
	}
	
	///////////////////
	private float trie_Med2(float tabi[][]){
		float [] tab=new float[25];
		
		for (int i = 0; i < 5; i++) {
			tab[i]=tabi[i][0];
		}

		for (int i = 0; i < 5; i++) {
			tab[i+5]=tabi[i][1];

		}

		for (int i = 0; i < 5; i++) {
			tab[i+10]=tabi[i][2];

		}
		
		for (int i = 0; i < 5; i++) {
			tab[i+15]=tabi[i][3];

		}
		
		for (int i = 0; i < 5; i++) {
			tab[i+20]=tabi[i][4];

		}
	
		 for (int j=1; j<tab.length; j++) {
		      float x = tab[j];
		      int i = j-1;
		      // x doit être inséré dans le tableau ordonné 0..j-1
		      while (i>=0 && tab[i]>x) {
		        tab[i+1] = tab[i];
		        i = i-1;
		      }
		      tab[i+1] = x;
		    }

//	System.out.println(tab[4]);
	return tab[12];
}
	////
	public Image filtreMoyenneur(){
		Image image=new Image();
		BufferedImage imgbuffer=new BufferedImage(imagebf.getWidth(),imagebf.getHeight(),imagebf.getType());
	    float[] blur = { 1f/9f, 1f/9f, 1f/9f,
                1f/9f, 1f/9f, 1f/9f,  
                1f/9f, 1f/9f, 1f/9f };
	    
	    ConvolveOp operation=new ConvolveOp(new Kernel(3, 3, blur));
		operation.filter(imagebf, imgbuffer);
		image.setBufferedImage(imgbuffer);
		return image;
	}
	////
	
	////
	public Image filtreMoyenneur2(){
		Image image=new Image();
		BufferedImage imgbuffer=new BufferedImage(imagebf.getWidth(),imagebf.getHeight(),imagebf.getType());
	    float[] blur = { 1f/25f, 1f/25f, 1f/25f,1f/25f,1f/25f,
	    		1f/25f, 1f/25f, 1f/25f,1f/25f,1f/25f,
	    		1f/25f, 1f/25f, 1f/25f,1f/25f,1f/25f,
	    		1f/25f, 1f/25f, 1f/25f,1f/25f,1f/25f,
	    		1f/25f, 1f/25f, 1f/25f,1f/25f,1f/25f, };
	    
	    ConvolveOp operation=new ConvolveOp(new Kernel(5, 5, blur));
		operation.filter(imagebf, imgbuffer);
		image.setBufferedImage(imgbuffer);
		return image;
	}
	////
	
	////
	public Image filtreGaussien(){
		Image image=new Image();
		BufferedImage imgbuffer=new BufferedImage(imagebf.getWidth(),imagebf.getHeight(),imagebf.getType());
	    float[] blur = { 1f/16f, 1f/8f, 1f/16f,
                1f/8f, 1f/4f, 1f/8f,  
                1f/16f, 1f/8f, 1f/16f };
	    
	    ConvolveOp operation=new ConvolveOp(new Kernel(3, 3, blur));
		operation.filter(imagebf, imgbuffer);
		image.setBufferedImage(imgbuffer);
		return image;
	}
	////
	
	////
	public Image filtreLaplacien(){
		Image image=new Image();
		BufferedImage imgbuffer=new BufferedImage(imagebf.getWidth(),imagebf.getHeight(),imagebf.getType());
	    float[] blur = { 0, 1f, 0,
                1f, -4f, 1f,  
                0, 1f, 0 };
	    
	    ConvolveOp operation=new ConvolveOp(new Kernel(3, 3, blur));
		operation.filter(imagebf, imgbuffer);
		image.setBufferedImage(imgbuffer);
		return image;
	}
	////
	
	////
	public Image filtreSobel(){
		Image image=new Image();
		BufferedImage imgbuffer=new BufferedImage(imagebf.getWidth(),imagebf.getHeight(),imagebf.getType());
	    float[] blur = { -1,0, 1,
	    				-2, 0, 2,  
	    				-1, 0, 1};
	    
	    ConvolveOp operation=new ConvolveOp(new Kernel(3, 3, blur));
		operation.filter(imagebf, imgbuffer);
		image.setBufferedImage(imgbuffer);
		return image;
	}
	////
	
	
	////
	public Image filtreRehausseurContrast(){
		Image image=new Image();
		BufferedImage imgbuffer=new BufferedImage(imagebf.getWidth(),imagebf.getHeight(),imagebf.getType());
	    float[] f = {	 1,-3, 1,
	    				-3, 9, -3,  
	    				-1, -3, 1};
	    
	    ConvolveOp operation=new ConvolveOp(new Kernel(3, 3, f));
		operation.filter(imagebf, imgbuffer);
		image.setBufferedImage(imgbuffer);
		return image;
	}
	////
	

	////
	public Image filtreRehausseurContrast2(){
		Image image=new Image();
		BufferedImage imgbuffer=new BufferedImage(imagebf.getWidth(),imagebf.getHeight(),imagebf.getType());
	    float[] f = {	 -1/25,-1/25,-1/25,-1/25,-1/25,
	    				-1/25,-1/25,-1/25,-1/25,-1/25,
	    				-1/25,-1/25,24/25,-1/25,-1/25,
	    				-1/25,-1/25,-1/25,-1/25,-1/25,
	    				-1/25,-1/25,-1/25,-1/25,-1/25,};
	    
	    ConvolveOp operation=new ConvolveOp(new Kernel(5, 5, f));
		operation.filter(imagebf, imgbuffer);
		image.setBufferedImage(imgbuffer);
		return image;
	}
	////
	////
	public Image filtreGradientOblique(){
		Image image=new Image();
		BufferedImage imgbuffer=new BufferedImage(imagebf.getWidth(),imagebf.getHeight(),imagebf.getType());
			float[] f = { 1, 1, 0,
	    				  1, 0, 1,  
	    				  0, 1, 1};
	    
	    ConvolveOp operation=new ConvolveOp(new Kernel(3, 3, f));
		operation.filter(imagebf, imgbuffer);
		image.setBufferedImage(imgbuffer);
		return image;
	}
	////
////////////////////////////////////////////////////////////////////////////////
	public void dessiner(Graphics g){
		g.drawImage(imagebf, 0, 0, null);
	}
	
	public Dimension getDimention(){
		if(imagebf==null) return new Dimension(0,0);
		return new Dimension(imagebf.getHeight(),imagebf.getWidth());
	}
	
	public void setBufferedImage(BufferedImage bf){
		this.imagebf=bf;
		modeleCouleur=imagebf.getColorModel();
		tramePixel = imagebf.getRaster();
	}
}
