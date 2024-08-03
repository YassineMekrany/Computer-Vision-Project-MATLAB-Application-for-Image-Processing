function affich_image
global axe1 axe2 menuImage  checkBruit editSeuille A 

num_img = get(menuImage, 'Value');

if num_img==1
   nom_img='Chaise.jpg';
end  

if num_img==2
   nom_img='Tournevis.jpg';
end 

if num_img==3
   nom_img='Arrosoire.jpg';
end     
    
if num_img==4
   nom_img='Compas.jpg';
end 
 
if num_img==5
   nom_img='VRRoom_Lampe.jpg';
end
if num_img==6
   nom_img='Tasse.jpg';
end     
     
if num_img==7
   nom_img='PlancheARepasser.jpg';
end

if ~isempty(nom_img)
    A=imread(nom_img);
    a=get(checkBruit,'value');
  if a 
     ajouter_bruit(A);
  else
    applique_detecteur;
    set(axe1,'HandleVisibility','ON');
    axes(axe1);
    image(A);
    axis tight;
    axis off;
    set(axe1,'HandleVisibility','OFF');
  end
    trace;
end
% ajouter_bruit(A);
% applique_detecteur(A);
%==========================================================================