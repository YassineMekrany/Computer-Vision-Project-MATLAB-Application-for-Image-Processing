package com.pfe;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JToolBar;

public class BarreOutils extends JPanel implements ActionListener{
	private ImageFrame motherFrame;
	private ButtonBarreOutils ouvrir;
	private ButtonBarreOutils enregistrer;
	private ButtonBarreOutils bUndo;
	private ButtonBarreOutils invereser;
	private ButtonBarreOutils bPoivreSel;
	private ButtonBarreOutils bLaplacien4;
	private ButtonBarreOutils bLaplacien8;
	private ButtonBarreOutils bSobel;
	private ButtonBarreOutils bPrewitt;
	private ButtonBarreOutils bGradient;
	private ButtonBarreOutils bRobert;
	private ButtonBarreOutils bMoyenneur3;
	private ButtonBarreOutils bMoyenneur5;
	private ButtonBarreOutils bMediane;
	private ButtonBarreOutils bPyramidal;
	private ButtonBarreOutils bConque;
	private ButtonBarreOutils bBinomialGaussien3;
	private ButtonBarreOutils bGaussienBinomial5;
	
	private JToolBar fichierToolBar;
	private JToolBar bruitToolBar;
	private JToolBar filtrePassHautToolBar;
	private JToolBar filtrePassBasToolBar;
	private JToolBar elementaireToolBar;
	
