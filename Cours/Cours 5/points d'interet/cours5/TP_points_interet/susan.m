clear all 
close all
clc
% =====================chargement et conversion de limage==================
%im =imread('p.bmp');
% im =imread('imgbruite.bmp');
% im =imread('form2.bmp');
% im =imread('lena128.jpg');
im =imread('maison.jpg');
% im =imread('chambre.jpg');
% im =imread('objects_1282.PNG');
% im =imread('nombre.jpg');
%  im =imread('3rect.bmp');
% im =imread('test.bmp');
%  im =imread('h.gif');
% =======================conversion de l'image=============================
d = length(size(im));
% im = imnoise(im,'speckle',0.02);
if d==3
    image=double(rgb2gray(im));
elseif d==2
    image=double(im);
end
subplot(1,2,1)

imshow(im)
[n,m]=size(image);
% =============================données=====================================
rayon=2;
alpha=50;
r=2;
alpha=alpha/100;
% ========================génerateur de mask===============================
mask=zeros(2*rayon+1);
b=ones(rayon+1);
for i=1:rayon+1
    for j=1:rayon+1
        if (rayon==1)
           if(j>i)
            b(i,j)=0;
           end
         else
             if(j>i+1)
            b(i,j)=0;
         end
        end
    end
end
mask(1:rayon+1,rayon+1:2*rayon+1)=b;
mask(1:rayon+1,1:rayon+1)=rot90(b);
mask0=mask;
mask0=flipdim(mask0,1);
mask=mask0+mask;
mask(rayon+1,:)=mask(rayon+1,:)-1;
% ==========================réponse maximale===============================
max_reponse=sum(sum(mask));
% =====================balayage de toute l'image===========================
f=zeros(n,m);
for i=(rayon+1):n-rayon
    for j=(rayon+1):m-rayon
  
          image_courant=image(i-rayon:i+rayon,j-rayon:j+rayon);

    image_courant_mask=image_courant.*mask;

         inteniste_cental= image_courant_mask(rayon+1,rayon+1);
         s=exp(-1*(((image_courant_mask-inteniste_cental)/max_reponse).^6));
       somme=sum(sum(s));
%   si le centre du mask est un 0 il faut soustraire les zeros des filtres
                if (inteniste_cental==0)
                    somme=somme-length((find(mask==0)));
                end       
         f(i,j)=somme;           
     end
end
% =============selection et seuillage des points d'interét=================
ff=f(rayon+1:n-(rayon+1),rayon+1:m-(rayon+1));
minf=min(min(ff));
maxf=max(max(f));
fff=f;
d=2*r+1;
temp1=round(n/d);
if (temp1-n/d)<0.5 &(temp1-n/d)>0
    temp1=temp1-1;
end
temp2=round(m/d);
if (temp2-m/d)<0.5 &(temp2-m/d)>0
    temp2=temp2-1;
end
fff(n:temp1*d+d,m:temp2*d+d)=0;
temp1
temp2

fff;

sizefff=size(fff)
for i=(r+1):d:temp1*d+d
for j=(r+1):d:temp2*d+d
     window=fff(i-r:i+r,j-r:j+r);
     window0=window;
   [xx,yy]=find(window0==0);
               for k=1:length(xx)
                 window0(xx(k),yy(k))=max(max(window0));
               end
               minwindow=min(min(window0));
[y,x]=find(minwindow~=window & window<=minf+alpha*(maxf-minf) & window>0);
[u,v]=find(minwindow==window);
if length(u)>1
             for l=2:length(u) 
                     fff(i-r-1+u(l),j-r-1+v(l))=0   ;       
             end
end
if length(x)~=0
        for l=1:length(y) 
            fff(i-r-1+y(l),j-r-1+x(l))=0   ;
        end
end
fff;
end
end


seuil=minf+alpha*(maxf-minf);

    [u,v]=find(minf<=fff & fff<=seuil );
% ==============affichage des resultats====================================
subplot(1,2,2)
imshow(im)
hold on
plot(v,u,'.r','MarkerSize',10)
nombre_de_point_dinteret=length(v)

