package com.pfe;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FileDialog;
import java.awt.FlowLayout;
import java.awt.Graphics;
import java.awt.HeadlessException;
import java.awt.Menu;
import java.awt.MenuBar;
import java.awt.MenuItem;
import java.awt.MenuShortcut;
import java.awt.Panel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.lang.ref.PhantomReference;

import javax.imageio.ImageIO;
import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;

public class ImageFrame extends JFrame implements ActionListener{
	private String     imageFullPath; // le nom de l'image
	private ImagePanel imagePanel;
	//Dimension d;
	private ImagePanel imagePanelOriginale;
	private JPanel paneauImageOriginale;
	private JPanel paneauImageResultat;
	private JLabel labelImageOriginale;
	private JLabel labelImageResultat;
	HistogramePanel gp = null;
	
	MenuBar menuBar;
	MenuItem mLoad, mSaveAs, mExit;
	MenuItem mUndo;
	MenuItem mInverse;
	MenuItem mNiveauDeGris;
	MenuItem mBinarisationParSeuillage;
	MenuItem mRecadrage;
	MenuItem mBruitPoivreSel;
	MenuItem mDerive;
	MenuItem mLaplacien4;
	MenuItem mLaplacien8;
	MenuItem mSobel;
	MenuItem mPrewitt;
	MenuItem mGradient;
	MenuItem mMoyenneur3_3;
	MenuItem mMoyenneur5_5;
	MenuItem mBinomialGaussien3_3;
	MenuItem mGaussienOuBinomial;
	MenuItem mPyramidal;
	MenuItem mConique;
	MenuItem mMediane;
	MenuItem mAfficherHistogrammeNG;
	MenuItem mDeleteHistogrammeNG;
	
	Menu menuFichier, menuElementaires,menuBruit, menuFiltresLinéaires,menuFiltresNonLinéaires,menuHistogramme;
	
	
	
	
	public ImageFrame() throws HeadlessException {
		// TODO Auto-generated constructor stub
		super("Traitement d'image :");
		//d = getSize();
		menu();
		presntationInterface();
		add("North", new BarreOutils(this));
		setVisible(true);
		pack();
		
		setMinimumSize(new Dimension(600, getHeight()));
		setBounds(50, 50, getWidth(), getHeight());
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		menuEnable();
	}
/*	public void paint(Graphics g){
		
		g.setColor(Color.white);
		d.setSize(1200,800);
		g.fillRect(0,0,d.width,d.height);
		imagePanel.repaint();
	}*/
	
	private void presntationInterface(){
		imagePanelOriginale = new ImagePanel(this);
		JScrollPane spio = new JScrollPane(imagePanelOriginale);
		spio.setPreferredSize(new Dimension(350, 450));
		//spio.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
		//spio.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
		paneauImageOriginale = new JPanel();
		paneauImageOriginale.setLayout(new BorderLayout());
		paneauImageOriginale.setBorder(BorderFactory.createLineBorder(Color.red));
		paneauImageOriginale.add(BorderLayout.CENTER, spio);
		
		imagePanel = new ImagePanel(this);
		JScrollPane spir = new JScrollPane(imagePanel);
		spir.setPreferredSize(new Dimension(350, 450));
		paneauImageResultat = new JPanel();
		paneauImageResultat.setLayout(new BorderLayout());
		paneauImageResultat.setBorder(BorderFactory.createLineBorder(Color.red));
		paneauImageResultat.add(BorderLayout.CENTER, spir);
		
		
		labelImageOriginale = new JLabel("Image Originale", JLabel.CENTER);
		labelImageOriginale.setOpaque(true);labelImageOriginale.setEnabled(true);
		labelImageOriginale.setBackground(Color.pink);
		labelImageOriginale.setPreferredSize(new Dimension(350, 20));
		
		labelImageResultat = new JLabel("Image Traitée", JLabel.CENTER);
		labelImageResultat.setOpaque(true);labelImageResultat.setEnabled(true);
		labelImageResultat.setBackground(Color.pink);
		labelImageResultat.setPreferredSize(new Dimension(350, 20));
		
		JPanel centerPanelImage = new JPanel();
		centerPanelImage.setBorder(BorderFactory.createLineBorder(Color.blue));
		centerPanelImage.setLayout(new FlowLayout(FlowLayout.CENTER, 50, 5));
		centerPanelImage.add(paneauImageOriginale);
		centerPanelImage.add(paneauImageResultat);
		
		JPanel centerPanelLabel = new JPanel();
		centerPanelLabel.setBorder(BorderFactory.createLineBorder(Color.blue));
		centerPanelLabel.setLayout(new FlowLayout(FlowLayout.CENTER, 50, 5));
		centerPanelLabel.add(labelImageOriginale);
		centerPanelLabel.add(labelImageResultat);
		
		JPanel boxPanel = new JPanel();
		boxPanel.setLayout(new BoxLayout(boxPanel, BoxLayout.Y_AXIS));
		boxPanel.add(centerPanelImage);
		boxPanel.add(centerPanelLabel);
		
		JPanel centerPanel = new JPanel();
		centerPanel.setLayout(new FlowLayout(FlowLayout.CENTER));
		centerPanel.add(boxPanel);
		
		JPanel borderPanel = new JPanel();
		borderPanel.setLayout(new BorderLayout());
		borderPanel.add(BorderLayout.CENTER, centerPanel);
		
		setContentPane(borderPanel);
	}
	