	public BarreOutils(ImageFrame motherFrame) {
		// TODO Auto-generated constructor stub
		this.motherFrame = motherFrame;
		ouvrir = new ButtonBarreOutils(new ImageIcon("resources/fileopen.png"), new ImageIcon("resources/fileopen2.png"), "Ouvrir une image (ctrl+O)");
		ouvrir.addActionListener(this);
		
		enregistrer = new ButtonBarreOutils(new ImageIcon("resources/filesave.png"), new ImageIcon("resources/filesaveas.png"), "Enregistrer sous...(ctrl+S)");
		enregistrer.addActionListener(this);
		
		bUndo = new ButtonBarreOutils(new ImageIcon("resources/undo.png"), new ImageIcon("resources/undo.png"), "Retour à l'image originale (ctrl+Z)");
		bUndo.addActionListener(this);
		
		invereser =  new ButtonBarreOutils(new ImageIcon("resources/inverser1.jpg"), new ImageIcon("resources/inverser2.jpg"), "Inverser les couleurs");
		invereser.addActionListener(this);
		
		bPoivreSel = new ButtonBarreOutils(new ImageIcon("resources/poivre_sel_1.JPG"), new ImageIcon("resources/poivre_sel_2.JPG"), "Ajouter un Bruit Poivre et Sel");
		bPoivreSel.addActionListener(this);
		
		bLaplacien4 =  new ButtonBarreOutils(new ImageIcon("resources/laplacien4_1.jpg"), new ImageIcon("resources/laplacien4_2.jpg"), "Laplacien de connexité 4 (ctrl+4)");
		bLaplacien4.addActionListener(this);
		
		bLaplacien8 = new ButtonBarreOutils(new ImageIcon("resources/laplacien8_1.jpg"), new ImageIcon("resources/laplacien8_2.jpg"), "Laplacien de connexité 8 (ctrl+8)");
		bLaplacien8.addActionListener(this);
		
		bSobel = new ButtonBarreOutils(new ImageIcon("resources/sobel_1.JPG"), new ImageIcon("resources/sobel_2.JPG"),"Filtre de Sobel");
		bSobel.addActionListener(this);
		
		bPrewitt = new ButtonBarreOutils(new ImageIcon("resources/prewitt_1.JPG"), new ImageIcon("resources/prewitt_2.JPG"),"Filtre de Prewitt");
		bPrewitt.addActionListener(this);

		bGradient = new ButtonBarreOutils(new ImageIcon("resources/gradient_1.JPG"), new ImageIcon("resources/gradient_2.JPG"),"Filtre de Gradient");
		bGradient.addActionListener(this);
		
		bRobert = new ButtonBarreOutils(new ImageIcon("resources/Robert_1.JPG"), new ImageIcon("resources/Robert_2.JPG"), "Filtre Robert");
		bRobert.addActionListener(this);
		
		bMoyenneur3 = new ButtonBarreOutils(new ImageIcon("resources/Moyenneur3_1.JPG"), new ImageIcon("resources/Moyenneur3_2.JPG") , "Filtre Moyenneur 3*3");
		bMoyenneur3.addActionListener(this);
		
		bMoyenneur5 = new ButtonBarreOutils(new ImageIcon("resources/Moyenneur5_1.JPG"), new ImageIcon("resources/Moyenneur5_2.JPG") , "Filtre Moyenneur 5*5");
		bMoyenneur5.addActionListener(this);
		
		bMediane = new ButtonBarreOutils(new ImageIcon("resources/Medyanne_1.JPG"), new ImageIcon("resources/Medyanne_2.JPG") , "Filtre Mediane");
		bMediane.addActionListener(this);
		
		bBinomialGaussien3 = new ButtonBarreOutils(new ImageIcon("resources/binomialGaussien3_1.JPG"), new ImageIcon("resources/binomialGaussien3_2.JPG") , "Filtre Binomial Gaussien 3*3");
		bBinomialGaussien3.addActionListener(this);
		
		bGaussienBinomial5 = new ButtonBarreOutils(new ImageIcon("resources/GaussienBinomyal5_1.JPG"), new ImageIcon("resources/GaussienBinomyal5_2.JPG") , "Filtre Gaussien ou binomial 5*5");
		bGaussienBinomial5.addActionListener(this);
		
		bPyramidal = new ButtonBarreOutils(new ImageIcon("resources/Pyramidal_1.JPG"), new ImageIcon("resources/Pyramidal_2.JPG") , "Filtre Pyramidal");
		bPyramidal.addActionListener(this);
		
		bConque = new ButtonBarreOutils(new ImageIcon("resources/Conique_1.JPG"), new ImageIcon("resources/Conique_2.JPG") , "Filtre Conique");
		bConque.addActionListener(this);
		
		setLayout(new FlowLayout(FlowLayout.LEFT));
		toolBarFichier();
		toolBarelementaire();
		toolBarBruit();
		toolBarFiltrePassBas();
		toolBarFiltrePassHaut();
	}
	@Override
	public void actionPerformed(ActionEvent e) {
		// TODO Auto-generated method stub
		if(e.getSource() == ouvrir){
			if(motherFrame.histogrammeIsNotNull()) motherFrame.remove(motherFrame.getGp());
			motherFrame.loadImage();
			motherFrame.pack();
		}
		else if(e.getSource() == enregistrer){
			if(motherFrame.imageIsNotNull()){
				motherFrame.saveImage();
			}
			else JOptionPane.showMessageDialog(this, "Pas d'image à enregistrer !!!...", "Erreur d'enregistrement", JOptionPane.WARNING_MESSAGE,new ImageIcon("resources/icon_warning_32x.gif"));
		}
		else if(e.getSource() == bUndo){
			if(motherFrame.imageIsNotNull()){
				motherFrame.undo();
			}
			else JOptionPane.showMessageDialog(this, "Pas d'image originale", "Erreur (retour à l'image originale)", JOptionPane.WARNING_MESSAGE,new ImageIcon("resources/icon_warning_32x.gif"));
		}
		else if(e.getSource() == invereser){
			if(motherFrame.imageIsNotNull()){
				motherFrame.inverserCouleur();
			}
			else JOptionPane.showMessageDialog(this, "Pas d'image à  inverser !!!...", "Erreur d'inversement", JOptionPane.WARNING_MESSAGE,new ImageIcon("resources/icon_warning_32x.gif"));
		}
		else if(e.getSource() == bPoivreSel){
			if(motherFrame.imageIsNotNull()){
				motherFrame.bruitPoivreSel();
			}
			else JOptionPane.showMessageDialog(this, "L'image n'est pas encore chargeé !!!...", "Erreur (Bruit poivre et sel)", JOptionPane.WARNING_MESSAGE,new ImageIcon("resources/icon_warning_32x.gif"));
		}
		else if(e.getSource() == bLaplacien4){
			if(motherFrame.imageIsNotNull()){
				motherFrame.laplacien4();
			}
			else JOptionPane.showMessageDialog(this, "L'image n'est pas encore chargeé !!!...", "Erreur (Filtre de Laplacien 4)", JOptionPane.WARNING_MESSAGE,new ImageIcon("resources/icon_warning_32x.gif"));
		}
		else if(e.getSource() == bLaplacien8){
			if(motherFrame.imageIsNotNull()){
				motherFrame.laplacien8();
			}
			else JOptionPane.showMessageDialog(this, "L'image n'est pas encore chargeé !!!...", "Erreur (Filtre de Laplacien 8)", JOptionPane.WARNING_MESSAGE,new ImageIcon("resources/icon_warning_32x.gif"));
		}
		else if(e.getSource() == bSobel){
			if(motherFrame.imageIsNotNull()){
				motherFrame.sobel();
			}
			else JOptionPane.showMessageDialog(this, "L'image n'est pas encore chargeé !!!...", "Erreur (Filtre de Sobel)", JOptionPane.WARNING_MESSAGE,new ImageIcon("resources/icon_warning_32x.gif"));
		}
		else if(e.getSource() == bPrewitt){
			if(motherFrame.imageIsNotNull()){
				motherFrame.prewitt();
			}
			else JOptionPane.showMessageDialog(this, "L'image n'est pas encore chargeé !!!...", "Erreur (Filtre de Prewitt)", JOptionPane.WARNING_MESSAGE,new ImageIcon("resources/icon_warning_32x.gif"));
		}
		else if(e.getSource() == bGradient){
			if(motherFrame.imageIsNotNull()){
				motherFrame.gradient();
			}
			else JOptionPane.showMessageDialog(this, "L'image n'est pas encore chargeé !!!...", "Erreur (Filtre de Gradient)", JOptionPane.WARNING_MESSAGE,new ImageIcon("resources/icon_warning_32x.gif"));
		}
		else if(e.getSource() == bRobert){
			if(motherFrame.imageIsNotNull()){
				motherFrame.derivée();
			}
			else JOptionPane.showMessageDialog(this, "L'image n'est pas encore chargeé !!!...", "Erreur (Filtre de Robert)", JOptionPane.WARNING_MESSAGE,new ImageIcon("resources/icon_warning_32x.gif"));
		}
		else if(e.getSource() == bMoyenneur3){
			if(motherFrame.imageIsNotNull()){
				motherFrame.moyenneur3_3();
			}
			else JOptionPane.showMessageDialog(this, "L'image n'est pas encore chargeé !!!...", "Erreur (Filtre Moyenneur 3*3)", JOptionPane.WARNING_MESSAGE,new ImageIcon("resources/icon_warning_32x.gif"));
		}
		else if(e.getSource() == bMoyenneur5){
			if(motherFrame.imageIsNotNull()){
				motherFrame.moyenneur5_5();
			}
			else JOptionPane.showMessageDialog(this, "L'image n'est pas encore chargeé !!!...", "Erreur (Filtre Moyenneur 5*5)", JOptionPane.WARNING_MESSAGE,new ImageIcon("resources/icon_warning_32x.gif"));
		}
		else if(e.getSource() == bMediane){
			if(motherFrame.imageIsNotNull()){
				motherFrame.mediane();
			}
			else JOptionPane.showMessageDialog(this, "L'image n'est pas encore chargeé !!!...", "Erreur (Filtre Mediane)", JOptionPane.WARNING_MESSAGE,new ImageIcon("resources/icon_warning_32x.gif"));
		}
		else if(e.getSource() == bBinomialGaussien3){
			if(motherFrame.imageIsNotNull()){
				motherFrame.binomialGaussien3_3();
			}
			else JOptionPane.showMessageDialog(this, "L'image n'est pas encore chargeé !!!...", "Erreur (Filtre Binomial Gaussien 3*3)", JOptionPane.WARNING_MESSAGE,new ImageIcon("resources/icon_warning_32x.gif"));
		}
		else if(e.getSource() == bGaussienBinomial5){
			if(motherFrame.imageIsNotNull()){
				motherFrame.gaussienOuBinomial();
			}
			else JOptionPane.showMessageDialog(this, "L'image n'est pas encore chargeé !!!...", "Erreur (Filtre Gaussien ou Binomial 5*5)", JOptionPane.WARNING_MESSAGE,new ImageIcon("resources/icon_warning_32x.gif"));
		}
		else if(e.getSource() == bPyramidal){
			if(motherFrame.imageIsNotNull()){
				motherFrame.pyramidal();
			}
			else JOptionPane.showMessageDialog(this, "L'image n'est pas encore chargeé !!!...", "Erreur (Filtre Pyramidal)", JOptionPane.WARNING_MESSAGE,new ImageIcon("resources/icon_warning_32x.gif"));
		}
		else if(e.getSource() == bConque){
			if(motherFrame.imageIsNotNull()){
				motherFrame.conique();
			}
			else JOptionPane.showMessageDialog(this, "L'image n'est pas encore chargeé !!!...", "Erreur (Filtre Conique)", JOptionPane.WARNING_MESSAGE,new ImageIcon("resources/icon_warning_32x.gif"));
		}
	}
	
