clear all
close all
clc
%  img=imread('maison.jpg');
% img =imread('lune.png');
% img =imread('lena.png');
% img =imread('h.gif');
% img =imread('dama2.bmp');
% im =imread('point.bmp');
% img =imread('test2.jpg');
% img=imread('lettres.bmp');
% [fname,dire]=uigetfile('*.bmp;*.jpg;*.gif;*.png','ouvrir une image :');
% img=imread([dire,fname]);
img = checkerboard(21,3,3);
img=img*255;
%==========================================================================
if(size(img,3)==3)
    display('l''image est en couleur')
    img=rgb2gray(img);
end
%==========================================================================
[m,n]=size(img);
t=maketform('affine',[1 0.2;0.1 1;0 0]);
K=imtransform(img,t,'Size',[m n],'fill',0.5);
subplot(1,2,1); imshow(K); title('l''image originale')
lambda=0.04;
sigma=1; seuil=100; r=6; w=5*sigma;
[m,n]=size(img)
% img = imnoise(img, 'gaussian',0.01, 0.01);
imd=double(K);
dxa=[-sqrt(2)/4 0 sqrt(2)/4 ; -1 0 1 ; -sqrt(2)/4 0 sqrt(2)/4];  % forces attractives 
% dxa=[sqrt(2)/4 0 -sqrt(2)/4 ;  1 0 -1 ; sqrt(2)/4 0 -sqrt(2)/4]; % forces répulsives
dya=dxa'; % derivée verticale
g = fspecial('gaussian',max(1,fix(5*sigma)), sigma);%filre gaussian
Ixa=conv2(imd,dxa,'same');
Iya=conv2(imd,dya,'same');
Ixa2 = conv2(Ixa.^2, g, 'same');  
Iya2 = conv2(Iya.^2, g, 'same');
Ixya = conv2(Ixa.*Iya, g,'same');

% M=[Ix2 Ixy
%     Ixy Iy2];
detM=Ixa2.*Iya2-Ixya.^2;
trM=Ixa2+Iya2;
R=detM-lambda*trM.^2;
%==========================================================================
R1=(1000/(1+max(max(R))))*R;
%==========================================================================          
[u,v]=find(R1<=seuil);
nb=length(u);
for k=1:nb
    R1(u(k),v(k))=0;
end
R11=zeros(m+2*r,n+2*r);
R11(r+1:m+r,r+1:n+r)=R1;
[m1,n1]=size(R11);
for i=r+1:m1-r
    for j=r+1:n1-r
        fenetre=R11(i-r:i+r,j-r:j+r);
        ma=max(max(fenetre));
        if fenetre(r+1,r+1)<ma
            R11(i,j)=0;
        end
    end
end
subplot(1,2,2); imshow(K)
hold on
R11=R11(r+1:m+r,r+1:n+r);
[x,y]=find(R11);
nb=length(x)
plot(y,x,'.r')
title('detection des points d''interets')
