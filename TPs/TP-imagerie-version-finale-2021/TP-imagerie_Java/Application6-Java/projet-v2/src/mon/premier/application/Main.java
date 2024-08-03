package mon.premier.application;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.HeadlessException;
import java.awt.Toolkit;

import javax.imageio.ImageIO;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.Border;

public class Main extends JFrame {

	JPanel container = new JPanel();

	Panneau pan, pan2;
	Ecouteur ecouteur;
	
	JPanel palettes = null;
	JPanel panButon = null;
	Histogramme histogramme = null;
	//private PaletteHistogramme histogramme;
	private PaletteNiveaux niveaux = null;
	private PaletteAtténuation atténuation = null;
	private ZoneImage zoneImage = null;
	
	public Main() throws NoSuchMethodException{
		pan = new Panneau();
		pan2 = new Panneau();
		
		palettes = new JPanel();
		//palettes.setBackground(Color.gray);
		palettes.setPreferredSize(new Dimension(256, this.getHeight()));
		
		zoneImage = new ZoneImage(pan2);
		zoneImage.setImage(pan2.getImageBuffer());
		zoneImage.setImageOriginale(pan.getImageBuffer());
		zoneImage.setSource(pan.getImageBuffer());
		
		histogramme = new Histogramme(pan2);
		//histogramme = new Histogramme(pan2);
		niveaux = new PaletteNiveaux(pan2);
		atténuation = new PaletteAtténuation(pan2);
		palettes.add(histogramme);
		// on essai d'ajouter directement les reglages

		palettes.add(niveaux);
	    palettes.add(atténuation);
		
		panButon = new JPanel(new FlowLayout(FlowLayout.CENTER));
		panButon.setBackground(Color.green);
		JButton but1 = new JButton("Rotation-Gauche");JButton but2 = new JButton("Rotation-Droite");JButton but3 = new JButton("Retailler");
		panButon.add(but1);panButon.add(but2);panButon.add(but3);
		
		Toolkit tk = Toolkit.getDefaultToolkit();
		Dimension d = tk.getScreenSize();
		int large=d.width - 300;
		int hauteur=d.height;
		
		this.setExtendedState(JFrame.MAXIMIZED_BOTH);
		//this.setSize(new  Dimension(large,hauteur));
		this.setDefaultCloseOperation(EXIT_ON_CLOSE);
		this.setContentPane(container);
		container.setBackground(Color.DARK_GRAY);
		container.setLayout(new BorderLayout());
//		pan.setBorder(BorderFactory.createLineBorder(Color.black));
		pan.setPreferredSize(new Dimension(large/2,hauteur));
		pan2.setPreferredSize(new Dimension(large/2,hauteur));
		
		container.add(panButon, BorderLayout.NORTH);
		container.add(pan,BorderLayout.WEST);
		container.add(pan2,BorderLayout.CENTER);
		container.add(palettes, BorderLayout.EAST);
		
		//this.add(pan,BorderLayout.WEST);
		//this.add(pan2,BorderLayout.CENTER);
		//this.add(palettes, BorderLayout.EAST);
		ecouteur = new Ecouteur(pan,pan2,this);
		this.exp();	
		this.setVisible(true);
		
	}
	
	public JPanel getContainer() {
		return container;
	}

	public void setContainer(JPanel container) {
		this.container = container;
	}

	private void exp() {
		String [][] s=new String[][]{
			{"File","ouvrir","fermer","Enregistrer"}
			,
			{"Transformation élémentaire","Niveau de Gris","Binaire","Inverser","Ameliorer Contrast","Egalisation Histogramme"}
			//,
			//{"Convolution","Moyenneur","Moyenneur 5*5","Gaussien","Laplacien","Sobel","Rehausseur Contrast","Gradient Oblique"}
		};
		
		Menu menu=new Menu(s,ecouteur);
		setJMenuBar(menu);		
	}
	/**
	 * @param args
	 * @throws NoSuchMethodException 
	 */
	public static void main(String[] args) throws NoSuchMethodException {
		new Main();

	}

}