	public void toolBarFichier (){
		fichierToolBar = new JToolBar("Barre d'outils du fichier", JToolBar.HORIZONTAL);
		fichierToolBar.add(ouvrir);	fichierToolBar.addSeparator(new Dimension(3, 22));
		fichierToolBar.add(enregistrer);	//fichierToolBar.addSeparator();
		add(fichierToolBar);
	}
	public void toolBarBruit (){
		bruitToolBar = new JToolBar("Outils des bruits", JToolBar.HORIZONTAL);
		bruitToolBar.add(bPoivreSel);bruitToolBar.addSeparator(new Dimension(3, 22));
		add(bruitToolBar);
	}
	public void toolBarFiltrePassHaut (){
		filtrePassHautToolBar = new JToolBar("Outils des Filtres Pass Haut", JToolBar.HORIZONTAL);
		filtrePassHautToolBar.add(bLaplacien4);	filtrePassHautToolBar.addSeparator(new Dimension(3, 22));
		filtrePassHautToolBar.add(bLaplacien8);	filtrePassHautToolBar.addSeparator(new Dimension(3, 22));
		filtrePassHautToolBar.add(bSobel);	filtrePassHautToolBar.addSeparator(new Dimension(3, 22));
		filtrePassHautToolBar.add(bPrewitt);	filtrePassHautToolBar.addSeparator(new Dimension(3, 22));
		filtrePassHautToolBar.add(bGradient);	filtrePassHautToolBar.addSeparator(new Dimension(3, 22));
		filtrePassHautToolBar.add(bRobert);
		add(filtrePassHautToolBar);
	}
	public void toolBarFiltrePassBas (){
		filtrePassBasToolBar = new JToolBar("Outils des Filtres Pass Bas", JToolBar.HORIZONTAL);
		filtrePassBasToolBar.add(bMoyenneur3);	filtrePassBasToolBar.addSeparator(new Dimension(3, 22));
		filtrePassBasToolBar.add(bMoyenneur5);	filtrePassBasToolBar.addSeparator(new Dimension(3, 22));
		filtrePassBasToolBar.add(bMediane);	filtrePassBasToolBar.addSeparator(new Dimension(3, 22));
		filtrePassBasToolBar.add(bBinomialGaussien3);	filtrePassBasToolBar.addSeparator(new Dimension(3, 22));
		filtrePassBasToolBar.add(bGaussienBinomial5);	filtrePassBasToolBar.addSeparator(new Dimension(3, 22));
		filtrePassBasToolBar.add(bPyramidal);	filtrePassBasToolBar.addSeparator(new Dimension(3, 22));
		filtrePassBasToolBar.add(bConque);
		add(filtrePassBasToolBar);
	}
	public void toolBarelementaire (){
		elementaireToolBar = new JToolBar("Outils elementaires", JToolBar.HORIZONTAL);
		elementaireToolBar.add(bUndo);	elementaireToolBar.addSeparator(new Dimension(3, 22));
		elementaireToolBar.add(invereser);
		add(elementaireToolBar);
	}

}
