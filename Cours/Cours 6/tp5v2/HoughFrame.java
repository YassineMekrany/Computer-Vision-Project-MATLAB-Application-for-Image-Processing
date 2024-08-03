package tp5v2;
//import image.Channel;
import java.awt.BasicStroke;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Cursor;
import java.awt.FileDialog;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.EventObject;
import java.util.List;

import javax.imageio.ImageIO;
import javax.swing.BoxLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSlider;
import javax.swing.WindowConstants;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
public class HoughFrame extends JFrame implements ActionListener,ChangeListener{
	private static final int TH_INIT = 40;
	// Hough Transform (multilines)
	private Hough hough = null; 
	// image size
	private int width,height;
	// seuil  pour votes
	private int seuil  = 0;
	private int rayon  = 0;
	// AWT images
	public static  BufferedImage image = null;
	public static  BufferedImage imgHS = null; 
	// SWING objects	
	private JPanel panneau = new JPanel();
	final JScrollPane scrollPane = new JScrollPane(panneau);
	JButton buttonLoad = new JButton("Ouvrir image");
	JButton buttonSave = new JButton("Enregistrer image");
	JButton buttonHough = new JButton("Transformation de Hough "); 	    
	final JPanel buttonPanel = new JPanel();
	final JPanel coefPanel = new JPanel();
	final JPanel mainPanel = new JPanel();
	final JPanel OptionPanel = new JPanel();
	private static JLabel label0 = new JLabel("= Image =");
	private static JLabel label1 = new JLabel("= Espace de Hough  =");
	private static JLabel seuilLabel = new JLabel("seuil de vote ");
	
