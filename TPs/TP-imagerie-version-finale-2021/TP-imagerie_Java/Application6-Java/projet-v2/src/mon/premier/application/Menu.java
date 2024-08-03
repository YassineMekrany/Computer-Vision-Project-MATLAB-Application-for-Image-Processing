package mon.premier.application;

import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;

import javax.swing.ImageIcon;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;

public class Menu extends JMenuBar {
	JMenu filtrespacial = new JMenu("FiltreSpacial");
	JMenu filtrepassebas = new JMenu("Filtres  Passe_Bas");
	JMenu filtrepassehaut = new JMenu("Filtre Passe_Haut");
	JMenu linéaire = new JMenu("Linéaire");
	JMenuItem moyenneur = new JMenuItem("Moyenneur");
	JMenuItem gaussien = new JMenuItem("Gaussien");
	JMenuItem conique = new JMenuItem("Conique");
	JMenuItem pyramidale = new JMenuItem("Pyramidale");
	JMenu nonlinéaire = new JMenu("Non Linéaire");
	JMenuItem median = new JMenuItem("Median");
	JMenuItem sobel = new JMenuItem("Sobel");
	JMenuItem gradient = new JMenuItem("Gradient");
	JMenuItem laplacien = new JMenuItem("Laplacien");
	JMenuItem rehausseurcontrast = new JMenuItem("Rehausseur Contrast");
	JMenuItem gradientoblique = new JMenuItem("Gradient Oblique");
	JMenu filtrefréquentiel = new JMenu("Filtre Fréquentiel");
	JMenu filtrepassebas1 = new JMenu("Filtres Passe_Bas");
	JMenu filtrepassehaut1 = new JMenu("Filtres Passe_Haut");
	JMenuItem fpbi = new JMenuItem("FPBI");
	JMenuItem fpbb = new JMenuItem("FPBB");
	JMenuItem fphi = new JMenuItem("FPHI");
	JMenuItem fphb = new JMenuItem("FPHB");
	
	public Menu(String m[][], ActionListener al) {
		for (int i=0; i<m.length; i++) {
			charger(m[i], al);
		}
		this.add(filtrespacial);
		filtrespacial.add(filtrepassebas);
		filtrespacial.add(filtrepassehaut);
		filtrepassebas.add(linéaire);
		linéaire.add(moyenneur);
		moyenneur.addActionListener(al);
		linéaire.add(gaussien);
		gaussien.addActionListener(al);
		linéaire.add(conique);
		linéaire.add(pyramidale);
		filtrepassebas.add(nonlinéaire);
		nonlinéaire.add(median);
		median.addActionListener(al);
		filtrepassehaut.add(sobel);
		sobel.addActionListener(al);
		filtrepassehaut.add(gradient);
		gradient.addActionListener(al);
		filtrepassehaut.add(laplacien);
		laplacien.addActionListener(al);
		filtrepassehaut.add(rehausseurcontrast);
		rehausseurcontrast.addActionListener(al);
		filtrepassehaut.add(gradientoblique);
		gradientoblique.addActionListener(al);
		this.add(filtrefréquentiel);
		filtrefréquentiel.add(filtrepassebas1);
		filtrefréquentiel.add(filtrepassehaut1);
		filtrepassebas1.add(fpbi);
		fpbi.addActionListener(al);
		filtrepassebas1.add(fpbb);
		fpbb.addActionListener(al);
		filtrepassehaut1.add(fphi);
		fphi.addActionListener(al);
		filtrepassehaut1.add(fphb);
		fphb.addActionListener(al);
	}
	
	private void charger(String options[], ActionListener al) {
		JMenu m = new JMenu(options[0]);		
		for (int i=1; i<options.length; i++) {
			if (options[i].equals("-")) {
				m.addSeparator();
			}
			else {
				JMenuItem mi = new JMenuItem(options[i], new ImageIcon("resources/" + options[i] + ".gif"));
				m.add(mi);
				mi.addActionListener(al);
			}
		}
		this.add(m);
	}
}
