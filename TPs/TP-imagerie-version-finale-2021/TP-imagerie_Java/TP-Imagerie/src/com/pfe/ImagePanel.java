package com.pfe;
import java.awt.*;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.swing.JOptionPane;
import javax.swing.JPanel;


public class ImagePanel extends JPanel{
	private BufferedImage bufImage;
	public  ImageToRGBArray array;
	private Dimension dimension;
	private ImageFrame motherFrame;
	
	public ImagePanel(ImageFrame motherFrame) {
		super();
		this.motherFrame = motherFrame;
		dimension = getSize();
	}
	
	public void paint(Graphics g){
		g.setColor(Color.white);
		dimension.setSize(1200,800);
		g.fillRect(0,0,dimension.width,dimension.height);
		g.drawImage(bufImage,0,0,this);	
	}
/****************  Overrides ****************************/
	public Dimension getMinimumSize() {
		if(bufImage == null) return new Dimension(350, 433);
		else return new Dimension( ( bufImage.getWidth(this)>350?bufImage.getWidth(this):350), bufImage.getHeight(this));
	}
	public Dimension getPreferredSize() { return getMinimumSize(); }
	public Dimension getMaximumSize() { return getMinimumSize(); }
/**************************************************************/

	public void load(String fullPath){
		try {
			Image img = motherFrame.getToolkit().createImage(fullPath);
		
			MediaTracker tracker = new MediaTracker(this);
			tracker.addImage(img, 0);
			tracker.waitForID(0); 
			
			int iw = img.getWidth(this);
			int ih = img.getHeight(this);
			motherFrame.getToolkit().prepareImage(img, iw, ih, this);
			
			//System.out.println("image = "+fullPath+"   width = "+iw + "   height = "+ih);
			
			bufImage = new BufferedImage(iw, ih, BufferedImage.TYPE_INT_RGB);
			Graphics gOffscreen = bufImage.createGraphics();
			gOffscreen.drawImage(img,0,0,this);
			///
			array = new ImageToRGBArray(bufImage, this);
			repaint();
			motherFrame.setSize(bufImage.getWidth(this)+50,bufImage.getHeight(this)+50);  
			// un pack() va etre necessaire pour tenir bien compte du changement de taille
			motherFrame.pack();
			motherFrame.setTitle(fullPath);
			/////
		}
		catch ( Exception e ) {
			//System.out.println("\nERREUR de chargement de l'image "+fullPath);
			//System.out.println("JPG ou GIF(?)\n");
			JOptionPane.showMessageDialog(this,"Les extentions autorisées sont:\n \".JPG\" ,\".PNG\"..." , "ERREUR de chargement de l'image", JOptionPane.WARNING_MESSAGE);
			//e.printStackTrace();
			//System.exit(-1);
		}

	}

	
	//******************************
	public BufferedImage enregistrer(){
		int width  = bufImage.getWidth();
		int height = bufImage.getHeight();
		BufferedImage image = new BufferedImage(width, height,  BufferedImage.TYPE_INT_RGB);
		Graphics2D g = image.createGraphics();

		this.paintAll(g);
		g.dispose();
		return image;
	}
	
	public void enregistrerImage(String fileName){
		File fichierImage = new File(fileName);
		String format ="JPG";
		BufferedImage image = enregistrer();
		try {
			ImageIO.write(image, format, fichierImage);
		} catch (IOException e) {
			e.printStackTrace();
		}

	}
//******************************

}
