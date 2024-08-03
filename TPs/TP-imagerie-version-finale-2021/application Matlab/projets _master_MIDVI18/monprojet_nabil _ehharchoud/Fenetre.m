function varargout = Fenetre(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Fenetre_OpeningFcn, ...
                   'gui_OutputFcn',  @Fenetre_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


% --- Executes just before Fenetre is made visible.
function Fenetre_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
bg = imread('background.jpg'); imagesc(bg);
set(ah,'handlevisibility','off','visible','off')
uistack(ah, 'bottom');
global check;
check=0;

function varargout = Fenetre_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function checkbox1_Callback(hObject, eventdata, handles)
global check;
a=get(handles.checkbox1,'Value');
if (a==1)
 check=1; 
end 
if (a==0)
 check=0; 
end 

% --------------------------------------------------------------------
function menu_Fichier_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function menu_Apropos_Callback(hObject, eventdata, handles)
AproposFig=figure('Name','À-propos', ...
   'NumberTitle','off',...
   'tag', 'A propos', ...
   'BusyAction','Queue','Interruptible','off', ...
%    'Color', [162 244 199]/256,...
   'position',[400 300 300 220],...
   'IntegerHandle', 'off', ...
   'WindowStyle','modal',...
   'Colormap', gray(256));

Std.Interruptible = 'off';
Std.BusyAction = 'queue';
Ctl = Std;
Ctl.Units = 'Pixels';
Ctl.Parent = AproposFig;

texte=Ctl;
texte.Interruptible='off';
texte.Style='text';
texte.Horiz='left';
texte.Background=[162 244 199]/256;
texte.Foreground='blue';
texte.FontWeight='bold';
texte.Fontsize=12;

% %%/******* text label A Propos **************/
chaine1='Ce projet a été réalisé par :';
hs.hTexteApropos=uicontrol(texte,...
   'Foreground','black',...
   'Position',[20 110 220 100], ...
   'String',chaine1);

chaine2='Nabil Elhanchoud';
hs.hTexteApropos=uicontrol(texte,...
   'Position',[60 85 180 100], ...
   'String',chaine2);

chaine3='Encadré Par : ';
hs.hTexteApropos=uicontrol(texte,...
   'Foreground','black',...
   'Position',[20 45 140 100], ...
   'String',chaine3);

chaine3='M.Hamid Tahiri';
hs.hTexteApropos=uicontrol(texte,...
   'Position',[60 20 140 100], ...
   'String',chaine3);

chaine6='Master MIDVI - 20017/20019';
hs.hTexteApropos=uicontrol(texte,...
   'Foreground','black',...
   'Position',[50 -30 260 100], ...
   'String',chaine6);

%==============================================================
%/*** le bouton ok
h.hBtnOk=uicontrol( ...
   'Parent',AproposFig, ...
   'BusyAction','Queue','Interruptible','off',...
   'Style','pushbutton', ...
   'Units','pixels', ...
   'Position',[100 10 100 25], ...
   'String','Ok', ...
   'Callback','close(gcf)');


% --------------------------------------------------------------------
function sm_Ouvrir_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
[file,path] = uigetfile('*.*');
imageO = imread(sprintf('%s',path,file));
axes(handles.imgO)
imshow(imageO);
axes(handles.imgS)
imageS=zeros();
imshow(imageS);

% --------------------------------------------------------------------
function sm_Enregister_Callback(hObject, eventdata, handles)
global imageS 
[file,path] = uiputfile('*.png','Enregistre');
imwrite(imageS, sprintf('%s',path,file),'png');

% --------------------------------------------------------------------
function sm_Quitter_Callback(hObject, eventdata, handles)
delete(handles.figure1)


% --------------------------------------------------------------------
function menu_Transformation_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function sm_Binarisation_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
[l,c,d]=size(image);
v=zeros(l,c);
seuil=128;
if d==3
    image=rgb2gray(image); 
end
image = double(image);
for i=1:l
   for j=1:c
       if image(i,j)<seuil
           v(i,j)=0;
       else
           v(i,j)=255;
       end 
    end
 end 
imageS=uint8(v); 
axes(handles.imgS);
imshow(imageS);

% --------------------------------------------------------------------
function sm_BinarisationS_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
[l,c,d]=size(image);
v=zeros(l,c);
if d==3
    image=rgb2gray(image); 
end
% Calcule du seuil
m0=1;
m1=mean2(image);
m2=mean2(image.^2);
m3=mean2(image.^3);
%calcule des C:
C1=(m3-(m1*m2))/(m2-m1);
C0=(-m2-(C1*m1))/m0;
%calcule des z:
z1=(-C1-sqrt(C1^2-4*C0))/2;
z2=(-C1+sqrt(C1^2-4*C0))/2;
seuil=(z1+z2)/2;
image = double(image);
for i=1:l
   for j=1:c
       if image(i,j)<=seuil
           v(i,j)=0;
       else
           v(i,j)=255;
       end 
    end
 end 
imageS=uint8(v); 
axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function sm_Inversion_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
imageS=255-double(image);
imageS=uint8(imageS); 
axes(handles.imgS);
imshow(imageS);

% --------------------------------------------------------------------
function sm_Niveaudegris_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
[l,c,d]=size(image);
if d==3
  v=zeros(l,c);
  for i=1:l
    for j=1:c
          v(i,j)=image(i,j,1)*0.333+image(i,j,2)*0.333+image(i,j,3)*0.333;
    end
   end
    imageS=uint8(v); 
else
    imageS=imageO;
end
axes(handles.imgS);
imshow(imageS);

% --------------------------------------------------------------------
function sm_Luminosite_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function ssm_Plus_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
[l,c,d]=size(image);
image = double(image);
v=image;
for i=1:l
    for j=1:c
        pix=image(i,j)+50;
         if(pix>255)
            pix=255;
         end
       v(i,j)=pix;    
    end
end  
imageS=uint8(v);
axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function ssm_Moins_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
[l,c,d]=size(image);
image = double(image);
v=image;
for i=1:l
    for j=1:c
        pix=image(i,j)-50;
         if(pix<0)
            pix=0; 
         end
       v(i,j)=pix;    
    end
end  
imageS=uint8(v); 
axes(handles.imgS);
imshow(imageS);

% --------------------------------------------------------------------
function sm_Contraste_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function ssm_CPlus_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
[l,c,d]=size(image);
image = double(image);
v=image;
for i=1:l
    for j=1:c
        pix=(image(i,j)-100)*3 + 100;
         if(pix>255)
            pix=255;
         elseif (pix<0)
                pix=0; 
          end
       v(i,j)=pix;    
    end
end  
imageS=uint8(v);
axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function ssm_CMoins_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
[l,c,d]=size(image);
image = double(image);
v=image;
for i=1:l
    for j=1:c
        pix=(image(i,j)-100)/3 + 100;
         if(pix>255)
            pix=255;
         elseif (pix<0)
                pix=0; 
          end
       v(i,j)=pix;    
    end
end  
imageS=uint8(v); 
axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function sm_MisEchelle_Callback(hObject, eventdata, handles)

function ssm_MEPlus_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
[l,c,d]=size(image);
image = double(image);
v=image;
for i=1:l
    for j=1:c
        pix=1.5*image(i,j);
         if(pix>255)
            pix=255;
         elseif (pix<0)
                pix=0; 
          end
       v(i,j)=pix;    
    end
end  
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function ssm_MEMoins_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
[l,c,d]=size(image);
image = double(image);
v=image;
for i=1:l
    for j=1:c
        pix=0.5*image(i,j);
         if(pix>255)
            pix=255;
         elseif (pix<0)
                pix=0; 
          end
       v(i,j)=pix;    
    end
end  
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);

% --------------------------------------------------------------------
function sm_AmeliorationC_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
d=length(size(image));
Min=double(min(min(image)));
Max=double(max(max(image)));
m=255/(Max-Min);
if d==3
    b=-m.*Min;
    imageS=uint8(m.*double(image)+b);
elseif d==2
    b=-m*Min;
    imageS=uint8(m*double(image)+b);
end
axes(handles.imgS);
imshow(imageS);

% --------------------------------------------------------------------
function sm_Egalisation_Callback(hObject, eventdata, handles)
% hObject    handle to sm_Egalisation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
    imageS=histeq(image);
axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function sm_SommeBruit_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 bruit =imread('bruit.jpg') ;
 [l,c,d]=size(image);
 [h,k]=size(bruit);
 %seuil=128;
 image=double(image);
 bruit=double(bruit);
 v=image;
 for i=1:l
    for j=1:c
        if i<h && j<k
            v(i,j)=image(i,j)+bruit(i,j);
        end
    end
 end
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function sm_DifferenceBruit_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
bruit =imread('bruit.jpg') ;
 [l,c,d]=size(image);
 [h,k]=size(bruit);
 %seuil=128;
 image=double(image);
 bruit=double(bruit);
 v=image;
 for i=1:l
    for j=1:c
        if i<h && j<k
            v(i,j)=image(i,j)-bruit(i,j);
        end
    end
 end
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function sm_ProduitBruit_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
bruit =imread('bruit.jpg') ;
 [l,c,d]=size(image);
 [h,k]=size(bruit);
 %seuil=128;
 image=double(image);
 bruit=double(bruit);
 v=image;
 for i=1:l
    for j=1:c
        if i<h && j<k
            v(i,j)=image(i,j).*bruit(i,j);
        end
    end
 end
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function sm_MoyenneBruit_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
bruit =imread('bruit.jpg') ;
 [l,c,d]=size(image);
 [h,k]=size(bruit);
 image=double(image);
 bruit=double(bruit);
 v=image;
 for i=1:l
    for j=1:c
        if i<h && j<k
            v(i,j)=(image(i,j)+bruit(i,j))./2;
        end
    end
 end
imageS=uint8(v); 
axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function menu_Histogramme_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   img =imageO;
else
   img =imageS;
end
d = length(size(img));
if d==3
    [yRed, x1] = imhist(img(:,:,1));
    [yGreen, x2] = imhist(img(:,:,2));
    [yBlue, x3] = imhist(img(:,:,3));
    plot(x1, yRed, 'Red', x2, yGreen, 'Green', x3, yBlue, 'Blue');
elseif d==2
[nl,nc]=size(img);
v=double(img);
vec=[1:256];
l=0;
for k=0:255 
    for i=1:nl
        for j=1:nc
            if v(i,j)==k 
               l=l+1;
            end
        end
    end
    vec(k+1)=l;
    l=0;
end
axes(handles.imgS);
plot(vec);
end

% --------------------------------------------------------------------
function menu_Bruit_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function sm_BruitSelPoivre_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
imageS=imnoise(image,'salt & pepper',0.01);
axes(handles.imgS);
imshow(imageS);

% --------------------------------------------------------------------
function sm_BruitGaussien_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
imageS=imnoise(image,'gaussian',0.01);
axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function sm_Speckle_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
imageS=imnoise(image,'speckle',0.01);
axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function menu_FiltrePasseBasL_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function sm_FiltreMoyenneur_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function ssm_M3_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 H=[1 1 1;1 1 1;1 1 1]*1/9;
 [l,c,d]=size(image);
 v=zeros(l,c);
image=double(image);
 for i=1:l
    for j=1:c
        if(i==1||j==1||i==l||j==c)
               v(i,j)=0;
        else
            img=image((i-1:i+1),(j-1:j+1));
            M=img.*H;
            v(i,j)=sum(M(:));
            %v(i,j)=image(i-1,j-1)*H(1,1)+image(i-1,j)*H(1,2)+image(i-1,j+1)*H(1,3) +image(i,j-1)*H(2,1)+image(i,j)*H(2,2)+image(i,j+1)*H(2,3)+image(i+1,j-1)*H(3,1)+image(i+1,j)*H(3,2)+image(i+1,j+1)*H(3,3);   
        end      
    end
 end
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function ssm_M5_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 H=[1 1 1 1 1;1 1 1 1 1;1 1 1 1 1;1 1 1 1 1;1 1 1 1 1]*1/25;
 [l,c,d]=size(image);
 v=zeros(l,c);
image=double(image);
 for i=1:l
    for j=1:c
        if(i==1||j==1||i==l||j==c||i==2||j==2||i==l-1||j==c-1)
               v(i,j)=0;
        else
            img=image((i-2:i+2),(j-2:j+2));
            M=img.*H;
            v(i,j)=sum(M(:));
        end      
    end
 end
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);

% --------------------------------------------------------------------
function sm_FiltreGaussien_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function ssm_G3_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 H=[1 2 1;2 4 2;1 2 1]*1/16;
 [l,c,d]=size(image);
 v=zeros(l,c);
image=double(image);
 for i=1:l
    for j=1:c
        if(i==1||j==1||i==l||j==c)
               v(i,j)=0;
        else
            img=image((i-1:i+1),(j-1:j+1));
            M=img.*H;
            v(i,j)=sum(M(:));
            %v(i,j)=image(i-1,j-1)*H(1,1)+image(i-1,j)*H(1,2)+image(i-1,j+1)*H(1,3) +image(i,j-1)*H(2,1)+image(i,j)*H(2,2)+image(i,j+1)*H(2,3)+image(i+1,j-1)*H(3,1)+image(i+1,j)*H(3,2)+image(i+1,j+1)*H(3,3);   
        end      
    end
 end
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function ssm_G5_Callback(hObject, eventdata, handles)
global imageO;
global imageS;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
H=(1/256)*[1 4 6 4 1 ; 4 16 24 16 4 ; 6 24 36 24 6 ; 4 16 24 16 4 ; 1 4 6 4 1];
 [l,c,d]=size(image);
 v=zeros(l,c);
image=double(image);
 for i=1:l
    for j=1:c
        if(i==1||j==1||i==l||j==c||i==2||j==2||i==l-1||j==c-1)
               v(i,j)=0;
        else
            img=image((i-2:i+2),(j-2:j+2));
            M=img.*H;
            v(i,j)=sum(M(:));
            %v(i,j)=image(i-1,j-1)*H(1,1)+image(i-1,j)*H(1,2)+image(i-1,j+1)*H(1,3) +image(i,j-1)*H(2,1)+image(i,j)*H(2,2)+image(i,j+1)*H(2,3)+image(i+1,j-1)*H(3,1)+image(i+1,j)*H(3,2)+image(i+1,j+1)*H(3,3);   
        end      
    end
 end
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);

% --------------------------------------------------------------------
function sm_FiltrePyramidal_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 H=[1 2 3 2 1;2 4 6 4 2;3 6 9 8 3;2 4 6 4 2;1 2 3 2 1]*1/81;
 [l,c,d]=size(image);
 v=zeros(l,c);
image=double(image);
 for i=1:l
    for j=1:c
        if(i==1||j==1||i==l||j==c||i==2||j==2||i==l-1||j==c-1)
               v(i,j)=0;
        else
            img=image((i-2:i+2),(j-2:j+2));
            M=img.*H;
            v(i,j)=sum(M(:));      
        end      
    end
 end
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);

% --------------------------------------------------------------------
function sm_FiltreConique_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 H=[0 0 1 0 0;0 2 2 2 0;1 2 5 2 1;0 2 2 2 0;0 0 1 0 0]*1/25;
  [l,c,d]=size(image);
 v=zeros(l,c);
image=double(image);
 for i=1:l
    for j=1:c
        if(i==1||j==1||i==l||j==c||i==2||j==2||i==l-1||j==c-1)
               v(i,j)=0;
        else
            img=image((i-2:i+2),(j-2:j+2));
            M=img.*H;
            v(i,j)=sum(M(:));      
        end      
    end
 end
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function sm_FiltreBinomial_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 H=[1 4 6 4 1;4 16 24 16 4;6 24 36 24 6;4 16 24 16 4;1 4 6 4 1]*1/256;
 [l,c,d]=size(image);
 v=zeros(l,c);
image=double(image);
 for i=1:l
    for j=1:c
        if(i==1||j==1||i==l||j==c||i==2||j==2||i==l-1||j==c-1)
               v(i,j)=0;
        else
            img=image((i-2:i+2),(j-2:j+2));
            M=img.*H;
            v(i,j)=sum(M(:));
        end      
    end
 end
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);

% --------------------------------------------------------------------
function sm_FiltreRehausseurC_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 H=[1 -3 1;-3 9 -3;1 -3 1];
 [l,c,d]=size(image);
 v=zeros(l,c);
image=double(image);
 for i=1:l
    for j=1:c
        if(i==1||j==1||i==l||j==c)
               v(i,j)=0;
        else
            img=image((i-1:i+1),(j-1:j+1));
            M=img.*H;
            v(i,j)=sum(M(:));
        end      
    end
 end
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function sm_FiltreMedian_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
image=double(image);
[l,c,d]=size(image);
v=image;
for i=1:l
    for j=1:c
        if(i==1||j==1||i==l||j==c)
               v(i,j)=0;
        else
               voisin=image(i-1:i+1,j-1:j+1);
               listv=[voisin(1,:) voisin(2,:) voisin(3,:)];
               sort(listv);
               med=median(listv);
               v(i,j)=med;
        end      
    end
 end
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function menu_FiltresAdaptatifs_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
H=[1 1 1;1 1 1;1 1 1]*1/9;
[l,c,d]=size(image);
v=zeros(l,c);
image=double(image);
seuil=30;
 for i=1:l
    for j=1:c
        if(i==1||j==1||i==l||j==c)
               v(i,j)=0;
        else
            img=image((i-1:i+1),(j-1:j+1));
            M=img.*H;
            v(i,j)=sum(M(:));
        end 
        if abs(v(i,j)-image(i,j))>=seuil
            v(i,j)=image(i,j);
        end
    end
 end
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function menu_FiltrePasseHaut_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function sm_Detectiondecontours_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function ssm_Moyenne3x3_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 H=[-1 -1 -1;-1 8 -1;-1 -1 -1]*1/9;
 [l,c,d]=size(image);
 v=zeros(l,c);
image=double(image);
 for i=1:l
    for j=1:c
        if(i==1||j==1||i==l||j==c)
               v(i,j)=0;
        else
            img=image((i-1:i+1),(j-1:j+1));
            M=img.*H;
            v(i,j)=sum(M(:));
        end 
    end
 end
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);

% --------------------------------------------------------------------
function ssm_Moyenne5x5_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 H=[-1 -1 -1 -1 -1;-1 -1 -1 -1 -1;-1 -1 24 -1 -1;-1 -1 -1 -1 -1;-1 -1 -1 -1 -1]*1/25;
 [l,c,d]=size(image);
 v=zeros(l,c);
image=double(image);
 for i=1:l
    for j=1:c
        if(i==1||j==1||i==l||j==c||i==2||j==2||i==l-1||j==c-1)
               v(i,j)=0;
        else
            img=image((i-2:i+2),(j-2:j+2));
            M=img.*H;
            v(i,j)=sum(M(:));
        end 
        
    end
 end
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function sm_FiltreSobel_Callback(hObject, eventdata, handles)
global imageO;
global imageS;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 H=[-1 0 1;-2 0 2;-1 0 1];
 V=[-1 -2 -1;0 0 0;1 2 1];
 [l,c,d]=size(image);
 v=zeros(l,c);
 h=zeros(l,c);
 out=zeros(l,c);
image=double(image);
 for i=1:l
    for j=1:c
        if(i==1||j==1||i==l||j==c)
               v(i,j)=0;
               h(i,j)=0;
        else
            img=image((i-1:i+1),(j-1:j+1));
            M=H.*img;
            h(i,j)=sum(M(:));
            L=V.*img;
            v(i,j)=sum(L(:));
            out(i,j)=sqrt(v(i,j)*v(i,j)+h(i,j)*h(i,j));
        end      
    end
 end
imageS=uint8(out); 

axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function sm_FiltrePrewitt_Callback(hObject, eventdata, handles)
global imageO;
global imageS;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 H=[-1 0 1;-1 0 1;-1 0 1];
 V=[-1 -1 -1;0 0 0;1 1 1];
 [l,c,d]=size(image);
 v=zeros(l,c);
 h=zeros(l,c);
 out=zeros(l,c);
image=double(image);
 for i=1:l
    for j=1:c
        if(i==1||j==1||i==l||j==c)
               v(i,j)=0;
               h(i,j)=0;
        else
            img=image((i-1:i+1),(j-1:j+1));
            M=H.*img;
            h(i,j)=sum(M(:));
            L=V.*img;
            v(i,j)=sum(L(:));
            out(i,j)=sqrt(v(i,j)*v(i,j)+h(i,j)*h(i,j));
        end      
    end
 end
imageS=uint8(out); 

axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function sm_FiltreLaplacien8_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 H=[-1 -1 -1;-1 8 -1;-1 -1 -1];
 [l,c,d]=size(image);
 v=zeros(l,c);
image=double(image);
 for i=1:l
    for j=1:c
        if(i==1||j==1||i==l||j==c)
               v(i,j)=0;
        else
            img=image((i-1:i+1),(j-1:j+1));
            M=img.*H;
            v(i,j)=sum(M(:));
        end      
    end
 end
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);

% --------------------------------------------------------------------
function sm_FiltreLaplacien4_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 H=[0 1 0;1 -4 1;0 1 0];
 [l,c,d]=size(image);
 v=zeros(l,c);
image=double(image);
 for i=1:l
    for j=1:c
        if(i==1||j==1||i==l||j==c)
               v(i,j)=0;
        else
            img=image((i-1:i+1),(j-1:j+1));
            M=img.*H;
            v(i,j)=sum(M(:));
        end      
    end
 end
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function sm_FiltreGradO_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 H=[-1 -1 0;-1 0 1;0 1 1];
 [l,c,d]=size(image);
 v=zeros(l,c);
image=double(image);
 for i=1:l
    for j=1:c
        if(i==1||j==1||i==l||j==c)
               v(i,j)=0;
        else
            img=image((i-1:i+1),(j-1:j+1));
            M=img.*H;
            v(i,j)=sum(M(:));
        end      
    end
 end
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);

% --------------------------------------------------------------------
function sm_FiltreRobet_Callback(hObject, eventdata, handles)
global imageO;
global imageS;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 H=[-1 0 ;0 1];
 V=[0 -1;1 0];
 [l,c,d]=size(image);
 v=zeros(l,c);
 h=zeros(l,c);
 out=zeros(l,c);
image=double(image);
 for i=1:l-1
    for j=1:c-1
        
            img=image((i:i+1),(j:j+1));
            M=H.*img;
            h(i,j)=sum(M(:));
            L=V.*img;
            v(i,j)=sum(L(:));
            out(i,j)=sqrt(v(i,j)*v(i,j)+h(i,j)*h(i,j));
            %out(i,j)=abs(uint8( double(image(i,j))-double(image(i+1,j+1))))+ abs(uint8( double(image(i,j+1)) - double(image(i+1,j))));
             
             
    end
 end
imageS=uint8(out); 

axes(handles.imgS);
imshow(imageS);

% --------------------------------------------------------------------
function sm_FiltreKirsch_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 H=[-3 -3 -3;5 0 -3;5 5 -3];
 [l,c,d]=size(image);
 v=zeros(l,c);
image=double(image);
 for i=1:l
    for j=1:c
        if(i==1||j==1||i==l||j==c)
               v(i,j)=0;
        else
            img=image((i-1:i+1),(j-1:j+1));
            M=img.*H;
            v(i,j)=sum(M(:));
        end      
    end
 end
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);

% --------------------------------------------------------------------
function sm_Marr_Hildreth_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 %H=[0 -1 -2 -1 0;-1 0 2 0 -1;-2 2 8 2 -2;-1 0 2 0 -1;0 -1 -2 -1 0];
 H=[-1 -3 -4 -3 -1;-3 0 6 0 -3;-4 6 20 6 -4;-3 0 6 0 -3;-1 -3 -4 -3 -1];
 [l,c,d]=size(image);
 v=zeros(l,c);
image=double(image);
 for i=1:l
    for j=1:c
        if(i==1||j==1||i==l||j==c||i==2||j==2||i==l-1||j==c-1)
               v(i,j)=0;
        else
            img=image((i-2:i+2),(j-2:j+2));
            M=img.*H;
            v(i,j)=sum(M(:));      
        end      
    end
 end
imageS=uint8(v); 

axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function menu_FiltreFrequentiel_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function sm_FPB_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 image=fftshift(fft2(image));
 [l,c,d]=size(image); 
 H=zeros(l,c);
 v=H;
 D=40;
 l2=round(l/2); 
 c2=round(c/2);
 H(l2-D:l2+D,c2-D:c2+D)=1; 
 for i=1:l
    for j=1:c
       v(i,j)=image(i,j)*H(i,j);       
    end
 end
imageS=ifft2(v); 
axes(handles.imgS);
imshow(abs(imageS),[0,255]);


% --------------------------------------------------------------------
function sm_FPBB_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 image=fftshift(fft2(image));
 [l,c,d]=size(image); 
 H=zeros(l,c);
 v=H;
 n=3;
 D0=1;
 l2=round(l/2); 
 c2=round(c/2);
 H(l2-D0:l2+D0,c2-D0:c2+D0)=1; 
 for i=1:l
    for j=1:c
        %D=sqrt(i^2+j^2);
        H(i,j)=1/(1+(H(i,j)/D0)^(2*n)); 
        v(i,j)=image(i,j)*H(i,j);  
    end
 end
imageS=ifft2(v); 
axes(handles.imgS);
imshow(abs(imageS),[0,255]);


% --------------------------------------------------------------------
function sm_FPH_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 image=fftshift(fft2(image));
 [l,c,d]=size(image); 
 H=ones(l,c);
 v=H;
 D=2;
 l2=round(l/2); 
 c2=round(c/2);
 H(l2-D:l2+D,c2-D:c2+D)=0; 
 for i=1:l
    for j=1:c
       v(i,j)=image(i,j)*H(i,j);       
    end
 end
imageS=ifft2(v); 
axes(handles.imgS);
imshow(255-abs(imageS),[0,255]);

% --------------------------------------------------------------------
function sm_FPHB_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
 image=fftshift(fft2(image));
 [l,c,d]=size(image); 
 H=ones(l,c);
 v=H;
 D0=20;
 n=3;
 l2=round(l/2); 
 c2=round(c/2);
 H(l2-D0:l2+D0,c2-D0:c2+D0)=0; 
 for i=1:l
    for j=1:c
        D=sqrt(i^2+j^2);
        H(i,j)=1/(1+(D0/D)^(2*n)); 
        v(i,j)=image(i,j)*H(i,j);       
    end
 end
imageS=ifft2(v); 
axes(handles.imgS);
imshow(255-abs(imageS),[0,255]);


% --------------------------------------------------------------------
function menu_Morphologie_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function sm_Erosion_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
lementS=[1 2 1 ;1 3 10 ; 1 2 1];
inputImge=double(image);
[l,c,d]=size(image);
outputImg=zeros(l,c);
if(islogical(outputImg))
  for i = 1:l
    for j = 1:c
        if i-1>0 && j-1>0 && i+1<=255 && j+1<=255 
        img=inputImge((i-1:i+1),(j-1:j+1));
        M=img-lementS;
        else
          M=255;  
        end
        outputImg(i,j) = min(M(:));       
    end
  end
    imageS=uint8(outputImg);   
else
    s=strel('square',3);
    imageS=imerode(image,s);
end
axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function sm_Dilatation_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
lementS=[1 2 1 ;1 3 10 ; 1 2 1];
inputImge=double(image);
[l,c,d]=size(image);
outputImg=zeros(l,c);
if(islogical(outputImg))
for i = 1:l
    for j = 1:c
        if i-1>0 && j-1>0 && i+1<=255 && j+1<=255 
        img=inputImge((i-1:i+1),(j-1:j+1));
        M=img+lementS;
        else
          M=0;  
        end
        outputImg(i,j) = max(M(:)); 
    end
end
    imageS=uint8(outputImg);   
else
    s=strel('square',3);
    imageS=imdilate(image,s);
end
axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function sm_Ouverture_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
%s=strel('square',3);
s= strel('disk',10);
c2=imerode(image,s);
imageS=uint8(imdilate(c2,s)); % dilatation(erosion(image))

axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function sm_Fermeture_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
%s=strel('square',3);
s= strel('disk',10);
c2=imdilate(image,s);
imageS=imerode(c2,s); % erosion(dilatation(image))

axes(handles.imgS);
imshow(imerode(c2,s));




% --------------------------------------------------------------------
function sm_Contour_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function ssm_ContourI_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
%s=strel('square',3);
s= strel('disk',5);
imageErode=imerode(image,s);
[l,c,d]=size(image);
image=double(image);
imageErode=double(imageErode);
v=image;
 for i=1:l
    for j=1:c
            v(i,j)=image(i,j)-imageErode(i,j);       
    end
 end
imageS=uint8(v);

axes(handles.imgS);
imshow(imageS);



% --------------------------------------------------------------------
function ssm_ContourE_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
%s=strel('square',3);
s= strel('disk',5);
imageDilate=imdilate(image,s);
[l,c,d]=size(imageDilate);
image=double(image);
imageDilate=double(imageDilate);
v=image;
 for i=1:l
    for j=1:c
            v(i,j)=imageDilate(i,j)-image(i,j);       
    end
 end
imageS=uint8(v);

axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function sm_ContourMorphologique_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
%s=strel('square',3);
s= strel('disk',5);
imageDilate=imdilate(image,s);
imageErode=imerode(image,s);
[l,c,d]=size(imageDilate);
imageErode=double(imageErode);
imageDilate=double(imageDilate);
v=imageDilate;
 for i=1:l
    for j=1:c
            v(i,j)=imageDilate(i,j)-imageErode(i,j);       
    end
 end
imageS=uint8(v);

axes(handles.imgS);
imshow(imageS);


% --------------------------------------------------------------------
function menu_PointsDinteret_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function sm_SUSAN_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   im =imageO;
else
   im=imageS;
end
% =======================conversion de l'image=============================
d = length(size(im));
    if d==3
        image=double(rgb2gray(im));
    elseif d==2
        image=double(im);
    end
[n,m]=size(image);
% =============================données=====================================
rayon=1;
alpha=80;
r=5;
alpha=alpha/100;
% ========================génerateur de mask=============================
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
% ==========================réponse maximale============================
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
% si le centre du mask est un 0 il faut soustraire les zeros des filtres
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
            fff(i-r-1+u(l),j-r-1+v(l))=0 ;
        end
    end
   if length(x)~=0
    for l=1:length(y)
        fff(i-r-1+y(l),j-r-1+x(l))=0 ;
    end
   end
   end
end
seuil=minf+alpha*(maxf-minf);
[u,v]=find(minf<=fff & fff<=seuil );

% ==============affichage des resultats====================================
imageS=im;
axes(handles.imgS);
imshow(im);
hold on;
plot(v,u,'.r','MarkerSize',10);
hold off;
message = sprintf(' le nombre des points d''intérêts: %d      ',length(v));
msgbox(message);



% --------------------------------------------------------------------
function sm_HARRIS_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
img=image;
[m,n,d]=size(img);
if(d==3)
    img=rgb2gray(img);
end
%==========================================================================
lambda=0.04;
sigma=1; seuil=200; r=6; w=5*sigma;
imd=double(img);
dx=[-1 0 1
    -2 0 2
    -1 0 1]; % derivée horizontale : filtre de Sobel
dy=dx'; % derivée verticale : filtre de Sobel
g = fspecial('gaussian',max(1,fix(w)), sigma);
Ix=conv2(imd,dx,'same');
Iy=conv2(imd,dy,'same');
Ix2=conv2(Ix.^2, g, 'same');
Iy2=conv2(Iy.^2, g, 'same');
Ixy=conv2(Ix.*Iy, g,'same');
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
R11=R11(r+1:m+r,r+1:n+r);
[x,y]=find(R11);
imageS=img;
axes(handles.imgS);
imshow(img);
hold on;
plot(y,x,'.r','MarkerSize',10);
hold off;
message = sprintf(' le nombre des points d''intérêts: %d      ',length(x));
msgbox(message);


% --------------------------------------------------------------------
function sm_HARRISME_Callback(hObject, eventdata, handles)
global imageS;
global imageO;
global check;
if check==0
   image =imageO;
else
   image =imageS;
end
img=image;
[m,n,d]=size(img);
if(d==3)
    img=rgb2gray(img);
end
%==========================================================================
k=0.04; sigma=1; seuil=100; r=6;
imd=double(img);
dxa=[-sqrt(2)/4 0 sqrt(2)/4 ; -1 0 1 ; -sqrt(2)/4 0 sqrt(2)/4];
dya=dxa'; % derivée verticale
g=fspecial('gaussian',max(1,fix(5*sigma)),sigma); % gaussien
Ixa=conv2(imd,dxa,'same');
Iya=conv2(imd,dya,'same');
Ixa2 = conv2(Ixa.^2, g, 'same');
Iya2 = conv2(Iya.^2, g, 'same');
Ixya = conv2(Ixa.*Iya, g,'same');
R=Ixa2.*Iya2-Ixya.^2-k*(Ixa2+Iya2).^2;
R1=(1000/(max(max(R))))*R; %normalisation
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
R11=R11(r+1:m+r,r+1:n+r);
[x,y]=find(R11);
imageS=img;
axes(handles.imgS);
imshow(img);
hold on;
plot(y,x,'.r','MarkerSize',10);
hold off;
message = sprintf(' le nombre des points d''intérêts: %d      ',length(x));
msgbox(message);