	private static JSlider seuilGlissade = new JSlider(0,100,40);
	private static JCheckBox cbAfficherExtrema= new JCheckBox("Afficher Extrema",true);
	// singleton
	private static HoughFrame fenetre = null;
	// Constructeur
	public HoughFrame(int width,int height, int seuil ) {
		this.width=width;
		this.height=height;
		this.seuil =seuil ;

		// distance minimum entre deux sommet  dans le tableau
		this.rayon =6;  
	}
		public HoughFrame( ) {
		Thread.currentThread().setPriority(Thread.MIN_PRIORITY);
		setBackground(Color.black);
		setLayout(new BorderLayout());
		
		label0.setVerticalTextPosition(JLabel.BOTTOM);
		label0.setHorizontalTextPosition(JLabel.CENTER);
		label0.setForeground(Color.blue);
		label1.setVerticalTextPosition(JLabel.BOTTOM);
		label1.setHorizontalTextPosition(JLabel.CENTER);
		label1.setForeground(Color.blue);
		
		panneau.setBackground(new Color(192,204,226));
		panneau.add(label0);
		panneau.add(label1);
	    buttonPanel.add(buttonLoad);
	    buttonPanel.add(buttonHough);
	    buttonPanel.add(buttonSave);
	      
	    coefPanel.add(seuilLabel); 
	    coefPanel.add(seuilGlissade);
	    // ActionListener "SLIDE"
	    seuilGlissade.addChangeListener(this);
	    coefPanel.add(cbAfficherExtrema);
	    
	    mainPanel.setLayout(new BoxLayout(mainPanel,BoxLayout.Y_AXIS));
		mainPanel.add(buttonPanel);
		OptionPanel.setLayout(new BoxLayout(OptionPanel,BoxLayout.X_AXIS));
		OptionPanel.add(coefPanel);
	    
		// frame
		getContentPane().add(mainPanel,BorderLayout.PAGE_START);
	    getContentPane().add(scrollPane,BorderLayout.CENTER);
	    getContentPane().add(OptionPanel,BorderLayout.PAGE_END);
	   
	    // ActionListener "LOAD" "Save" "RUN" "CHECKBOX"
	    buttonLoad.addActionListener( this);
	    buttonSave.addActionListener( this);
	    buttonHough.addActionListener(this);
	    cbAfficherExtrema.addActionListener( this);    
	}
	public void actionPerformed(ActionEvent e){
			// fichier
		    if(e.getSource() == buttonLoad){ loadImage(); repaint();        }
		    if(e.getSource() == buttonSave){ saveImage();         }
		    //Algorithme
		    if(e.getSource() == buttonHough){ AlgoHough(); repaint();        }
		    if(e.getSource() == cbAfficherExtrema){ afficherExtrimum();        }		    
	}
	public void stateChanged(ChangeEvent e) {
		if (seuilGlissade.getValueIsAdjusting()) return;
		if (HoughFrame.fenetre==null) return;
		mainPanel.setVisible(false);
		JSlider source = (JSlider)e.getSource();
        if (!source.getValueIsAdjusting()) {
        	seuil=source.getValue();
			seuilLabel.setText("Seuil de vote = "+ seuil);
        }
		try {
			HoughFrame.fenetre.seuil=seuilGlissade.getValue();
			HoughFrame.fenetre.ExtractionLignes(HoughFrame.image);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		mainPanel.setVisible(true); 
	}
	// ---------------------------------------------------------------------------------
	//                                   GRAPHICS 
	// ---------------------------------------------------------------------------------
	
	private void TracerLine(BufferedImage image,Point A, Point B,Color c) {
		Graphics2D g2d = image.createGraphics();
		g2d.setColor(c);
		g2d.setStroke(new BasicStroke(2));
		g2d.drawLine(A.x, A.y, B.x, B.y);
	}
	private void TracerCircle(BufferedImage image, Point center, int radius, Color c) {
		Graphics2D g2d = image.createGraphics();
		g2d.setColor(c);
		g2d.setStroke(new BasicStroke(1));
		g2d.drawOval(center.x-radius, center.y-radius, 2*radius, 2*radius);
	}
	public BufferedImage getEspaceHough() {
		//récupérer une image du panneau
		int maxIndexTheta = this.hough.getMaxIndexTheta();
		int maxIndexRho = this.hough.getMaxIndexRho();
		int[][] acc = this.hough.getAccumulator();	
		BufferedImage img =  new BufferedImage(maxIndexTheta,maxIndexRho,BufferedImage.TYPE_INT_RGB);		
		int max=0;
		for(int r=0;r<maxIndexRho;r++)
			for(int t=0;t<maxIndexTheta;t++)
				if (acc[r][t]>max) max=acc[r][t];
		double scale=max/10;
		for(int r=0;r<maxIndexRho;r++)
			for(int t=0;t<maxIndexTheta;t++) {
				double v = Math.log(1.0+(double)acc[r][t]/scale)/Math.log(1.0+max/scale);
				Color color = Color.getHSBColor(0f, 0f, (float)v);
				img.setRGB(t, r, color.getRGB());
			}
		return img;
	}
	// ---------------------------------------------------------------------------------
	//                                   SWING Callback 
	// ---------------------------------------------------------------------------------

	// appelée par "Load Image"
	private void ExecuterTH(BufferedImage img0) {

		// new Hough Transformer
		this.hough = new Hough(width,height);

		// grayscale conversion
		int[][] gray = new int[width][height];
		for (int y=0;y<height;y++) {
			for (int x=0;x<width;x++) {
				int rgb = img0.getRGB(x, y);
				int r = (rgb >>16 ) & 0xFF;
				int g = (rgb >> 8 ) & 0xFF;
				int b = rgb & 0xFF;
				gray[x][y]=(299*r + 587*g + 114*b)/1000;
			}
		}
		// computer gradient (Sobel) + vote in Hough Space (if gradient>64)
		for (int y=1;y<height-1;y++) {
			for (int x=1;x<width-1;x++) {
				int gv = (gray[x+1][y-1]-gray[x-1][y-1])+2*(gray[x+1][y]-gray[x-1][y])+(gray[x+1][y+1]-gray[x-1][y+1]);
				int gh = (gray[x-1][y+1]-gray[x-1][y-1])+2*(gray[x][y+1]-gray[x][y-1])+(gray[x+1][y+1]-gray[x+1][y-1]);
				int g2 = (gv*gv + gh*gh)/(16);
				if (g2>4096) this.hough.vote(x,y); // ||gradient||^2 > 64^2
			}
		}
		// display Hough Space
		HoughFrame.imgHS = getEspaceHough();
		label1.setIcon( new ImageIcon(HoughFrame.imgHS) );
	}
	// called by "Perform Hough Transform"
	private void ExtractionLignes(BufferedImage img0) {
	    System.out.println("\nResultats:");
	    // search extrema dans l'espace de Hough 
	    List<double[]> vainqueurs = this.hough.getVainqueurs(this.seuil, this.rayon );
	    // Image d'espace de Hough  
	    HoughFrame.imgHS = getEspaceHough();
	    // Copie de l'image d'entree.
	    BufferedImage imgout =  new BufferedImage(img0.getWidth(),img0.getHeight(),BufferedImage.TYPE_INT_RGB);
	    imgout.createGraphics().drawImage(img0,0,0,null);
	    // utiliser des colers 
	    int num=0;
	    Color[] colors = new Color[] {
	    		Color.BLUE, Color.RED, Color.GREEN, Color.CYAN, Color.MAGENTA,
	    		Color.YELLOW, Color.ORANGE, Color.PINK
	    };
	    // afficher chaque vainqueur (lines + sommet)
	    for (double[] winner:vainqueurs) {
	    	double rho   = winner[0];
	    	double theta = winner[1];  	
	    	// affichage de valures de theta/rho 
			System.out.println("vainqueur: theta="+Math.toDegrees(theta)+"°, rho="+(int)rho);
		    // coleur de cycle 
	    	Color color = colors[(num++) % colors.length];
	    	// convertir (rho,theta) to equation Y=a.X+b
		    double[] c = this.hough.rhotheta_to_ab(rho, theta);
	    	if (Double.isNaN(c[0])) {
	    		// vertical case, b contains the "x" offset
		    	Point A = new Point((int)c[1],0); 
		    	Point B = new Point((int)c[1],height); 
		    	TracerLine(imgout, A, B, color);
		    } else { 
		    	// other case
		    	Point A = new Point(0,(int)c[1]); 
		    	Point B = new Point(width,(int)(c[0]*width+c[1])); 
		    	TracerLine(imgout, A, B, color);
		    }	    	
	    	// afficher la boîte dans l'espace de Hough 
			if (HoughFrame.cbAfficherExtrema.isSelected()) {
				Point center = new Point();
				center.x = this.hough.ThetaToIndex(theta);
				center.y = this.hough.RhoToIndex(rho);
				TracerCircle(HoughFrame.imgHS, center, this.rayon , color);
			}
	    } 
	    label0.setIcon( new ImageIcon(imgout));
	    label1.setIcon( new ImageIcon(HoughFrame.imgHS) );
	}
	// ---------------------------------------------------------------------------------
	//                           Methodes  utilitaires 
	// ---------------------------------------------------------------------------------
	public void AlgoHough() {
		// Snake executable
		try {
			if (HoughFrame.image==null) return;
			getContentPane().setCursor(Cursor.getPredefinedCursor(Cursor.WAIT_CURSOR));
			int w=HoughFrame.image.getWidth();
			int h=HoughFrame.image.getHeight();
			//appel de la fonction de hough
			HoughFrame.fenetre = new HoughFrame(w,h,HoughFrame.seuilGlissade.getValue());
			HoughFrame.fenetre.ExecuterTH(HoughFrame.image);
			HoughFrame.fenetre.ExtractionLignes(HoughFrame.image);
			getContentPane().setCursor(Cursor.getDefaultCursor());

		} catch (Exception ex) {
			HoughFrame.fenetre=null;
			ex.printStackTrace();
		}
	}
	public void afficherExtrimum() {
		if (HoughFrame.fenetre==null) return;
		mainPanel.setVisible(false);
		try {
			HoughFrame.fenetre.ExtractionLignes(HoughFrame.image);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		mainPanel.setVisible(true);
	}
	
	// ---------------------------------------------------------------------------------
	//                           Image I/O 
	// ---------------------------------------------------------------------------------
	public void loadImage() {
		FileDialog filedialog = new FileDialog(this, "choisir un fichier image ");
		filedialog.setVisible(true);
		String filename = filedialog.getFile();
		String directory = filedialog.getDirectory();
		if (filename==null) return;
		File file = new File(directory+File.separator+filename);
		mainPanel.setVisible(false);
		try {
			loadimage(file);
			HoughFrame.fenetre=null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		mainPanel.setVisible(true);
		mainPanel.setVisible(true);
	}
	public static void loadimage(File file) throws IOException {
		label0.setIcon( null );
		label1.setIcon( null );
		HoughFrame.image = ImageIO.read( file );
		if (HoughFrame.image!=null) label0.setIcon( new ImageIcon(HoughFrame.image) );		
	}
	public void saveImage() {
		
		JFileChooser fileEnregistrerImage = new JFileChooser();
		fileEnregistrerImage.setVisible(true);
		if (fileEnregistrerImage.showSaveDialog(this) == JFileChooser.APPROVE_OPTION) {
			File fichierEnregistrement = new File(fileEnregistrerImage.getSelectedFile().getAbsolutePath()+ ".JPG");
		
			try {
				saveimage(fichierEnregistrement);
			HoughFrame.fenetre=null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		}
	}
	public void saveimage(File fichierImage) throws IOException {
		
		String format ="JPG";
		//BufferedImage image = new BufferedImage(width, height,  BufferedImage.TYPE_INT_RGB);
        //BufferedImage image = getEspaceHough();
		try {
			ImageIO.write(imgHS, format, fichierImage);
			System.out.println("l'image est bien enregistrée  ");
			
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println("ERROR lors d'enregisstrement de fichier JPG "+fichierImage);
	}
	}
}