	private void menu(){
		menuBar = new MenuBar();

		// menuFichier 
		    menuFichier = new Menu("Fichier");
		
		    mLoad = new MenuItem("Ouvrir",new MenuShortcut(KeyEvent.VK_O));
		    mLoad.addActionListener(this);	menuFichier.add(mLoad);
		    menuFichier.insertSeparator(1);
		    mSaveAs = new MenuItem("Enregistrer sous...",new MenuShortcut(KeyEvent.VK_S));
		    mSaveAs.addActionListener(this); menuFichier.add(mSaveAs);
		    menuFichier.insertSeparator(SOMEBITS);
		
		    mExit = new MenuItem("Quitter",new MenuShortcut(KeyEvent.VK_Q));
		    mExit.addActionListener(this); menuFichier.add(mExit);
		
		    menuBar.add(menuFichier);


		// menuElementaires
		
		    menuElementaires = new Menu("Elementaires");
		    
		    mUndo = new MenuItem("Retour à l'image originale", new MenuShortcut(KeyEvent.VK_Z));
		    mUndo.addActionListener(this);	menuElementaires.add(mUndo);
		    
		    mInverse = new MenuItem("Inversion des couleurs");
			mInverse.addActionListener(this);   menuElementaires.add(mInverse);
			menuElementaires.addSeparator();
			
			mNiveauDeGris = new MenuItem("Niveau de Gris");
			mNiveauDeGris.addActionListener(this);   menuElementaires.add(mNiveauDeGris);
			
			mBinarisationParSeuillage = new MenuItem("Binarisation par seuillage");
			mBinarisationParSeuillage.addActionListener(this);   menuElementaires.add(mBinarisationParSeuillage);
		
			mRecadrage = new MenuItem("Recadrage");
			mRecadrage.addActionListener(this);   menuElementaires.add(mRecadrage);
			menuBar.add(menuElementaires);
			
			//menuBruit
			
			menuBruit = new Menu("Bruit");
			
			mBruitPoivreSel = new MenuItem("Bruit Poivre et Sel");
			mBruitPoivreSel.addActionListener(this);	menuBruit.add(mBruitPoivreSel);
			menuBar.add(menuBruit);
			
			//menuFiltresLinéaires
			
			menuFiltresLinéaires = new Menu("Filtres linéaires");
			
			mMoyenneur3_3 = new MenuItem("Filtre Moyenneur 3*3");
			mMoyenneur3_3.addActionListener(this);   menuFiltresLinéaires.add(mMoyenneur3_3);
			
			mMoyenneur5_5 = new MenuItem("Filtre Moyenneur 5*5");
			mMoyenneur5_5.addActionListener(this);	menuFiltresLinéaires.add(mMoyenneur5_5);
			menuFiltresLinéaires.addSeparator();
			
			mBinomialGaussien3_3 = new MenuItem("Filtre Binomial Gaussien 3*3");
			mBinomialGaussien3_3.addActionListener(this);	menuFiltresLinéaires.add(mBinomialGaussien3_3);
			
			mGaussienOuBinomial = new MenuItem("Filtre Gaussien Ou Binomial");
			mGaussienOuBinomial.addActionListener(this);	menuFiltresLinéaires.add(mGaussienOuBinomial);
			
			mPyramidal = new MenuItem("Filtre Pyramidal");
			mPyramidal.addActionListener(this);	menuFiltresLinéaires.add(mPyramidal);
			
			mConique = new MenuItem("Filtre Conique");
			mConique.addActionListener(this);	menuFiltresLinéaires.add(mConique);
			menuFiltresLinéaires.addSeparator();
			
			mDerive = new MenuItem("Filtre dérivée Première: Robert");
			mDerive.addActionListener(this);   menuFiltresLinéaires.add(mDerive);
			
			mGradient = new MenuItem("Filtre de Gradient");
			mGradient.addActionListener(this);	menuFiltresLinéaires.add(mGradient);
			
			mSobel = new MenuItem("Filtre de Sobel");
			mSobel.addActionListener(this);   menuFiltresLinéaires.add(mSobel);
			
			mPrewitt = new MenuItem("Filtre de Prewitt");
			mPrewitt.addActionListener(this);   menuFiltresLinéaires.add(mPrewitt);
			
			menuFiltresLinéaires.addSeparator();
			
			mLaplacien4 = new MenuItem("Filtre Laplacien de connexité 4",new MenuShortcut(KeyEvent.VK_4));
			mLaplacien4.addActionListener(this);   menuFiltresLinéaires.add(mLaplacien4);
			
			mLaplacien8 = new MenuItem("Filtre Laplacien de connexité 8",new MenuShortcut(KeyEvent.VK_8));
			mLaplacien8.addActionListener(this);   menuFiltresLinéaires.add(mLaplacien8);
			
			menuBar.add(menuFiltresLinéaires);
		
			// menuFiltresNonLinéaires	
		    
		    menuFiltresNonLinéaires = new Menu("Filtres Non linéaires");
			mMediane = new MenuItem("Filtre Mediane",new MenuShortcut(KeyEvent.VK_M));
			mMediane.addActionListener(this);   menuFiltresNonLinéaires.add(mMediane);
			
			menuBar.add(menuFiltresNonLinéaires);
			
			// menuHistogramme
			
			menuHistogramme = new Menu("Histogramme");
			mAfficherHistogrammeNG = new MenuItem("Afficher l'histogramme de niveaux de gris");
			mAfficherHistogrammeNG.addActionListener(this);	menuHistogramme.add(mAfficherHistogrammeNG);
			
			mDeleteHistogrammeNG = new MenuItem("Effacer l'histogramme de niveaux de gris");
			mDeleteHistogrammeNG.addActionListener(this);	menuHistogramme.add(mDeleteHistogrammeNG);
			
			menuBar.add(menuHistogramme);
			
			setMenuBar(menuBar);

	}
	
