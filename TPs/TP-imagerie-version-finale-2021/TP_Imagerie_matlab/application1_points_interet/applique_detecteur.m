function applique_detecteur

global editSeuille MenuMethodedetect  A

 str=get(editSeuille, 'String');
 thr=str2num(char(str));

 posiMethode = get(MenuMethodedetect, 'Value');

 if (posiMethode==1)
        harris(A,thr);    
 end
 
 if (posiMethode==2)
         susan(A,thr);
 end
 ajouter_bruit(A);
 trace;