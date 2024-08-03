package mon.premier.application;

import java.io.File;
import java.util.ArrayList;

import javax.swing.filechooser.FileFilter;

public class FiltreExtensible extends FileFilter {

	 //Description et extensions acceptées par le filtre
	   private String description;
	   private ArrayList<String> extensions;
	   
	   
	   public FiltreExtensible(String description){
	      if(description == null){
	         throw new NullPointerException("La description ne peut être null.");
	      }
	      this.description = description;
	      this.extensions = new ArrayList<String>();
	   }
	   //Implémentation de FileFilter
	   public boolean accept(File file){
	      if(file.isDirectory() || extensions.size()==0) { 
	         return true; 
	      } 
	      String nomFichier = file.getName().toLowerCase(); 
	      for(String extension : extensions){
	         if(nomFichier.endsWith(extension)){
	            return true;
	         }
	      }
	      return false;
	   }
	   public String getDescription(){
	      StringBuffer buffer = new StringBuffer(description);
	      buffer.append(" (");
	      for(String extension : extensions){
	         buffer.append(extension).append(" ");
	      }
	      return buffer.append(")").toString();
	   }
	   //Quelques méthodes utilitaires
	   public void setDescription(String description){
	      if(description == null){
	         throw new NullPointerException("La description ne peut être null.");
	      }
	      this.description = description;
	   }
	   public void addExtension(String extension){
	      if(extension == null){
	         throw new NullPointerException("Une extension ne peut être null.");
	      }
	      extensions.add(extension);
	   }
	   public void removeExtension(String extension){
	      extensions.remove(extension);
	   }
	   public void clearExtensions(){
	      extensions.clear();
	   }
	   public ArrayList<String> getExtensions(){
	      return extensions;
	   }
}