	/*public void paint(Graphics g){
		
		g.setColor(Color.white);
		d.setSize(1200,800);
		g.fillRect(0,0,d.width,d.height);
		imagePanel.repaint();
	}*/
	
	private void menuEnable(){
		boolean enabled = true;
		if(imagePanel.array == null){
			enabled = false;
		}
		for (int i = 0; i < menuElementaires.getItemCount(); i++) {
			menuElementaires.getItem(i).setEnabled(enabled);
		}
		for (int i = 0; i < menuBruit.getItemCount(); i++) {
			menuBruit.getItem(i).setEnabled(enabled);
		}
		for (int i = 0; i < menuFiltresLinéaires.getItemCount(); i++) {
			menuFiltresLinéaires.getItem(i).setEnabled(enabled);
		}
		for (int i = 0; i < menuFiltresNonLinéaires.getItemCount(); i++) {
			menuFiltresNonLinéaires.getItem(i).setEnabled(enabled);
		}
		for (int i = 0; i < menuHistogramme.getItemCount(); i++) {
			menuHistogramme.getItem(i).setEnabled(enabled);
		}
		mSaveAs.setEnabled(enabled);
	}

	public void loadImage(){
		FileDialog fileDialog;
		String fileName,dirName;
		fileDialog = new FileDialog(this,"Load image :",FileDialog.LOAD);
		//fileDialog.show();  La methode show a etée remplacée par setVisible(boolean)
		fileDialog.setVisible(true);
		fileName = fileDialog.getFile();
		dirName  = fileDialog.getDirectory();
		if(fileName == null)
			//System.exit(-1);
			return;
		try{
		imageFullPath = dirName + System.getProperty("file.separator") + fileName;
		imagePanel.load(imageFullPath);
		imagePanelOriginale.load(imageFullPath);
		imagePanel.setPreferredSize(imagePanel.getPreferredSize());
		imagePanelOriginale.setPreferredSize(imagePanelOriginale.getPreferredSize());
	
		//setTitle("Image Manipulation - "+fileName);
		}
		catch (Exception e) {
			// TODO: handle exception
			JOptionPane.showMessageDialog(this,"Les extentions autorisées sont:\n \".JPG\" ,\".PNG\"..." , "ERREUR de chargement de l'image", JOptionPane.WARNING_MESSAGE);
		}
		menuEnable();
		repaint();
		pack();
	}

