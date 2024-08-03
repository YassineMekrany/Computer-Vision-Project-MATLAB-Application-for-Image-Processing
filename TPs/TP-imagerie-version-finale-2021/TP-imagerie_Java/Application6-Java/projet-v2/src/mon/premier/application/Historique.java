package mon.premier.application;

// mon.premier.application;

import java.util.ArrayList;

public class Historique {
   private ArrayList<String> traitements;
   
   public Historique() {
      initialiser();
   }
   
   public void initialiser() {
      traitements = new ArrayList<String>();
   }
   
   public void ajout(String fonction) {
      boolean existe = false;
      for (String traitement : traitements) 
         if (traitement.equals(fonction)) { 
            existe = true;
            break;
         }
      if (!existe) traitements.add(fonction);
   }
   
   boolean existe(String fonction) {
      for (String traitement : traitements) 
         if (traitement.equals(fonction)) return true; 
      return false;
   }
}
