package tp5v2;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.WindowConstants;
public class Client5v2 {
	public static void main(String[] args) {	
		HoughFrame fenetre = new HoughFrame();
        fenetre.setTitle("TP5v2 Detection des droit par Algorithme de Hough");
        fenetre.setSize(899, 599);
        fenetre.setLocationRelativeTo(null);
        fenetre.addWindowListener(new WindowAdapter(){
	    public void windowClosing(WindowEvent e){
	            System.exit(0);
	        }
	    });
        fenetre.setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
        fenetre.setResizable(true);
        fenetre.setVisible(true);
	} 	 
}