	public void saveImage(){
		//FileOutputStream fos;
		//BufferedOutputStream bufOut;
		FileDialog fileDialog;
		String fileName,dirName;
		fileDialog = new FileDialog(this,"Save As...",FileDialog.SAVE);
		//fileDialog.show();
		fileDialog.setVisible(true);
		fileName = fileDialog.getFile();
		dirName = fileDialog.getDirectory();
		if(fileName == null){
	        return;
	    }
		String fullPath = dirName + System.getProperty("file.separator") + fileName;	    
		//imagePanel.save(fullPath);
		imagePanel.enregistrerImage(fullPath);

	}
	
	@Override
	public void actionPerformed(ActionEvent e) {
		// TODO Auto-generated method stub
		// menufichier
	    if(e.getSource() == mLoad){ 
	    	if(gp != null)
	    		remove(gp);
	    	loadImage(); repaint();
	    	pack();
	    }
	    else if(e.getSource() == mSaveAs){ saveImage();}
	    else if(e.getSource() == mExit){ System.exit(0);}
	    //   menuElementaires
	    else if(e.getSource() == mUndo){
	    	undo();
	    }
	    else if(e.getSource() == mInverse){
	    	inverserCouleur();
	    }
	    else if(e.getSource() == mNiveauDeGris){
	    	niveauDeGris();
	    }
	    else if(e.getSource() == mBinarisationParSeuillage){
	    	binarisationParSeuillage();
	    }
	    else if(e.getSource() == mRecadrage){
	    	recadrage();
	    }
	    //menuBruit
	    else if(e.getSource() == mBruitPoivreSel){
	    	bruitPoivreSel();
	    }
	    //  menuFiltresLinéaires
	    else if(e.getSource() == mMoyenneur3_3){
	    	moyenneur3_3();
	    }
	    else if(e.getSource() == mMoyenneur5_5){
	    	moyenneur5_5();
	    }
	    else if(e.getSource() == mBinomialGaussien3_3){
	    	binomialGaussien3_3();
	    }
	    else if(e.getSource() == mGaussienOuBinomial){
	    	gaussienOuBinomial();
	    }
	    else if(e.getSource() == mPyramidal){
	    	pyramidal();
	    }
	    else if(e.getSource() == mConique){
	    	conique();
	    }
	    else if(e.getSource() == mDerive){
	    	derivée();
	    }
	    else if(e.getSource() == mLaplacien4){
	    	laplacien4();
	    }
	    else if(e.getSource() == mLaplacien8){
	    	laplacien8();
	    }
	    else if(e.getSource() == mSobel){
	    	sobel();
	    }
	    else if(e.getSource() == mPrewitt){
	    	prewitt();
	    }
	    else if(e.getSource() == mGradient){
	    	gradient();
	    }
	    //  menuFiltresNonLinéaires
	    else if(e.getSource() == mMediane){
	    	mediane();
	    }
	    // menuHistogramme
	    else if(e.getSource() == mAfficherHistogrammeNG){ 
	    	histogrammeNG();
	    }
	    else if(e.getSource() == mDeleteHistogrammeNG){
	    	deleteHistogrammeNG();
	    }
	}
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		new ImageFrame();
		
