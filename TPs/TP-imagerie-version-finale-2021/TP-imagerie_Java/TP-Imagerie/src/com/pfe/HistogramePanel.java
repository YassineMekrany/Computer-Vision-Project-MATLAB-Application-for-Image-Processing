package com.pfe;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Point;

import javax.swing.BorderFactory;
import javax.swing.JPanel;

public class HistogramePanel extends JPanel {
	private int y0;
	private Point data[];
	public static int margeGauche = 25;
	public static int margeBas = 50;
	
	public HistogramePanel(Point data[]) {
		setBackground(Color.white);
		this.data = data;
		//
		setBorder(BorderFactory.createLineBorder(Color.red));
		//
	}
	
	protected void paintComponent(Graphics g) {
		super.paintComponent(g);
		
		//g.drawLine(0, 0, 100, 100);
		// Axe des X :
		y0 = getHeight()/2;
		y0 += y0 -margeBas;
		g.setColor(Color.blue);
		//dessiner l'axe des ordonnés
		g.drawLine(margeGauche, 0, margeGauche, y0);
		//dessiner la lgne gauche du flechette de l'axe des ordonés
		g.drawLine(margeGauche, 0, margeGauche-3, 15);
		//dessiner la ligne droite du flechette de l'axe des ordonés
		g.drawLine(margeGauche, 0, margeGauche+3, 15);
		
		//dessiner l'axe des abscises x 
		g.drawLine(margeGauche, y0, getWidth(), y0);
		//desiner la ligne superieure de la flechette de l'axe des x
		g.drawLine(getWidth(), y0, getWidth() - 15, y0 - 3);
		//dessiner la linge inferieur de la flechette de l'axe des x
		g.drawLine(getWidth(), y0, getWidth() - 15, y0 + 3);
		//g.drawLine(0, 0, 0, getHeight()/2);
		
		double yMax = Max(data);
		double yScale = y0 / yMax;
		int YSCALE = (int)y0/10;
		
		// dessiner la courbe :
		//double yMax = Max(data);
		//double yScale = y0 / yMax;
		g.setColor(Color.cyan);
		for (int i = 0; i < data.length; i++) {
			g.drawLine(
					data[i].x+margeGauche, y0 , 
					data[i].x+margeGauche, y0 - (int)(yScale * data[i].y)
			);
		} 
		
		 g.setColor(Color.red);
		 int j =0;
			for (int i = y0; i > 0; i-=YSCALE) {
				g.drawLine(margeGauche - 5, i, margeGauche, i);
				g.drawString(""+(int)(j*YSCALE/yScale),margeGauche - 23 , i -2);
				j++;
			}
		 for (int i = margeGauche; i < getWidth(); i+=50) {
			g.drawLine(i, y0, i, y0+10);
			g.drawString(""+ (i-margeGauche) , i+2, y0+15);
		}
		 String s = "L'histogramme de niveaux de gris";
		 g.setColor(Color.blue);
		g.drawString(s,50, y0 + 35);
		
	}
	private double Max(Point[] t){
		double max= t[0].y;
		for (int i = 1; i < t.length; i++) {
			if(t[i].y>max){
				max = t[i].y;
			}
		}
		return max ;
	}
}
