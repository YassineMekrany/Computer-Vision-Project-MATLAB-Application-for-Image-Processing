clear all
close all
clc
% img=imread('p.bmp');
% img =imread('lune.png');
% img =imread('lena.png');
% img =imread('h.gif');
% img =imread('riz.jpg');
% im =imread('point.bmp');
% img =imread('test2.jpg');
% img=imread('lettres.bmp');
[fname,dire]=uigetfile('*.bmp;*.jpg;*.gif;*.png','ouvrir une image :');
img=imread([dire,fname]);
%==========================================================================
if(size(img,3)==3)
    display('l''image est en couleur')
    img=rgb2gray(img);
end
%==========================================================================
subplot(1,2,1); imshow(img); title('l''image originale')
lambda=0.04;
sigma=1; seuil=200; r=6; w=5*sigma;
[m,n]=size(img)
imd=double(img);
dx=[-1 0 1
    -2 0 2
    -1 0 1]; % derivée horizontale : filtre de Sobel
dy=dx'; % derivée verticale : filtre de Sobel
% dx=[-1 1];
% dy=dx';
g = fspecial('gaussian',max(1,fix(w)), sigma);
Ix=conv2(imd,dx,'same');
Iy=conv2(imd,dy,'same');
Ix2=conv2(Ix.^2, g, 'same');
Iy2=conv2(Iy.^2, g, 'same');
Ixy=conv2(Ix.*Iy, g,'same');
% M=[Ix2 Ixy
%     Ixy Iy2];
detM=Ix2.*Iy2-Ixy.^2;
trM=Ix2+Iy2;
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
subplot(1,2,2); imshow(img)
hold on
R11=R11(r+1:m+r,r+1:n+r);
[x,y]=find(R11);
nb=length(x)
plot(y,x,'.r')
title('detection des points d''interets')
%==========================================================================
%==========================================================================
% R11=zeros(m,n);
% R11(w:m-w,w:n-w)=R1(w:m-w,w:n-w);
% [x,y]=find(R11>seuil);
% subplot(1,2,2); imshow(img)
% point_intere=length(x);
% hold on
% plot(y,x,'.r')
% title('detection des points d''interets')