		/*String[] names = ImageIO.getWriterFormatNames();
		for (int i = 0; i < names.length; ++i)
		{
		System.out.println ("format supportée en ecriture : " + names[i]);
		}*/
	}
	public ImagePanel getImagePanel() {
		return imagePanel;
	}
	
	public HistogramePanel getGp() {
		return gp;
	}
	
	public void deleteHistogrammeNG(){
		if(histogrammeIsNotNull()){
			remove(gp);
		}
		pack();
	}

	public void inverserCouleur(){
    	if(gp != null)
    		remove(gp);
    	imagePanel.array.inverseCouleurs();
	    repaint();
	    pack();
	}
	public void niveauDeGris (){
    	if(gp != null)	remove(gp);
    	imagePanel.array.NiveauDeGris();
    	repaint();
		pack();
	}
	public void binarisationParSeuillage (){
    	if(gp != null)	remove(gp);
    	imagePanel.array.BinarisationParSeuillage();
    	repaint();
		pack();
	}
	public void recadrage (){
    	if(gp != null)	remove(gp);
    	imagePanel.array.Recadrage();
    	repaint();
		pack();
	}
	public void bruitPoivreSel(){
    	if(gp != null)	remove(gp);
    	imagePanel.array.bruitPoivreSel(2);
    	repaint();
		pack();
	}
	public void derivée(){
    	if(gp != null)	remove(gp);
    	imagePanel.array.Derivee();
    	repaint();
		pack();
	}
	public void laplacien4 (){
    	if(gp != null)	remove(gp);
    	imagePanel.array.Laplacien4();
    	repaint();
		pack();
	}
	public void laplacien8 (){
    	if(gp != null)	remove(gp);
    	imagePanel.array.laplacien8();
    	repaint();
		pack();
	}
	public void sobel (){
    	if(gp != null)	remove(gp);
    	imagePanel.array.sobel();
    	repaint();
		pack();
	}
	public void prewitt (){
    	if(gp != null)	remove(gp);
    	imagePanel.array.prewitt();
    	repaint();
		pack();
	}
	public void gradient (){
    	if(gp != null)	remove(gp);
    	imagePanel.array.gradient();
    	repaint();
		pack();
	}
	public void moyenneur3_3 (){
    	if(gp != null)	remove(gp);
    	imagePanel.array.Moyenneur3_3();
    	repaint();
		pack();
	}
	public void moyenneur5_5 (){
    	if(gp != null)	remove(gp);
    	imagePanel.array.moyenneur5_5();
    	repaint();	    	
		pack();
	}
	public void binomialGaussien3_3 (){
    	if(gp != null)	remove(gp);
    	imagePanel.array.binomialGaussien3_3();
    	repaint();
		pack();
	}
	public void gaussienOuBinomial (){
    	if(gp != null)	remove(gp);
    	imagePanel.array.gaussienOuBinomial();
    	repaint();	    	
		pack();
	}
	public void pyramidal (){
    	if(gp != null)	remove(gp);
    	imagePanel.array.pyramidal();
    	repaint();	    	
		pack();
	}
	public void conique (){
    	if(gp != null)	remove(gp);
    	imagePanel.array.conique();
    	repaint();	    	
		pack();
	}
	public void mediane (){
    	if(gp != null)	remove(gp);
    	imagePanel.array.Mediane();
    	repaint();
		pack();
	}
	public void undo (){
    	if(gp != null)	remove(gp);
    	imagePanel.array.backToImageLoaded();
    	repaint();
		pack();
		
	}
	public void histogrammeNG (){
    	if(gp != null)	remove(gp);
    	gp = new HistogramePanel(imagePanel.array.histograme());
		gp.setPreferredSize(new Dimension(300, 300));
		gp.setMaximumSize(new Dimension(300, 450));
		gp.setVisible(true);
		add("East", gp);
		repaint();
		pack();
	}
	public boolean imageIsNotNull(){
		return imagePanel.array != null;
	}
	public boolean histogrammeIsNotNull(){
		return gp != null;
	}

}
