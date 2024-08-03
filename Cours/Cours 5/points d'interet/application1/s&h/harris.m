function harris(I,thresh)
global nom_img editSeuille axe2
hold off;
Ir=rgb2gray(I);
% [nll,ncc]=size(Ir);
sigma=1;
radius=10;
% thresh=400;
% str=get(editSeuille,'String');
% thresh=Str2num(char(str));
dx = [-1 0 1; -1 0 1; -1 0 1];
dy = dx';
Ix = conv2(double(Ir),double(dx),'same');
Iy = conv2(double(Ir), double(dy),'same');
g = fspecial('gaussian',max(1,fix(6*sigma)), sigma);
Ix2 = conv2(Ix.^2, g, 'same');
Iy2 = conv2(Iy.^2, g, 'same');
Ixy = conv2(Ix.*Iy, g, 'same');
CIM =(Ix2.*Iy2 - Ixy.^2)./(Ix2 + Iy2 +eps);
sze = 2*radius+1;
mx = ordfilt2(CIM,sze^2,ones(sze));
CIM = (CIM==mx)&(CIM>thresh);
[x,y] = find(CIM);
%===================
set(axe2,'HandleVisibility','ON');
axes(axe2);
image(I);
hold on, plot(y,x,'r+');
%  axis equal;
% axis tight;
 axis off;
 