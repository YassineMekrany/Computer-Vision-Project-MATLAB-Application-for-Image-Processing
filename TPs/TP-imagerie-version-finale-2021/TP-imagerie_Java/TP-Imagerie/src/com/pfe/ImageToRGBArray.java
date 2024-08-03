package com.pfe;

import java.awt.Point;
import java.awt.image.BufferedImage;



public class ImageToRGBArray {
	private BufferedImage bi;
	private int           width;
	private int           height;
	private int[]         data;
	private int[]		  dataLoaded;
	private int[]         rgb;   // temp value of a pixel 
	private ImagePanel motherImagePanel;

	public ImageToRGBArray(BufferedImage originalBufferedImage, ImagePanel motherImagePanel) {
		bi     = originalBufferedImage;
		width  = bi.getWidth();
		height = bi.getHeight();
		this.motherImagePanel = motherImagePanel;
		rgb    = new int[3];
		data   = new int[width*height];
		dataLoaded   = new int[width*height];
		for (int i=0; i<width; i++){
		    for (int j=0; j<height; j++){
				data[j*width+i] = bi.getRGB(i,j);
			    dataLoaded[j*width+i] = bi.getRGB(i,j);
		    }
		}
	}
	
	private void getRGB (int x, int y) {
		int pixel = data[y*width+x];
		//rouge correspond aux bits 8-15 de notre entier, on fait donc un decalage de 16 vers la
		//droite puis comme ce qu'il y a au-dela (le canal alpha) ne nous interesse pas, on le supprime par
		//l'operation binaire & "et binaire" avec 0xFF.
		rgb[0] = (pixel >> 16) & 0xFF;
		rgb[1] = (pixel >>  8) & 0xFF;//vert
		rgb[2] = (pixel      ) & 0xFF;//bleu
	}
	
	private void setRGB (int x, int y) {
		data[y*width+x] = 0xFF000000  | (rgb[0] << 16) | (rgb[1] <<  8) | rgb[2];
	}
	private void updateBufferedImage() {
		for (int x=0; x<width;x++)
		    for (int y=0; y<height;y++)
				bi.setRGB(x,y,data[y*width+x]);
	}
	public void backToImageLoaded(){
		for (int i = 0; i < dataLoaded.length; i++) {
			data[i] = dataLoaded[i];
		}
		updateBufferedImage();
	}
	
	public void inverseCouleurs () {

		for (int x=0; x<width;x++) {
		    for (int y=0; y<height;y++) {
				getRGB(x,y);
				for (int p=0; p<3;p++)
				    rgb[p] = 255 - rgb[p]; // d'apres la formule g(x,y)=-f(x,y)+255;
				setRGB(x,y);
		    }
		}	
		updateBufferedImage();
	}

