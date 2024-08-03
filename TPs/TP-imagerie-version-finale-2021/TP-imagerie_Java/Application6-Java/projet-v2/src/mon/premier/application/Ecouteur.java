package mon.premier.application;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

import javax.imageio.ImageIO;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.filechooser.FileNameExtensionFilter;

public class Ecouteur implements ActionListener {
	Panneau pan;
	Panneau pan2;
	JFrame frame;
	public Ecouteur(Panneau pan1,Panneau pan2,JFrame frame) {
		this.pan=pan1;
		this.pan2=pan2;
		this.frame=frame;
	}

	@Override
	public void actionPerformed(ActionEvent ev) {
		
		
		//ouvrir fichier
		if(ev.getActionCommand().equals("ouvrir")){
			 JFileChooser chooser = new JFileChooser("../../");
			 FiltreExtensible filtre=new FiltreExtensible("Fichiers images");
			 for(String s:ImageIO.getReaderFormatNames()){
				 filtre.addExtension("."+s);
			 }
			 chooser.addChoosableFileFilter(filtre);
			 if (chooser.showOpenDialog(null) == JFileChooser.APPROVE_OPTION) {
				 
				 pan.setImage(new File(chooser.getSelectedFile().getAbsolutePath()));
				 pan.repaint();
				 frame.repaint();
				 frame.validate();
				}
		}
		
		//
		if(ev.getActionCommand().equals("Enregistrer")){
			 JFileChooser chooser = new JFileChooser("../../");
			 FiltreExtensible filtre=new FiltreExtensible("Fichiers images");
			 for(String s:ImageIO.getReaderFormatNames()){
				 filtre.addExtension("."+s);
			 }
			 chooser.addChoosableFileFilter(filtre);
			if(chooser.showSaveDialog(null)==JFileChooser.APPROVE_OPTION){
				File file=new File(chooser.getSelectedFile().getAbsolutePath());
				pan2.getImage().enregistrerImage(file);
			}

		}
		
		//
		if(ev.getActionCommand().equals("Niveau de Gris")){
			pan2.setImage(pan.getImage().rgb2gray());
			pan2.repaint();
			frame.repaint();
		}
		
		
		//
		
		if(ev.getActionCommand().equals("Binaire")){
			pan2.setImage(pan.getImage().binaire());
			pan2.repaint();
			frame.repaint();
		}
		///
		if(ev.getActionCommand().equals("Inverser")){
			pan2.setImage(pan.getImage().inverser());
			pan2.repaint();
			frame.repaint();
		}
		////
		
		///
		if(ev.getActionCommand().equals("Ameliorer Contrast")){
			pan2.setImage(pan.getImage().improveContrast());
			pan2.repaint();
			frame.repaint();
		}
		////
		
		///
		if(ev.getActionCommand().equals("Egalisation Histogramme")){
			pan2.setImage(pan.getImage().improveContrast_2());
			pan2.repaint();
			frame.repaint();
		}
		////
		if(ev.getActionCommand().equals("Moyenneur")){
			pan2.setImage(pan.getImage().filtreMoyenneur());
			frame.repaint();
		}
		
		////
		
		////
		if(ev.getActionCommand().equals("Moyenneur 5*5")){
			pan2.setImage(pan.getImage().filtreMoyenneur2());
			frame.repaint();
		}
		
		////
		////
		if(ev.getActionCommand().equals("Gaussien")){
			pan2.setImage(pan.getImage().filtreGaussien());
			frame.repaint();
		}
		
		////
		
		////
		if(ev.getActionCommand().equals("Laplacien")){
			pan2.setImage(pan.getImage().filtreLaplacien());
			frame.repaint();
		}
		
		////
		
		////
		if(ev.getActionCommand().equals("Sobel")){
			pan2.setImage(pan.getImage().filtreSobel());
			frame.repaint();
		}
		
		////
		
		////
		if(ev.getActionCommand().equals("Rehausseur Contrast")){
			pan2.setImage(pan.getImage().filtreRehausseurContrast());
			frame.repaint();
		}
		
		////
		
		////
		if(ev.getActionCommand().equalsIgnoreCase("Gradient Oblique")){
			pan2.setImage(pan.getImage().filtreGradientOblique());
			frame.repaint();
		}
		
		////
		
		////
		if(ev.getActionCommand().equalsIgnoreCase("Mediane")){
			pan2.setImage(pan.getImage().filtreMediane());
			frame.repaint();
		}
		
		////
		
		////
		if(ev.getActionCommand().equals("Mediane 5*5")){
			pan2.setImage(pan.getImage().filtreMediane2());
			frame.repaint();
		}
		
		////
	}

}