	 public void NiveauDeGris () {
			int l;
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++) {
					getRGB(x,y);
					l=(int)(0.3*rgb[0]+0.59*rgb[1]+0.11*rgb[2]);
					//l=(int)(0.2126*rgb[0]+0.7152*rgb[1]+0.0722*rgb[2]);//L = 0.2126*R + 0.7152*G + 0.0722*B
					rgb[0]=l;
					rgb[1]=l;
					rgb[2]=l;
					setRGB(x,y);
			    }
			}	
			updateBufferedImage();
		}

	 public void BinarisationParSeuillage () {
		 /*// Trouver la moyenne dans l'image
		 int dataIntRGB[] = new int[data.length];
		 for (int w = 0; w < width; w++) {
			for (int h = 0; h < height; h++) {
				getRGB(w, h);
				for (int i = 0; i < rgb.length; i++) {
					dataIntRGB[h * width + w] += rgb[i];
				}
				dataIntRGB[h * width + w] = (int)dataIntRGB[h * width + w]/3;
			}
		}
		 int som = 0;
		 for (int i = 0; i < dataIntRGB.length; i++) {
			som += dataIntRGB[i];
		}
		 
		 int seuil = som/dataIntRGB.length;
		 System.out.println(seuil);
		 */
			int seuil=128;
			int l;
			int l1;
			
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++) {
					getRGB(x,y);
					l=rgb[0];
					if(l<seuil) l1=0;//tous ce quoi est inferieur a 0 en le rendre noir
					else l1=255;//tous ce qui est superieur a 255 en le rendre blanc
					rgb[0]=l1;
					rgb[1]=l1;
					rgb[2]=l1;
					setRGB(x,y);
			    }
			}	
			updateBufferedImage();
		}

	 public int minimum(){
			getRGB(0,0);
			int min=rgb[0];
			int l;
			for (int x=0; x<width;x++) {
				for (int y=0; y<height;y++) {
					getRGB(x,y);
					l=rgb[0];
					if(min>l) min=l;
			    }
			}
			return min;
		}
	 public int maximum(){
			getRGB(0,0);
			int max=rgb[0];
			int l;
			for (int x=0; x<width;x++) {
				for (int y=0; y<height;y++) {
					getRGB(x,y);
					l=rgb[0];
					if(max<l) max=l;
			    }
			}
			return max;
	 }
	 public void Recadrage () {
			int min=minimum();
			int max=maximum();
			int l;
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++) {
					getRGB(x,y);
					l=rgb[0];
					l=((l-min)*255)/(max-min);
					rgb[0]=l;
					rgb[1]=l;
					rgb[2]=l;
					setRGB(x,y);
			    }
			}	
			updateBufferedImage();
	 }
	 
	 public void bruitPoivreSel(int n) {
		 //(2*n)% des pixels de l'image sont remplacés (n pixels par Blanc(255) et lesautres n par le noir(0)
		 int xn,yn;
		 int xb,yb;
		 for (int i = 0; i < n*width*height/100; i++) {
			 xn = Math.round((float)Math.random()*1000);
			 yn = Math.round((float)Math.random()*1000);
			 xb = Math.round((float)Math.random()*1000);
			 yb = Math.round((float)Math.random()*1000);
			 if(xn >= width || xb >= width) i--;
			 else {
				 if(yn>=height || yb>=height) i--;
				 else{
					 getRGB(xn, yn);
					 for (int j = 0; j < rgb.length; j++) {
						rgb[j] = 0;
					}
					 setRGB(xn, yn);
					 getRGB(xb, yb);
					 for (int j = 0; j < rgb.length; j++) {
							rgb[j] = 255;
					}
					 setRGB(xb, yb);
				 }
			 }
		}
		 updateBufferedImage();
	 }
	 public void Moyenneur3_3 () {
			
			int [][]tr=new int[width][height];
			int [][]tg=new int[width][height];
			int [][]tb=new int[width][height];
			int [][]t1=new int[width][height];
			int [][]t2=new int[width][height];
			int [][]t3=new int[width][height];
			
			
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++){
			    	tr[x][y]=0;
			    	tg[x][y]=0;
			    	tb[x][y]=0;
			    }
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++){
			    	getRGB(x,y);
			    	t1[x][y]=rgb[0];
			    	t2[x][y]=rgb[1];
			    	t3[x][y]=rgb[2];
			    }
			}
			
			for (int x=1; x<width-1;x++) {
			    for (int y=1; y<height-1;y++) {
			   /* 	    [1 1 1]
			     1/9 *	[1 1 1]
			            [1 1 1]*/
			    tr[x][y]	=(t1[x][y-1]+t1[x][y+1]+t1[x][y]+t1[x+1][y-1]+t1[x+1][y]+t1[x+1][y+1]+t1[x-1][y+1]+t1[x-1][y]+t1[x-1][y-1])/9;
			    tg[x][y]	=(t2[x][y-1]+t2[x][y+1]+t2[x][y]+t2[x+1][y-1]+t2[x+1][y]+t2[x+1][y+1]+t2[x-1][y+1]+t2[x-1][y]+t2[x-1][y-1])/9;
			    tb[x][y]	=(t3[x][y-1]+t3[x][y+1]+t3[x][y]+t3[x+1][y-1]+t3[x+1][y]+t3[x+1][y+1]+t3[x-1][y+1]+t3[x-1][y]+t3[x-1][y-1])/9;
				}
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++) {
					
					rgb[0]=tr[x][y];
					rgb[1]=tg[x][y];
					rgb[2]=tb[x][y];
					setRGB(x,y);
			    }
			}		
			updateBufferedImage();
			//NiveauDeGris();
		}
	 	
	 public void moyenneur5_5(){
			int [][]tr=new int[height][width];
			int [][]tg=new int[height][width];
			int [][]tb=new int[height][width];
			int [][]t1=new int[height][width];
			int [][]t2=new int[height][width];
			int [][]t3=new int[height][width];
			
		    for (int y=0; y<height;y++){
		    	for (int x=0; x<width;x++) {
			    	tr[y][x]=0;
			    	tg[y][x]=0;
			    	tb[y][x]=0;
			    }
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++){
			    	getRGB(x,y);
			    	t1[y][x]=rgb[0];
			    	t2[y][x]=rgb[1];
			    	t3[y][x]=rgb[2];
			    }
			}
			for (int y = 2; y < height - 2; y++) {
				for (int x = 2; x < width - 2; x++) {
					tr[y][x] = (t1[y-2][x-2]+t1[y-1][x-2]+t1[y][x-2]+t1[y+1][x-2]+t1[y+2][x-2]+t1[y-2][x-1]+t1[y-1][x-1]+t1[y][x-1]+t1[y+1][x-1]+t1[y+2][x-1]+t1[y-2][x]+t1[y-1][x]+t1[y][x]+t1[y+1][x]+t1[y+2][x]+t1[y-2][x+1]+t1[y-1][x+1]+t1[y][x+1]+t1[y+1][x+1]+t1[y+2][x+1]+t1[y-2][x+2]+t1[y-1][x+2]+t1[y][x+2]+t1[y+1][x+2]+t1[y+2][x+2])/25;
					tg[y][x] = (t2[y-2][x-2]+t2[y-1][x-2]+t2[y][x-2]+t2[y+1][x-2]+t2[y+2][x-2]+t2[y-2][x-1]+t2[y-1][x-1]+t2[y][x-1]+t2[y+1][x-1]+t2[y+2][x-1]+t2[y-2][x]+t2[y-1][x]+t2[y][x]+t2[y+1][x]+t2[y+2][x]+t2[y-2][x+1]+t2[y-1][x+1]+t2[y][x+1]+t2[y+1][x+1]+t2[y+2][x+1]+t2[y-2][x+2]+t2[y-1][x+2]+t2[y][x+2]+t2[y+1][x+2]+t2[y+2][x+2])/25;
					tb[y][x] = (t3[y-2][x-2]+t3[y-1][x-2]+t3[y][x-2]+t3[y+1][x-2]+t3[y+2][x-2]+t3[y-2][x-1]+t3[y-1][x-1]+t3[y][x-1]+t3[y+1][x-1]+t3[y+2][x-1]+t3[y-2][x]+t3[y-1][x]+t3[y][x]+t3[y+1][x]+t3[y+2][x]+t3[y-2][x+1]+t3[y-1][x+1]+t3[y][x+1]+t3[y+1][x+1]+t3[y+2][x+1]+t3[y-2][x+2]+t3[y-1][x+2]+t3[y][x+2]+t3[y+1][x+2]+t3[y+2][x+2])/25;
				}
				
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++) {
					
					rgb[0]=tr[y][x];
					rgb[1]=tg[y][x];
					rgb[2]=tb[y][x];
					setRGB(x,y);
			    }
			}		
			updateBufferedImage();
			//NiveauDeGris();
		 
	 }


	 public void binomialGaussien3_3(){
			int [][]tr=new int[height][width];
			int [][]tg=new int[height][width];
			int [][]tb=new int[height][width];
			int [][]t1=new int[height][width];
			int [][]t2=new int[height][width];
			int [][]t3=new int[height][width];
			
		    for (int y=0; y<height;y++){
		    	for (int x=0; x<width;x++) {
			    	tr[y][x]=0;
			    	tg[y][x]=0;
			    	tb[y][x]=0;
			    }
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++){
			    	getRGB(x,y);
			    	t1[y][x]=rgb[0];
			    	t2[y][x]=rgb[1];
			    	t3[y][x]=rgb[2];
			    }
			}
			for (int y = 1; y < height - 1; y++) {
				for (int x = 1; x < width - 1; x++) {
					tr[y][x] = (1*t1[y-1][x-1]+2*t1[y][x-1]+1*t1[y+1][x-1]+2*t1[y-1][x]+4*t1[y][x]+2*t1[y+1][x]+1*t1[y-1][x+1]+2*t1[y][x+1]+1*t1[y+1][x+1])/16;
					tg[y][x] = (1*t2[y-1][x-1]+2*t2[y][x-1]+1*t2[y+1][x-1]+2*t2[y-1][x]+4*t2[y][x]+2*t2[y+1][x]+1*t2[y-1][x+1]+2*t2[y][x+1]+1*t2[y+1][x+1])/16;
					tb[y][x] = (1*t3[y-1][x-1]+2*t3[y][x-1]+1*t3[y+1][x-1]+2*t3[y-1][x]+4*t3[y][x]+2*t3[y+1][x]+1*t3[y-1][x+1]+2*t3[y][x+1]+1*t3[y+1][x+1])/16;
				}
				
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++) {
					
					rgb[0]=tr[y][x];
					rgb[1]=tg[y][x];
					rgb[2]=tb[y][x];
					setRGB(x,y);
			    }
			}		
			updateBufferedImage();
			//NiveauDeGris();
		 
	 }
	 
	 public void gaussienOuBinomial(){
			int [][]tr=new int[height][width];
			int [][]tg=new int[height][width];
			int [][]tb=new int[height][width];
			int [][]t1=new int[height][width];
			int [][]t2=new int[height][width];
			int [][]t3=new int[height][width];
			
		    for (int y=0; y<height;y++){
		    	for (int x=0; x<width;x++) {
			    	tr[y][x]=0;
			    	tg[y][x]=0;
			    	tb[y][x]=0;
			    }
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++){
			    	getRGB(x,y);
			    	t1[y][x]=rgb[0];
			    	t2[y][x]=rgb[1];
			    	t3[y][x]=rgb[2];
			    }
			}
			for (int y = 2; y < height - 2; y++) {
				for (int x = 2; x < width - 2; x++) {
					tr[y][x] = (1*t1[y-2][x-2]+4*t1[y-1][x-2]+6*t1[y][x-2]+4*t1[y+1][x-2]+1*t1[y+2][x-2]+4*t1[y-2][x-1]+16*t1[y-1][x-1]+24*t1[y][x-1]+16*t1[y+1][x-1]+4*t1[y+2][x-1]+6*t1[y-2][x]+24*t1[y-1][x]+36*t1[y][x]+24*t1[y+1][x]+6*t1[y+2][x]+4*t1[y-2][x+1]+16*t1[y-1][x+1]+24*t1[y][x+1]+16*t1[y+1][x+1]+4*t1[y+2][x+1]+1*t1[y-2][x+2]+4*t1[y-1][x+2]+6*t1[y][x+2]+4*t1[y+1][x+2]+1*t1[y+2][x+2])/256;
					tg[y][x] = (1*t2[y-2][x-2]+4*t2[y-1][x-2]+6*t2[y][x-2]+4*t2[y+1][x-2]+1*t2[y+2][x-2]+4*t2[y-2][x-1]+16*t2[y-1][x-1]+24*t2[y][x-1]+16*t2[y+1][x-1]+4*t2[y+2][x-1]+6*t2[y-2][x]+24*t2[y-1][x]+36*t2[y][x]+24*t2[y+1][x]+6*t2[y+2][x]+4*t2[y-2][x+1]+16*t2[y-1][x+1]+24*t2[y][x+1]+16*t2[y+1][x+1]+4*t2[y+2][x+1]+1*t2[y-2][x+2]+4*t2[y-1][x+2]+6*t2[y][x+2]+4*t2[y+1][x+2]+1*t2[y+2][x+2])/256;
					tb[y][x] = (1*t3[y-2][x-2]+4*t3[y-1][x-2]+6*t3[y][x-2]+4*t3[y+1][x-2]+1*t3[y+2][x-2]+4*t3[y-2][x-1]+16*t3[y-1][x-1]+24*t3[y][x-1]+16*t3[y+1][x-1]+4*t3[y+2][x-1]+6*t3[y-2][x]+24*t3[y-1][x]+36*t3[y][x]+24*t3[y+1][x]+6*t3[y+2][x]+4*t3[y-2][x+1]+16*t3[y-1][x+1]+24*t3[y][x+1]+16*t3[y+1][x+1]+4*t3[y+2][x+1]+1*t3[y-2][x+2]+4*t3[y-1][x+2]+6*t3[y][x+2]+4*t3[y+1][x+2]+1*t3[y+2][x+2])/256;
				}
				
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++) {
					
					rgb[0]=tr[y][x];
					rgb[1]=tg[y][x];
					rgb[2]=tb[y][x];
					setRGB(x,y);
			    }
			}		
			updateBufferedImage();
			//NiveauDeGris();
	 }

	 public void pyramidal(){
			int [][]tr=new int[height][width];
			int [][]tg=new int[height][width];
			int [][]tb=new int[height][width];
			int [][]t1=new int[height][width];
			int [][]t2=new int[height][width];
			int [][]t3=new int[height][width];
			
		    for (int y=0; y<height;y++){
		    	for (int x=0; x<width;x++) {
			    	tr[y][x]=0;
			    	tg[y][x]=0;
			    	tb[y][x]=0;
			    }
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++){
			    	getRGB(x,y);
			    	t1[y][x]=rgb[0];
			    	t2[y][x]=rgb[1];
			    	t3[y][x]=rgb[2];
			    }
			}
			for (int y = 2; y < height - 2; y++) {
				for (int x = 2; x < width - 2; x++) {
					tr[y][x] = (1*t1[y-2][x-2]+2*t1[y-1][x-2]+3*t1[y][x-2]+2*t1[y+1][x-2]+1*t1[y+2][x-2]+2*t1[y-2][x-1]+4*t1[y-1][x-1]+6*t1[y][x-1]+4*t1[y+1][x-1]+2*t1[y+2][x-1]+3*t1[y-2][x]+6*t1[y-1][x]+9*t1[y][x]+6*t1[y+1][x]+3*t1[y+2][x]+2*t1[y-2][x+1]+4*t1[y-1][x+1]+6*t1[y][x+1]+4*t1[y+1][x+1]+2*t1[y+2][x+1]+1*t1[y-2][x+2]+2*t1[y-1][x+2]+3*t1[y][x+2]+2*t1[y+1][x+2]+1*t1[y+2][x+2])/81;
					tg[y][x] = (1*t2[y-2][x-2]+2*t2[y-1][x-2]+3*t2[y][x-2]+2*t2[y+1][x-2]+1*t2[y+2][x-2]+2*t2[y-2][x-1]+4*t2[y-1][x-1]+6*t2[y][x-1]+4*t2[y+1][x-1]+2*t2[y+2][x-1]+3*t2[y-2][x]+6*t2[y-1][x]+9*t2[y][x]+6*t2[y+1][x]+3*t2[y+2][x]+2*t2[y-2][x+1]+4*t2[y-1][x+1]+6*t2[y][x+1]+4*t2[y+1][x+1]+2*t2[y+2][x+1]+1*t2[y-2][x+2]+2*t2[y-1][x+2]+3*t2[y][x+2]+2*t2[y+1][x+2]+1*t2[y+2][x+2])/81;
					tb[y][x] = (1*t3[y-2][x-2]+2*t3[y-1][x-2]+3*t3[y][x-2]+2*t3[y+1][x-2]+1*t3[y+2][x-2]+2*t3[y-2][x-1]+4*t3[y-1][x-1]+6*t3[y][x-1]+4*t3[y+1][x-1]+2*t3[y+2][x-1]+3*t3[y-2][x]+6*t3[y-1][x]+9*t3[y][x]+6*t3[y+1][x]+3*t3[y+2][x]+2*t3[y-2][x+1]+4*t3[y-1][x+1]+6*t3[y][x+1]+4*t3[y+1][x+1]+2*t3[y+2][x+1]+1*t3[y-2][x+2]+2*t3[y-1][x+2]+3*t3[y][x+2]+2*t3[y+1][x+2]+1*t3[y+2][x+2])/81;
				}
				
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++) {
					
					rgb[0]=tr[y][x];
					rgb[1]=tg[y][x];
					rgb[2]=tb[y][x];
					setRGB(x,y);
			    }
			}		
			updateBufferedImage();
			//NiveauDeGris();
	 }

	 public void conique(){
			int [][]tr=new int[height][width];
			int [][]tg=new int[height][width];
			int [][]tb=new int[height][width];
			int [][]t1=new int[height][width];
			int [][]t2=new int[height][width];
			int [][]t3=new int[height][width];
			
		    for (int y=0; y<height;y++){
		    	for (int x=0; x<width;x++) {
			    	tr[y][x]=0;
			    	tg[y][x]=0;
			    	tb[y][x]=0;
			    }
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++){
			    	getRGB(x,y);
			    	t1[y][x]=rgb[0];
			    	t2[y][x]=rgb[1];
			    	t3[y][x]=rgb[2];
			    }
			}
			for (int y = 2; y < height - 2; y++) {
				for (int x = 2; x < width - 2; x++) {
					tr[y][x] = (0*t1[y-2][x-2]+0*t1[y-1][x-2]+1*t1[y][x-2]+0*t1[y+1][x-2]+0*t1[y+2][x-2]+0*t1[y-2][x-1]+2*t1[y-1][x-1]+2*t1[y][x-1]+2*t1[y+1][x-1]+0*t1[y+2][x-1]+1*t1[y-2][x]+2*t1[y-1][x]+5*t1[y][x]+2*t1[y+1][x]+1*t1[y+2][x]+0*t1[y-2][x+1]+2*t1[y-1][x+1]+2*t1[y][x+1]+2*t1[y+1][x+1]+0*t1[y+2][x+1]+0*t1[y-2][x+2]+0*t1[y-1][x+2]+1*t1[y][x+2]+0*t1[y+1][x+2]+0*t1[y+2][x+2])/25;
					tg[y][x] = (0*t2[y-2][x-2]+0*t2[y-1][x-2]+1*t2[y][x-2]+0*t2[y+1][x-2]+0*t2[y+2][x-2]+0*t2[y-2][x-1]+2*t2[y-1][x-1]+2*t2[y][x-1]+2*t2[y+1][x-1]+0*t2[y+2][x-1]+1*t2[y-2][x]+2*t2[y-1][x]+5*t2[y][x]+2*t2[y+1][x]+1*t2[y+2][x]+0*t2[y-2][x+1]+2*t2[y-1][x+1]+2*t2[y][x+1]+2*t2[y+1][x+1]+0*t2[y+2][x+1]+0*t2[y-2][x+2]+0*t2[y-1][x+2]+1*t2[y][x+2]+0*t2[y+1][x+2]+0*t2[y+2][x+2])/25;
					tb[y][x] = (0*t3[y-2][x-2]+0*t3[y-1][x-2]+1*t3[y][x-2]+0*t3[y+1][x-2]+0*t3[y+2][x-2]+0*t3[y-2][x-1]+2*t3[y-1][x-1]+2*t3[y][x-1]+2*t3[y+1][x-1]+0*t3[y+2][x-1]+1*t3[y-2][x]+2*t3[y-1][x]+5*t3[y][x]+2*t3[y+1][x]+1*t3[y+2][x]+0*t3[y-2][x+1]+2*t3[y-1][x+1]+2*t3[y][x+1]+2*t3[y+1][x+1]+0*t3[y+2][x+1]+0*t3[y-2][x+2]+0*t3[y-1][x+2]+1*t3[y][x+2]+0*t3[y+1][x+2]+0*t3[y+2][x+2])/25;
				}
				
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++) {
					
					rgb[0]=tr[y][x];
					rgb[1]=tg[y][x];
					rgb[2]=tb[y][x];
					setRGB(x,y);
			    }
			}		
			updateBufferedImage();
			//NiveauDeGris();
	 }

	 public void Derivee () {
			
			int [][]tr=new int[width][height];
			int [][]tg=new int[width][height];
			int [][]tb=new int[width][height];
			int [][]t2=new int[width][height];
			int [][]t1=new int[width][height];
			int [][]t3=new int[width][height];
			
			
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++){
			    	tr[x][y]=0;
			    	tg[x][y]=0;
			    	tb[x][y]=0;
			    }
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++){
			    	getRGB(x,y);
			    	t1[x][y]=rgb[0];
			    	t2[x][y]=rgb[1];
			    	t3[x][y]=rgb[2];
			    }
			}
			
			for (int x=1; x<width-1;x++) {
			    for (int y=1; y<height-1;y++) {
			    	int derive_horiz=-t1[x][y-1]+t1[x][y+1];//  [ 1]
			    											//  [-1]
					int derive_vert=-t1[x-1][y]+t1[x+1][y];//[1 -1]
					tr[x][y]=(int)(Math.sqrt(Math.pow(derive_horiz,2)+Math.pow(derive_vert,2)));
					
					derive_horiz=-t2[x][y-1]+t2[x][y+1];
					derive_vert=-t2[x-1][y]+t2[x+1][y];
					tg[x][y]=(int)(Math.sqrt(Math.pow(derive_horiz,2)+Math.pow(derive_vert,2)));

					derive_horiz=-t3[x][y-1]+t3[x][y+1];
					derive_vert=-t3[x-1][y]+t3[x+1][y];
					tb[x][y]=(int)(Math.sqrt(Math.pow(derive_horiz,2)+Math.pow(derive_vert,2)));
				}
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++) {
					
					rgb[0]=tr[x][y];
					rgb[1]=tg[x][y];
					rgb[2]=tb[x][y];
					setRGB(x,y);
			    }
			}		
			updateBufferedImage();
			//NiveauDeGris();
		}
	 
	 public void Laplacien4 () {
			NiveauDeGris();
			int [][]tr=new int[width][height];
			int [][]t=new int[width][height];
			int [][]tb=new int[width][height];
			int [][]t1=new int[width][height];
			int [][]t2=new int[width][height];
			int [][]t3=new int[width][height];
		
			
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++){
			    	tr[x][y]=0;
			    	t[x][y]=0;
			    	tb[x][y]=0;
			    }
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++){
			    	getRGB(x,y);
			    	t1[x][y]=rgb[0];//soit le rouge ou vert ou bleu
			    	t2[x][y]=rgb[1];//soit le rouge ou vert ou bleu
			    	t3[x][y]=rgb[2];//soit le rouge ou vert ou bleu
			    }
			}
			/*[0  1  0]
			  [1 -4  1]
			  [0  1  0]*///en suppose que -4 est pour t2[x][y] 
			
			for (int x=1; x<width-1;x++) {
			    for (int y=1; y<height-1;y++) {
					tr[x][y]=-4*t1[x][y]+t1[x-1][y]+t1[x+1][y]+t1[x][y-1]+t1[x][y+1];
					t[x][y]=-4*t2[x][y]+t2[x-1][y]+t2[x+1][y]+t2[x][y-1]+t2[x][y+1];
					tb[x][y]=-4*t3[x][y]+t3[x-1][y]+t3[x+1][y]+t3[x][y-1]+t3[x][y+1];
				}
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++) {
					
					rgb[0]=tr[x][y];
					rgb[1]=t[x][y];
					rgb[2]=tb[x][y];
					setRGB(x,y);
			    }
			}
			updateBufferedImage();
			//NiveauDeGris();		
	 }

	 public void laplacien8(){
			int [][]tr=new int[height][width];
			int [][]tg=new int[height][width];
			int [][]tb=new int[height][width];
			int [][]t1=new int[height][width];
			int [][]t2=new int[height][width];
			int [][]t3=new int[height][width];
			
		    for (int y=0; y<height;y++){
		    	for (int x=0; x<width;x++) {
			    	tr[y][x]=0;
			    	tg[y][x]=0;
			    	tb[y][x]=0;
			    }
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++){
			    	getRGB(x,y);
			    	t1[y][x]=rgb[0];
			    	t2[y][x]=rgb[1];
			    	t3[y][x]=rgb[2];
			    }
			}
			for (int y = 1; y < height - 1; y++) {
				for (int x = 1; x < width - 1; x++) {
					tr[y][x] = (-1*t1[y-1][x-1]-1*t1[y][x-1]-1*t1[y+1][x-1]-1*t1[y-1][x]+8*t1[y][x]-1*t1[y+1][x]-1*t1[y-1][x+1]-1*t1[y][x+1]-1*t1[y+1][x+1]);
					tg[y][x] = (-1*t2[y-1][x-1]-1*t2[y][x-1]-1*t2[y+1][x-1]-1*t2[y-1][x]+8*t2[y][x]-1*t2[y+1][x]-1*t2[y-1][x+1]-1*t2[y][x+1]-1*t2[y+1][x+1]);
					tb[y][x] = (-1*t3[y-1][x-1]-1*t3[y][x-1]-1*t3[y+1][x-1]-1*t3[y-1][x]+8*t3[y][x]-1*t3[y+1][x]-1*t3[y-1][x+1]-1*t3[y][x+1]-1*t3[y+1][x+1]);
				}
				
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++) {
					
					rgb[0]=tr[y][x];
					rgb[1]=tg[y][x];
					rgb[2]=tb[y][x];
					setRGB(x,y);
			    }
			}		
			updateBufferedImage();
			//NiveauDeGris();
		 
	 }
	 
	 public void sobel(){
			int [][]tr=new int[height][width];
			int [][]tg=new int[height][width];
			int [][]tb=new int[height][width];
			int [][]t1=new int[height][width];
			int [][]t2=new int[height][width];
			int [][]t3=new int[height][width];
			
		    for (int y=0; y<height;y++){
		    	for (int x=0; x<width;x++) {
			    	tr[y][x]=0;
			    	tg[y][x]=0;
			    	tb[y][x]=0;
			    }
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++){
			    	getRGB(x,y);
			    	t1[y][x]=rgb[0];
			    	t2[y][x]=rgb[1];
			    	t3[y][x]=rgb[2];
			    }
			}
			for (int y = 1; y < height - 1; y++) {
				for (int x = 1; x < width - 1; x++) {
					int filtreHorisental,	filtreVertical;
					filtreHorisental = (-1*t1[y-1][x-1]-2*t1[y][x-1]-1*t1[y+1][x-1]+0*t1[y-1][x]+0*t1[y][x]+0*t1[y+1][x]+1*t1[y-1][x+1]+2*t1[y][x+1]+1*t1[y+1][x+1]);
					filtreVertical = (-1*t1[y-1][x-1]+0*t1[y][x-1]+1*t1[y+1][x-1]-2*t1[y-1][x]+0*t1[y][x]+2*t1[y+1][x]-1*t1[y-1][x+1]+0*t1[y][x+1]+1*t1[y+1][x+1]);
					tr[y][x] = Math.abs(filtreHorisental) + Math.abs(filtreVertical);
					
					filtreHorisental = (-1*t2[y-1][x-1]-2*t2[y][x-1]-1*t2[y+1][x-1]+0*t2[y-1][x]+0*t2[y][x]+0*t2[y+1][x]+1*t2[y-1][x+1]+2*t2[y][x+1]+1*t2[y+1][x+1]);
					filtreVertical = (-1*t2[y-1][x-1]+0*t2[y][x-1]+1*t2[y+1][x-1]-2*t2[y-1][x]+0*t2[y][x]+2*t2[y+1][x]-1*t2[y-1][x+1]+0*t2[y][x+1]+1*t2[y+1][x+1]);
					tg[y][x] = Math.abs(filtreHorisental) + Math.abs(filtreVertical);
					
					filtreHorisental = (-1*t3[y-1][x-1]-2*t3[y][x-1]-1*t3[y+1][x-1]+0*t3[y-1][x]+0*t3[y][x]+0*t3[y+1][x]+1*t3[y-1][x+1]+2*t3[y][x+1]+1*t3[y+1][x+1]);
					filtreVertical = (-1*t3[y-1][x-1]+0*t3[y][x-1]+1*t3[y+1][x-1]-2*t3[y-1][x]+0*t3[y][x]+2*t3[y+1][x]-1*t3[y-1][x+1]+0*t3[y][x+1]+1*t3[y+1][x+1]);
					tb[y][x] = Math.abs(filtreHorisental) + Math.abs(filtreVertical);
				}
				
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++) {
					
					rgb[0]=tr[y][x];
					rgb[1]=tg[y][x];
					rgb[2]=tb[y][x];
					setRGB(x,y);
			    }
			}		
			updateBufferedImage();
			//NiveauDeGris();
		 
	 }

	 public void prewitt(){
			int [][]tr=new int[height][width];
			int [][]tg=new int[height][width];
			int [][]tb=new int[height][width];
			int [][]t1=new int[height][width];
			int [][]t2=new int[height][width];
			int [][]t3=new int[height][width];
			
		    for (int y=0; y<height;y++){
		    	for (int x=0; x<width;x++) {
			    	tr[y][x]=0;
			    	tg[y][x]=0;
			    	tb[y][x]=0;
			    }
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++){
			    	getRGB(x,y);
			    	t1[y][x]=rgb[0];
			    	t2[y][x]=rgb[1];
			    	t3[y][x]=rgb[2];
			    }
			}
			for (int y = 1; y < height - 1; y++) {
				for (int x = 1; x < width - 1; x++) {
					int filtreHorisental,	filtreVertical;
					filtreHorisental = (-1*t1[y-1][x-1]+0*t1[y][x-1]+1*t1[y+1][x-1]-1*t1[y-1][x]+0*t1[y][x]+1*t1[y+1][x]-1*t1[y-1][x+1]+0*t1[y][x+1]+1*t1[y+1][x+1]);
					filtreVertical = (-1*t1[y-1][x-1]-1*t1[y][x-1]-1*t1[y+1][x-1]+0*t1[y-1][x]+0*t1[y][x]+0*t1[y+1][x]+1*t1[y-1][x+1]+1*t1[y][x+1]+1*t1[y+1][x+1]);
					tr[y][x] = Math.abs(filtreHorisental) + Math.abs(filtreVertical);
					
					filtreHorisental = (-1*t2[y-1][x-1]+0*t2[y][x-1]+1*t2[y+1][x-1]-1*t2[y-1][x]+0*t2[y][x]+1*t2[y+1][x]-1*t2[y-1][x+1]+0*t2[y][x+1]+1*t2[y+1][x+1]);
					filtreVertical = (-1*t2[y-1][x-1]-1*t2[y][x-1]-1*t2[y+1][x-1]+0*t2[y-1][x]+0*t2[y][x]+0*t2[y+1][x]+1*t2[y-1][x+1]+1*t2[y][x+1]+1*t2[y+1][x+1]);
					tg[y][x] = Math.abs(filtreHorisental) + Math.abs(filtreVertical);
					
					filtreHorisental = (-1*t3[y-1][x-1]+0*t3[y][x-1]+1*t3[y+1][x-1]-1*t3[y-1][x]+0*t3[y][x]+1*t3[y+1][x]-1*t3[y-1][x+1]+0*t3[y][x+1]+1*t3[y+1][x+1]);
					filtreVertical = (-1*t3[y-1][x-1]-1*t3[y][x-1]-1*t3[y+1][x-1]+0*t3[y-1][x]+0*t3[y][x]+0*t3[y+1][x]+1*t3[y-1][x+1]+1*t3[y][x+1]+1*t3[y+1][x+1]);
					tb[y][x] = Math.abs(filtreHorisental) + Math.abs(filtreVertical);
				}
				
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++) {
					
					rgb[0]=tr[y][x];
					rgb[1]=tg[y][x];
					rgb[2]=tb[y][x];
					setRGB(x,y);
			    }
			}		
			updateBufferedImage();
			//NiveauDeGris();
		 
	 }

	 public void gradient(){
			int [][]tr=new int[height][width];
			int [][]tg=new int[height][width];
			int [][]tb=new int[height][width];
			int [][]t1=new int[height][width];
			int [][]t2=new int[height][width];
			int [][]t3=new int[height][width];
			
		    for (int y=0; y<height;y++){
		    	for (int x=0; x<width;x++) {
			    	tr[y][x]=0;
			    	tg[y][x]=0;
			    	tb[y][x]=0;
			    }
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++){
			    	getRGB(x,y);
			    	t1[y][x]=rgb[0];
			    	t2[y][x]=rgb[1];
			    	t3[y][x]=rgb[2];
			    }
			}
			for (int y = 1; y < height - 1; y++) {
				for (int x = 1; x < width - 1; x++) {
					int filtreHorisental,	filtreVertical;
					/*filtreHorisental = (-1*t1[y-1][x-1]+0*t1[y][x-1]+1*t1[y+1][x-1]-2*t1[y-1][x]+0*t1[y][x]+2*t1[y+1][x]-1*t1[y-1][x+1]+0*t1[y][x+1]+1*t1[y+1][x+1]);
					filtreVertical = (-1*t1[y-1][x-1]-2*t1[y][x-1]-1*t1[y+1][x-1]+0*t1[y-1][x]+0*t1[y][x]+0*t1[y+1][x]+1*t1[y-1][x+1]+2*t1[y][x+1]+1*t1[y+1][x+1]);
					tr[y][x] = Math.abs(filtreHorisental) + Math.abs(filtreVertical);
					
					filtreHorisental = (-1*t2[y-1][x-1]+0*t2[y][x-1]+1*t2[y+1][x-1]-2*t2[y-1][x]+0*t2[y][x]+2*t2[y+1][x]-1*t2[y-1][x+1]+0*t2[y][x+1]+1*t2[y+1][x+1]);
					filtreVertical = (-1*t2[y-1][x-1]-2*t2[y][x-1]-1*t2[y+1][x-1]+0*t2[y-1][x]+0*t2[y][x]+0*t2[y+1][x]+1*t2[y-1][x+1]+2*t2[y][x+1]+1*t2[y+1][x+1]);
					tg[y][x] = Math.abs(filtreHorisental) + Math.abs(filtreVertical);
					
					filtreHorisental = (-1*t3[y-1][x-1]+0*t3[y][x-1]+1*t3[y+1][x-1]-2*t3[y-1][x]+0*t3[y][x]+2*t3[y+1][x]-1*t3[y-1][x+1]+0*t3[y][x+1]+1*t3[y+1][x+1]);
					filtreVertical = (-1*t3[y-1][x-1]-2*t3[y][x-1]-1*t3[y+1][x-1]+0*t3[y-1][x]+0*t3[y][x]+0*t3[y+1][x]+1*t3[y-1][x+1]+2*t3[y][x+1]+1*t3[y+1][x+1]);
					tb[y][x] = Math.abs(filtreHorisental) + Math.abs(filtreVertical);
					*/
					filtreHorisental = -1*t1[y][x]+1*t1[y][x+1];
					filtreVertical = -1*t1[y][x]+1*t1[y+1][x]; 
					tr[y][x] = Math.abs(filtreHorisental) + Math.abs(filtreVertical);
					//tr[x][y]=(int)(Math.sqrt(Math.pow(filtreHorisental,2)+Math.pow(filtreVertical,2)));
					
					filtreHorisental = -1*t2[y][x]+1*t2[y][x+1];
					filtreVertical = -1*t2[y][x]+1*t2[y+1][x];
					tg[y][x] = Math.abs(filtreHorisental) + Math.abs(filtreVertical);
					//tg[x][y]=(int)(Math.sqrt(Math.pow(filtreHorisental,2)+Math.pow(filtreVertical,2)));
					
					filtreHorisental = -1*t3[y][x]+1*t3[y][x+1];
					filtreVertical = -1*t3[y][x]+1*t3[y+1][x];
					tb[y][x] = Math.abs(filtreHorisental) + Math.abs(filtreVertical);
					//tb[x][y]=(int)(Math.sqrt(Math.pow(filtreHorisental,2)+Math.pow(filtreVertical,2)));
				}
				
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++) {
					
					rgb[0]=tr[y][x];
					rgb[1]=tg[y][x];
					rgb[2]=tb[y][x];
					setRGB(x,y);
			    }
			}		
			updateBufferedImage();
			//NiveauDeGris();
		 
	 }

	 public void trierTableau (int t[]){
		 int temp;
		 for (int i = 0; i < t.length - 1; i++) {
			for (int j = i+1; j < t.length; j++) {
				if(t[i]>t[j]){
					temp = t[i];
					t[i] = t[j];
					t[j] = temp;
				}
			}
		}
	 }

	 public void Mediane () {
			
			int [][]tr=new int[width][height];
			int [][]tg=new int[width][height];
			int [][]tb=new int[width][height];
			int [][]t1=new int[width][height];
			int [][]t2=new int[width][height];
			int [][]t3=new int[width][height];
			
			
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++){
			    	tr[x][y]=0;
			    	tg[x][y]=0;
			    	tb[x][y]=0;
			    }
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++){
			    	getRGB(x,y);
			    	t1[x][y]=rgb[0];
			    	t2[x][y]=rgb[1];
			    	t3[x][y]=rgb[2];
			    }
			}
			
			for (int x=1; x<width-1;x++) {
			    for (int y=1; y<height-1;y++) {
			    	int tab1[] = new int[9];
			    	int tab2[] = new int[9];
			    	int tab3[] = new int[9];
			    	//***********
			    	int l = 0;
			    	for (int i = x-1; i <= x+1; i++) {
			    		for (int j = y-1; j <= y+1; j++) {
							tab1[l] = t1[i][j];
							tab2[l] = t2[i][j];
							tab3[l] = t3[i][j];
							l++;
						}
						
					}
			    	trierTableau(tab1);
			    	trierTableau(tab2);
			    	trierTableau(tab3);
			    	
			   		tr[x][y] = tab1[4];//on remplace la valeur centrale par le median de notre tableau trié
			   		tg[x][y] = tab2[4];//on remplace la valeur centrale par le median de notre tableau trié
			   		tb[x][y] = tab3[4];//on remplace la valeur centrale par le median de notre tableau trié
				}
			}
			for (int x=0; x<width;x++) {
			    for (int y=0; y<height;y++) {
					
					rgb[0]=tr[x][y];
					rgb[1]=tg[x][y];
					rgb[2]=tb[x][y];
					setRGB(x,y);
			    }
			}		
			updateBufferedImage();
			//NiveauDeGris();
		}

	 //*********************************
	 public Point [] histograme(){
		 int[] histogrameNG = new int[256];
		 Point[] p = new Point[256];
		 int dataIntRGB[] = new int[data.length];
		 for (int w = 0; w < width; w++) {
			for (int h = 0; h < height; h++) {
				getRGB(w, h);
				for (int i = 0; i < rgb.length; i++) {
					dataIntRGB[h * width + w] += rgb[i];
				}
				dataIntRGB[h * width + w] = (int)dataIntRGB[h * width + w]/3;
			}
		}
		 for (int i = 0; i < dataIntRGB.length; i++) {
			histogrameNG[dataIntRGB[i]]++;
		}
		 for(int i = 0;i<histogrameNG.length;i++){
			 p[i] = new Point(i, histogrameNG[i]);
		 }
		 return p;
	 }

}
