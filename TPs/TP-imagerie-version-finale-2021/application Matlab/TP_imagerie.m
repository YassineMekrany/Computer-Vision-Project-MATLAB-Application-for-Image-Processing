function varargout = TP_imagerie(varargin)
% TP_IMAGERIE MATLAB code for TP_imagerie.fig
%      TP_IMAGERIE, by itself, creates a new TP_IMAGERIE or raises the existing
%      singleton*.
%
%      H = TP_IMAGERIE returns the handle to a new TP_IMAGERIE or the handle to
%      the existing singleton*.
%
%      TP_IMAGERIE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TP_IMAGERIE.M with the given input arguments.
%
%      TP_IMAGERIE('Property','Value',...) creates a new TP_IMAGERIE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TP_imagerie_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TP_imagerie_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TP_imagerie

% Last Modified by GUIDE v2.5 31-Jan-2024 15:48:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TP_imagerie_OpeningFcn, ...
                   'gui_OutputFcn',  @TP_imagerie_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before TP_imagerie is made visible.
function TP_imagerie_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TP_imagerie (see VARARGIN)

% Choose default command line output for TP_imagerie
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TP_imagerie wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TP_imagerie_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Menu_Fichier_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Fichier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Ouvrir_Callback(hObject, eventdata, handles)
% hObject    handle to Ouvrir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.*');
handles.ima = imread(sprintf('%s',path,file));
axes(handles.imgO)
handles.courant_data = handles.ima;
subimage(handles.courant_data);

axes(handles.imgT)
subimage(handles.courant_data);

handles.output = hObject;
guidata(hObject, handles);

% --------------------------------------------------------------------
function Enregistrer_Callback(hObject, eventdata, handles)
% hObject    handle to Enregistrer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = handles.courant_data;
[file,path] = uiputfile('*.png','Enregistrer Votre Image ...');
imwrite(image, sprintf('%s',path,file),'png');

% --------------------------------------------------------------------
function Quitter_Callback(hObject, eventdata, handles)
% hObject    handle to Quitter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1)


% --------------------------------------------------------------------
function Menu_operation_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_operation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Contraste_Callback(hObject, eventdata, handles)
% hObject    handle to Contraste (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;
%[n,m]=size(image);
figure,imhist(image,256);
image = double(image);
%output=image;
A=double(min(min(image)))

B=double(max(max(image)))
P=255/(B-A);
L=-P*A;

%ima=imread('cameraman.tif');
[l c]=size(image);
image = double(image);
v=image;
for i=1:l
    for j=1:c
     fpixel = image(i,j)*P +L; 
    % on v?rifie que la valeur obtenue est bien dans [0..255]
    if( fpixel>255 )
      fpixel = 255;
    else if( fpixel<0 )
      fpixel = 0;
        end 
    end
    
   v(i,j) = fpixel;
    end
end  
v=uint8(v); 
axes(handles.imgT);
subimage(v);
figure,imhist(v,256);

% --------------------------------------------------------------------
function Histogramme_Callback(hObject, eventdata, handles)
% hObject    handle to Histogramme (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = handles.courant_data;
%I=rgb2gray(img);
        d = length(size(img));
        if d==3
            I = rgb2gray(img);
        elseif d==2
            I = img
        end
axes(handles.imgO);
subimage(I);


[nl nc]=size(I);
v=double(I);
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
axes(handles.imgT);plot(vec);

% --------------------------------------------------------------------
function Decalage_additif_Callback(hObject, eventdata, handles)
% hObject    handle to Decalage_additif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image=handles.courant_data;
%[n,m]=size(image);
image = double(image);
%output=image;

figure,imhist(image,256);
L=100;

%ima=imread('cameraman.tif');
[l c]=size(image);
image = double(image);
v=image;
for i=1:l
    for j=1:c
     fpixel = image(i,j)+L; 
    % l'encadrage on verifie que la valeur obtenue est bien dans [0..255]
    if( fpixel>255 )
      fpixel = 255;
    else if( fpixel<0 )
      fpixel = 0;
        end 
    end
    
   v(i,j) = fpixel;
    end
end  
v=uint8(v); 
axes(handles.imgT);
subimage(v);
figure,imhist(v,256);
% --------------------------------------------------------------------
function mise_echelle_multiplicative_Callback(hObject, eventdata, handles)
% hObject    handle to mise_echelle_multiplicative (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;
figure,imhist(image,256);
%[n,m]=size(image);
image = double(image);
%output=image;

%P=0.5 %si en augmante la valeur de P l'image sera ?clair?
P=1.5;

%ima=imread('cameraman.tif');
[l c]=size(image);
image = double(image);
v=image;
for i=1:l
    for j=1:c
     fpixel = image(i,j)*P; 
    % l'encadrage on v?rifie que la valeur obtenue est bien dans [0..255]
    if( fpixel>255 )
      fpixel = 255;
    else if( fpixel<0 )
      fpixel = 0;
        end 
    end
    
   v(i,j) = fpixel;
    end
end  
v=uint8(v); 
axes(handles.imgT);
subimage(v);
figure,imhist(v,256);

% --------------------------------------------------------------------
function Inversion_Callback(hObject, eventdata, handles)
% hObject    handle to Inversion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;
%[n,m]=size(image);
image = double(image);
[l c]=size(image);
image = double(image);
v=image;
for i=1:l
   for j=1:c
     v(i,j)=-double(image(i,j))+255;
    end
 end 

v=uint8(v); 
axes(handles.imgT);
subimage(v);


% --------------------------------------------------------------------
function Menu_bruit_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_bruit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Gaussien_Callback(hObject, eventdata, handles)
% hObject    handle to Gaussien (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageO=handles.courant_data;
Imgb =imnoise(imageO,'gaussian',0.01);

axes(handles.imgT)
imshow(Imgb);

% --------------------------------------------------------------------
function Poivre_et_sel_Callback(hObject, eventdata, handles)
% hObject    handle to Poivre_et_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imageO=handles.courant_data;
Imgb =imnoise(imageO,'Salt & Pepper', 0.02);

axes(handles.imgT)
imshow(Imgb);

% --------------------------------------------------------------------
function Menu_Filtres_passe_bas_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Filtres_passe_bas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Filtres_lineaires_Callback(hObject, eventdata, handles)
% hObject    handle to Filtres_lineaires (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Filtres_non_lineaires_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Filtres_non_lineaires (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Filtre_Moyenneur_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Filtre_Moyenneur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function moyenneur_3_Callback(hObject, eventdata, handles)
% hObject    handle to moyenneur_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;
[n,m]=size(image);
image = double(image);
b=image;
H=(1/9)*[1 1 1 ; 1 1 1 ; 1 1 1 ];
for x = 2 : n-1
    for y = 2 : m-1
     f=image(x-1:x+1,y-1:y+1);
      v=f.*H;
      b(x,y)=sum(v(:));
      
    end 
end
b=uint8(b);
axes(handles.imgT);
subimage(b);

% --------------------------------------------------------------------
function moyenneur_5_Callback(hObject, eventdata, handles)
% hObject    handle to moyenneur_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image=handles.courant_data;
[n,m]=size(image);
image = double(image);
b=image;
H=(1/25)*[1 1 1 1 1 ; 1 1 1 1 1 ; 1 1 1 1 1 ; 1 1 1 1 1 ; 1 1 1 1 1];
for x = 3 : n-2
    for y = 3 : m-2
     f=image(x-2:x+2,y-2:y+2);
      v=f.*H;
      b(x,y)=sum(v(:));
    end 
end
b=uint8(b);
axes(handles.imgT);
     subimage(b);



% --------------------------------------------------------------------
function Filtre_Gaussien_Callback(hObject, eventdata, handles)
% hObject    handle to Filtre_Gaussien (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function gaussien_3_Callback(hObject, eventdata, handles)
% hObject    handle to gaussien_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image=handles.courant_data;
[n,m]=size(image);
image = double(image);
b=image;
H=(1/16)*[1 2 1 ;2 4 2 ; 1 2 1];
for x = 2 : n-1
    for y = 2 : m-1
    f=image(x-1:x+1,y-1:y+1);
      v=f.*H;
      b(x,y)=sum(v(:));
    end 
end
b=uint8(b);
axes(handles.imgT);
    subimage(b);



% --------------------------------------------------------------------
function gaussien_5_Callback(hObject, eventdata, handles)
% hObject    handle to gaussien_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image=handles.courant_data;
[n,m]=size(image);
image = double(image);
b=image;
H=(1/256)*[1 4 6 4 1 ; 4 16 24 16 4 ; 6 24 36 24 6 ; 4 16 24 16 4 ; 1 4 6 4 1];
for x = 3 : n-2
    for y = 3 : m-2
  f=image(x-2:x+2,y-2:y+2);
      v=f.*H;
      b(x,y)=sum(v(:));
    end 
end
b=uint8(b);
axes(handles.imgT);
subimage(b);



% --------------------------------------------------------------------
function Pyramidal_Callback(hObject, eventdata, handles)
% hObject    handle to Pyramidal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image=handles.courant_data;
[n,m]=size(image);
image = double(image);
b=image;

H=(1/81)*[1 2 3 2 1 ; 2 4 6 4 2 ; 3 6 9 6 3 ; 2 4 6 4 2 ; 1 2 3 2 1];

for x = 3 : n-2
    for y = 3 : m-2
          f=image(x-2:x+2,y-2:y+2);
      v=f.*H;
      b(x,y)=sum(v(:));
    end 
end

b=uint8(b);
axes(handles.imgT);
subimage(b);




% --------------------------------------------------------------------
function Conique_Callback(hObject, eventdata, handles)
% hObject    handle to Conique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image=handles.courant_data;
[ n,m]=size(image);
image = double(image);
b=image;

H=(1/25)*[0 0 1 0 0 ; 0 2 2 2 0 ; 1 2 5 2 1 ; 0 2 2 2 0 ; 0 0 1 0 0];

for x = 3 : n-2
    for y = 3 : m-2
       f=image(x-2:x+2,y-2:y+2);
      v=f.*H;
      b(x,y)=sum(v(:));
    end 
end

b=uint8(b);
axes(handles.imgT);
subimage(b);

handles.ima_traite = b;
handles.output = hObject;
guidata(hObject, handles);


% --------------------------------------------------------------------
function Median_Callback(hObject, eventdata, handles)
% hObject    handle to Median (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image=handles.courant_data;
image=double(image);
[n,m]=size(image);
img=image;

for i=2:n-1
    for j=2:m-1
       fenetre=image(i-1:i+1,j-1:j+1);
       v=[fenetre(1,:) fenetre(2,:) fenetre(3,:)];
       sort(v);
       a=median(v);
       img(i,j)=a;
    end
end

b=uint8(img);
handles.ima_traite = b;
axes(handles.imgT);
subimage(b);

handles.output = hObject;
guidata(hObject, handles);


% --------------------------------------------------------------------
function Filtres_passe_haut_Callback(hObject, eventdata, handles)
% hObject    handle to Filtres_passe_haut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Gradient_Callback(hObject, eventdata, handles)
% hObject    handle to Gradient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;
[n,m]=size(image);
image = double(image);
output=image;
%image=rgb2gray(image);

[m,n] = size(image);
output=zeros(size(image)); 
outputhor=zeros(size(image)); 
outputver=zeros(size(image)); 
maskhor = [0,0,0;-1,0,1;0,0,0]; 
maskver = [0,-1,0;0,0,0;0,1,0];
for i=4:(m-3)
   for j=4:(n-3) 
      for k=1:3         
          for l=1:3
            outputhor(i,j) = outputhor(i,j)+image(i-k,j-l)*maskhor(k,l);            
            outputver(i,j) = outputver(i,j)+image(i-k,j-l)*maskver(k,l);          
          end
      end
    end
end
for i=4:(m-3)
for j=4:(n-3)       
    output(i,j)=sqrt(outputhor(i,j)*outputhor(i,j) + outputver(i,j)*outputver(i,j));
end 
end 
output=uint8(output); 

%b=uint8(b);
axes(handles.imgT);
subimage(output);

% --------------------------------------------------------------------
function Sobel_Callback(hObject, eventdata, handles)
% hObject    handle to Sobel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;
[n,m]=size(image);
image = double(image);
output=image;
%image=rgb2gray(image);

output=zeros(size(image)); 
outputhor=zeros(size(image)); 
outputver=zeros(size(image)); 

maskhor = [-1,0,1;-2,0,2;-1,0,1]; 
maskver = [-1,-2,-1;0,0,0;1,2,1];

for i=4:(m-3)
   for j=4:(n-3) 
      for k=1:3          
          for l=1:3
            outputhor(i,j) = outputhor(i,j)+image(i-k,j-l)*maskhor(k,l);             
            outputver(i,j) = outputver(i,j)+image(i-k,j-l)*maskver(k,l);          
          end
      end
    end
end

for i=4:(m-3)
   for j=4:(n-3) 
output(i,j)=sqrt(outputhor(i,j)*outputhor(i,j) + outputver(i,j)*outputver(i,j)); 
   end
end
output=uint8(output); 
axes(handles.imgT);
subimage(output);


% --------------------------------------------------------------------
function Prewitt_Callback(hObject, eventdata, handles)
% hObject    handle to Prewitt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;
[n,m]=size(image);
image = double(image);
output=image;
%image=rgb2gray(image);

output=zeros(size(image)); 
outputhor=zeros(size(image)); 
outputver=zeros(size(image)); 

maskhor = [-1,0,1;-1,0,1;-1,0,1]; 
maskver = [-1,-1,-1;0,0,0;1,1,1];

for i=4:(m-3)
   for j=4:(n-3) 
      for k=1:3          
          for l=1:3
            outputhor(i,j) = outputhor(i,j)+image(i-k,j-l)*maskhor(k,l);             
            outputver(i,j) = outputver(i,j)+image(i-k,j-l)*maskver(k,l);          
          end
      end
    end
end

for i=4:(m-3)
   for j=4:(n-3) 
output(i,j)=sqrt(outputhor(i,j)*outputhor(i,j) + outputver(i,j)*outputver(i,j)); 
   end
end
 
output=uint8(output); 
axes(handles.imgT);
subimage(output);


% --------------------------------------------------------------------
function Roberts_Callback(hObject, eventdata, handles)
% hObject    handle to Roberts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = handles.courant_data;
[n,m]=size(image);
image = double(image);

for x=1:n-1
 for y=1:m-1
  b(x,y)= abs(uint8( double(image(x,y))-double(image(x+1,y+1))))+ abs(uint8( double(image(x,y+1)) - double(image(x+1,y))));
 end
end
        %Seuillage
        [n,m]=size(image);
        for i=1:n-1
         for j=1:m-1
          if b(i,j) < 25
            b(i,j)=0;
          end
         end
        end
           %
  handles.ima_traite = b;
  axes(handles.imgT);
  subimage(b);


% --------------------------------------------------------------------
function Laplacien_Callback(hObject, eventdata, handles)
% hObject    handle to Laplacien (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image=handles.courant_data;
%image=imnoise(imageO,'salt & pepper', 0.05);
[n,m]=size(image);
image = double(image);
%b=image;
[n m]=size(image);
b=zeros(n,m);

M1=[-1 -1 -1;-1 8 -1;-1 -1 -1];
for i=2:n-1
    for j=2:m-1
        V=image((i-1:i+1),(j-1:j+1));
        S=V.*M1;
        b(i,j)=sum(S(:));
    end
end
b=uint8(b);
axes(handles.imgT);
     subimage(b);

% --------------------------------------------------------------------
function Menu_Filtrage_frequentiel_Callback(hObject, eventdata, handles) 
% hObject handle to Menu_Filtrage_frequentiel (see GCBO) 
% eventdata reserved - to be defined in a future version of MATLAB 
% handles structure with handles and user data (see GUIDATA) 
% -------------------------------------------------------------------- 
function Filtre_passeBas_Callback(hObject, eventdata, handles) 
% hObject handle to Filtre_passeBas (see GCBO) 
% eventdata reserved - to be defined in a future version of MATLAB 
% handles structure with handles and user data (see GUIDATA) 
I = handles.courant_data; 
F=fftshift(fft2(I)); 
% %calcul de la taille de l'image; 
M=size(F,1); 
N=size(F,2); 
P=size(F,3); 
H0=zeros(M,N); 
D0=1; 
M2=round(M/2); 
N2=round(N/2); 
H0(M2-D0:M2+D0,N2-D0:N2+D0)=1; 
for i=1:M 
for j=1:N 
G(i,j)=F(i,j)*H0(i,j); 
end 
end 
g=ifft2(G); 
imshow(abs(g),[0,255]); 
% -------------------------------------------------------------------- 
function Filtre_passe_bas_de_Butterworth_Callback(hObject, eventdata, handles) 
% hObject handle to Filtre_passe_bas_de_Butterworth (see GCBO) 
% eventdata reserved - to be defined in a future version of MATLAB 
% handles structure with handles and user data (see GUIDATA) 
I = handles.courant_data; 
%I = imread('eight.tif'); 
F=fftshift(fft2(I)); 
%calcul de la taille de l'image; 
M=size(F,1); 
N=size(F,2); 
P=size(F,3); 
H0=zeros(M,N); 
D0=1; 
M2=round(M/2); 
N2=round(N/2); 
H0(M2-D0:M2+D0,N2-D0:N2+D0)=1; 
n=3; 
for i=1:M 
for j=1:N 
H(i,j)=1/(1+(H0(i,j)/D0)^(2*n)); 
G(i,j)=F(i,j)*H0(i,j); 
end 
end 
g=ifft2(G); 
imshow(abs(g),[0,255]);%title('image filtr?e'); 
% -------------------------------------------------------------------- 
function Filtre_passe_haut_Callback(hObject, eventdata, handles) 
% hObject handle to Filtre_passe_haut (see GCBO) 
% eventdata reserved - to be defined in a future version of MATLAB 
% handles structure with handles and user data (see GUIDATA) 
I=handles.courant_data; 
%charge; 
F=fftshift(fft2(I)); 
%calcul de la taille de l'image; 
M=size(F,1); 
N=size(F,2); 
P=size(F,3); 
H1=ones(M,N); 
D0=1; 
M2=round(M/2); 
N2=round(N/2); 
H1(M2-D0:M2+D0,N2-D0:N2+D0)=0; 
for i=1:M 
for j=1:N 
G(i,j)=F(i,j)*H1(i,j); 
end 
end 
g=ifft2(G); 
imshow(255-abs(g),[0,255]); 
% -------------------------------------------------------------------- 
function Filtre_passe_haut_de_Butterworth_Callback(hObject, eventdata, handles) 
% hObject handle to Filtre_passe_haut_de_Butterworth (see GCBO) 
% eventdata reserved - to be defined in a future version of MATLAB 
% handles structure with handles and user data (see GUIDATA) 
I=handles.courant_data; 
F=fftshift(fft2(I)); 
%calcul de la taille de l'image; 
M=size(F,1); 
N=size(F,2); 
P=size(F,3); 
H1=ones(M,N); 
D0=1; 
M2=round(M/2); 
N2=round(N/2); 
H1(M2-D0:M2+D0,N2-D0:N2+D0)=0; 
n=3; 
for i=1:M 
for j=1:N 
H(i,j)=1/(1+(H1(i,j)/D0)^(2*n)); 
G(i,j)=F(i,j)*H(i,j); 
end 
end 
g=ifft2(G); 
imshow(255-abs(g),[0,255]); 
% -------------------------------------------------------------------- 

function Menu_Morphologie_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Morphologie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Erosion_Callback(hObject, eventdata, handles)
% hObject    handle to Erosion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;

%se = strel('line',11,90);
se = strel('disk',4);

erodedI = imerode(image,se);

nv=uint8(erodedI); 
axes(handles.imgT);
subimage(nv);


% --------------------------------------------------------------------
function Delatation_Callback(hObject, eventdata, handles)
% hObject    handle to Delatation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image=handles.courant_data;

%element structurant de type disc avec rayon = 4 pixel
se = strel('disk',4);

dilatedI = imdilate(image,se);

nv=uint8(dilatedI); 
axes(handles.imgT);
subimage(nv);


% --------------------------------------------------------------------
function Ouverture_Callback(hObject, eventdata, handles)
% hObject    handle to Ouverture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image=handles.courant_data;

%element structurant de type disc avec rayon = 4 pixel
se = strel('disk',4);

O =  imopen(image,se);

nv=uint8(O); 
axes(handles.imgT);
subimage(nv);
% --------------------------------------------------------------------
function Fermeture_Callback(hObject, eventdata, handles)
% hObject    handle to Fermeture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;

%element structurant de type disc avec rayon = 4 pixel
se = strel('disk',4);

F = imclose(image,se);

nv=uint8(F); 
axes(handles.imgT);
subimage(nv);


% --------------------------------------------------------------------
function Gradient_interne_Callback(hObject, eventdata, handles)
% hObject    handle to Gradient_interne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;

%se = strel('line',11,90);
se = strel('disk',4);

erodedI = imerode(image,se);
image=double(image)-double(erodedI);

nv=uint8(image); 
axes(handles.imgT);
subimage(nv);


% --------------------------------------------------------------------
function Gradient_externe_Callback(hObject, eventdata, handles)
% hObject    handle to Gradient_externe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;

%se = strel('line',11,90);
se = strel('disk',4);

dilatedI = imdilate(image,se);
image=double(dilatedI)-double(image);
nv=uint8(image); 
axes(handles.imgT);
subimage(nv);


% --------------------------------------------------------------------
function Gradient_morphologique_Callback(hObject, eventdata, handles)
% hObject    handle to Gradient_morphologique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;

%se = strel('line',11,90);
se = strel('disk',4);
erodedI = imerode(image,se);
dilatedI = imdilate(image,se);
image=double(dilatedI)-double(erodedI);
nv=uint8(image); 
axes(handles.imgT);
subimage(nv);


% --------------------------------------------------------------------
function Chapeau_haut_de_forme_blanc_Callback(hObject, eventdata, handles)
% hObject    handle to Chapeau_haut_de_forme_blanc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;
%figure, imhist(image);

%element structurant de type disc avec rayon = 4 pixel
se = strel('disk',4);

O =  imopen(image,se);

image=double(image)-double(O);

nv=uint8(image); 
axes(handles.imgT);
subimage(nv);


% --------------------------------------------------------------------
function Chapeau_haut_de_forme_noir_Callback(hObject, eventdata, handles)
% hObject    handle to Chapeau_haut_de_forme_noir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;

%element structurant de type disc avec rayon = 4 pixel
se = strel('disk',4);

F = imclose(image,se);
image=double(F)-double(image);

nv=uint8(image); 
axes(handles.imgT);
subimage(nv);


% --------------------------------------------------------------------
function Point_interet_Callback(hObject, eventdata, handles)
% hObject    handle to Point_interet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SUSAN_Callback(hObject, eventdata, handles)
% hObject    handle to SUSAN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im=handles.courant_data;
image=double(im);
[n,m]=size(image);
rayon=2;
alpha=50;
r=2;
alpha=alpha/100;
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
max_reponse=sum(sum(mask));
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
subplot(1,2,2)
imshow(im)
hold on
plot(v,u,'.r','MarkerSize',10)
nombre_de_point_dinteret=length(v)

% --------------------------------------------------------------------
function Harris_Callback(hObject, eventdata, handles)
% hObject    handle to Harris (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

img=handles.courant_data;
%==========================================================================
if(size(img,3)==3)
    display('l''image est en couleur')
    img=rgb2gray(img);
end
%==========================================================================
axes(handles.imgO);
subimage(img);
lambda=0.04;
sigma=1; seuil=200; r=6; w=5*sigma;
[m,n]=size(img)
imd=double(img);
dx=[-1 0 1
    -2 0 2
    -1 0 1]; % deriv?e horizontale : filtre de Sobel
dy=dx'; % deriv?e verticale : filtre de Sobel

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

nv=uint8(img); 
axes(handles.imgT);
subimage(nv);

hold on
R11=R11(r+1:m+r,r+1:n+r);
[x,y]=find(R11);
nb=length(x)
plot(y,x,'.r')


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Hough_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Hough (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Canny_Callback(hObject, eventdata, handles)
% hObject    handle to Canny (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img=handles.courant_data;
% %Input image
% img = imread ('House.jpg');
% %Show input image
% figure, imshow(img);
%img = rgb2gray(img);
%img = double (img);

%Value for Thresholding
T_Low = 0.075;
T_High = 0.175;

%Gaussian Filter Coefficient
B = [2, 4, 5, 4, 2; 4, 9, 12, 9, 4;5, 12, 15, 12, 5;4, 9, 12, 9, 4;2, 4, 5, 4, 2 ];
B = 1/159.* B;

%Convolution of image by Gaussian Coefficient
A=conv2(img, B, 'same');

%Filter for horizontal and vertical direction
KGx = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
KGy = [1, 2, 1; 0, 0, 0; -1, -2, -1];

%Convolution by image by horizontal and vertical filter
Filtered_X = conv2(A, KGx, 'same');
Filtered_Y = conv2(A, KGy, 'same');

%Calculate directions/orientations
arah = atan2 (Filtered_Y, Filtered_X);
arah = arah*180/pi;

pan=size(A,1);
leb=size(A,2);

%Adjustment for negative directions, making all directions positive
for i=1:pan
    for j=1:leb
        if (arah(i,j)<0) 
            arah(i,j)=360+arah(i,j);
        end;
    end;
end;

arah2=zeros(pan, leb);

%Adjusting directions to nearest 0, 45, 90, or 135 degree
for i = 1  : pan
    for j = 1 : leb
        if ((arah(i, j) >= 0 ) && (arah(i, j) < 22.5) || (arah(i, j) >= 157.5) && (arah(i, j) < 202.5) || (arah(i, j) >= 337.5) && (arah(i, j) <= 360))
            arah2(i, j) = 0;
        elseif ((arah(i, j) >= 22.5) && (arah(i, j) < 67.5) || (arah(i, j) >= 202.5) && (arah(i, j) < 247.5))
            arah2(i, j) = 45;
        elseif ((arah(i, j) >= 67.5 && arah(i, j) < 112.5) || (arah(i, j) >= 247.5 && arah(i, j) < 292.5))
            arah2(i, j) = 90;
        elseif ((arah(i, j) >= 112.5 && arah(i, j) < 157.5) || (arah(i, j) >= 292.5 && arah(i, j) < 337.5))
            arah2(i, j) = 135;
        end;
    end;
end;

figure, imagesc(arah2); colorbar;

%Calculate magnitude
magnitude = (Filtered_X.^2) + (Filtered_Y.^2);
magnitude2 = sqrt(magnitude);

BW = zeros (pan, leb);

%Non-Maximum Supression
for i=2:pan-1
    for j=2:leb-1
        if (arah2(i,j)==0)
            BW(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i,j+1), magnitude2(i,j-1)]));
        elseif (arah2(i,j)==45)
            BW(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i+1,j-1), magnitude2(i-1,j+1)]));
        elseif (arah2(i,j)==90)
            BW(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i+1,j), magnitude2(i-1,j)]));
        elseif (arah2(i,j)==135)
            BW(i,j) = (magnitude2(i,j) == max([magnitude2(i,j), magnitude2(i+1,j+1), magnitude2(i-1,j-1)]));
        end;
    end;
end;

BW = BW.*magnitude2;
figure, imshow(BW);

%Hysteresis Thresholding
T_Low = T_Low * max(max(BW));
T_High = T_High * max(max(BW));

T_res = zeros (pan, leb);

for i = 1  : pan
    for j = 1 : leb
        if (BW(i, j) < T_Low)
            T_res(i, j) = 0;
        elseif (BW(i, j) > T_High)
            T_res(i, j) = 1;
        %Using 8-connected components
        elseif ( BW(i+1,j)>T_High || BW(i-1,j)>T_High || BW(i,j+1)>T_High || BW(i,j-1)>T_High || BW(i-1, j-1)>T_High || BW(i-1, j+1)>T_High || BW(i+1, j+1)>T_High || BW(i+1, j-1)>T_High)
            T_res(i,j) = 1;
        end;
    end;
end;

edge_final = uint8(T_res.*255);
%Show final edge detection result
%figure, imshow(edge_final);

% %image=imnoise(imageO,'salt & pepper', 0.05);
% [n,m]=size(image);
% image = double(image);
% %b=image;
% [n m]=size(image);
% b=zeros(n,m);
% 
% M1=[-1 -1 -1;-1 8 -1;-1 -1 -1];
% for i=2:n-1
%     for j=2:m-1
%         V=image((i-1:i+1),(j-1:j+1));
%         S=V.*M1;
%         b(i,j)=sum(S(:));
%     end
% end

%b=uint8(b);
axes(handles.imgT);
     subimage(edge_final);


% --------------------------------------------------------------------
function Kirsch_Callback(hObject, eventdata, handles)
% hObject    handle to Kirsch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageIn=handles.courant_data;
% [N M L] = size(imageIn);
% g = double( (1/15)*[5 5 5;-3 0 -3; -3 -3 -3] );
% kirschImage = zeros(N,M,8);
% for j = 1:8
%     theta = (j-1)*45;
%     gDirection = imrotate(g,theta,'crop');
%     kirschImage(:,:,j) = conv2(imageIn,gDirection,'same');
% end
% imageOut = zeros(N,M);
% for n = 1:N
%     for m = 1:M
%         imageOut(n,m) = max(kirschImage(n,m,:));
%     end
% end

    x=double(imageIn);


    g1=[5,5,5; -3,0,-3; -3,-3,-3];
    g2=[5,5,-3; 5,0,-3; -3,-3,-3];
    g3=[5,-3,-3; 5,0,-3; 5,-3,-3];
    g4=[-3,-3,-3; 5,0,-3; 5,5,-3];
    g5=[-3,-3,-3; -3,0,-3; 5,5,5];
    g6=[-3,-3,-3; -3,0,5;-3,5,5];
    g7=[-3,-3,5; -3,0,5;-3,-3,5];
    g8=[-3,5,5; -3,0,5;-3,-3,-3];


    x1=imfilter(x,g1,'replicate');
    x2=imfilter(x,g2,'replicate');
    x3=imfilter(x,g3,'replicate');
    x4=imfilter(x,g4,'replicate');
    x5=imfilter(x,g5,'replicate');
    x6=imfilter(x,g6,'replicate');
    x7=imfilter(x,g7,'replicate');
    x8=imfilter(x,g8,'replicate');

    y1=max(x1,x2);
    y2=max(y1,x3);
    y3=max(y2,x4);
    y4=max(y3,x5);
    y5=max(y4,x6);
    y6=max(y5,x7);
    y7=max(y6,x8);
    y=y7;


axes(handles.imgT);
     subimage(uint8(y));


% --------------------------------------------------------------------
function Marr_Hildreth_Callback(hObject, eventdata, handles)
% hObject    handle to Marr_Hildreth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageIn=handles.courant_data;
im=im2double(imageIn);
%smoothening the image with a filter
gfilter= [0 0 1 0 0;
       0 1 2 1 0;
       1 2 -16 2 1;
       0 1 2 1 0;
       0 0 1 0 0];
   
smim=conv2(im,gfilter);


% finding the zero crossings

[rr,cc]=size(smim);
zc=zeros([rr,cc]);

for i=2:rr-1
    for j=2:cc-1
        if (smim(i,j)>0)
             if (smim(i,j+1)>=0 && smim(i,j-1)<0) || (smim(i,j+1)<0 && smim(i,j-1)>=0)
                             
                zc(i,j)= smim(i,j+1);
                        
            elseif (smim(i+1,j)>=0 && smim(i-1,j)<0) || (smim(i+1,j)<0 && smim(i-1,j)>=0)
                    zc(i,j)= smim(i,j+1);
            elseif (smim(i+1,j+1)>=0 && smim(i-1,j-1)<0) || (smim(i+1,j+1)<0 && smim(i-1,j-1)>=0)
                  zc(i,j)= smim(i,j+1);
            elseif (smim(i-1,j+1)>=0 && smim(i+1,j-1)<0) || (smim(i-1,j+1)<0 && smim(i+1,j-1)>=0)
                  zc(i,j)=smim(i,j+1);
            end
                        
        end
            
    end
end


otpt=im2uint8(zc);
% thresholding
otptth= otpt>105;

figure;
  subplot(2,2,1);imshow(im);title('Origional image');
  subplot(2,2,2);imshow(smim);title('Smoothened image');
  subplot(2,2,3);imshow(otpt);title('Output image');
  subplot(2,2,4);imshow(otptth);title('Output image with threshold');

  % final result
   figure, imshow(otptth);
   axes(handles.imgT);
     subimage(smim);


% --------------------------------------------------------------------
function Homomorphique_Callback(hObject, eventdata, handles)
% hObject    handle to Homomorphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageIn=handles.courant_data;
cim=double(imageIn);

[r,c]=size(imageIn);
cim=cim+1;
% add 1 to pixels to remove 0 values which would result in undefined log values

% natural log
lim=log(cim);

%2D fft
fim=fft2(lim);

lowg=.9; %(lower gamma threshold, must be lowg < 1)
highg=1.1; %(higher gamma threshold, must be highg > 1)
% make sure the the values are symmetrically differenced

% function call
him=homomorph(fim,lowg,highg);

%inverse 2D fft
ifim=ifft2(him);

 
 
%exponent of result

eim=exp(ifim);

figure;
subplot(2,3,1);imshow(imageIn);title('Origional image');
subplot(2,3,2);imshow(lim);title('Natural Logarithm');
subplot(2,3,3);imshow(uint8(fim));title('Fourier transform');
subplot(2,3,4);imshow(him);title('Homomorphic filter');
subplot(2,3,5);imshow((ifim));title('Inverse fourier transform');
subplot(2,3,6);imshow(uint8(eim));title('Final result');

   axes(handles.imgT);
imshow(uint8(eim))%     subimage(eim);


% --------------------------------------------------------------------
function Detection_droites_Callback(hObject, eventdata, handles)
% hObject    handle to Detection_droites (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageIn=handles.courant_data;
if length( size(imageIn,3))>=3
    imageIn=rgb2gray(imageIn);
end
BW = edge(imageIn,'canny');
[H,theta,rho] = hough(BW);
P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(BW,theta,rho,P,'FillGap',5,'MinLength',7);
   axes(handles.imgT);
 imshow(imageIn), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageIn=handles.courant_data;
if length( size(imageIn,3))>=3
    imageIn=rgb2gray(imageIn);
end
e = edge(imageIn, 'canny');
radii = 15:1:40;
h = circle_hough(e, radii, 'same', 'normalise');
peaks = circle_houghpeaks(h, radii, 'nhoodxy', 15, 'nhoodr', 21, 'npeaks', 10);
   axes(handles.imgT);
 imshow(imageIn), hold on
for peak = peaks
    [x, y] = circlepoints(peak(3));
    plot(x+peak(1), y+peak(2), 'g-');
end
hold off


% --------------------------------------------------------------------
function Applications_Callback(hObject, eventdata, handles)
% hObject    handle to Applications (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageIn=handles.courant_data;
% finds the circles
[r c rad] = circlefinder(uint8(imageIn));

% draws the circles
for n=1:length(rad)
    imageIn = RGBCircle(imageIn,r(n),c(n),rad(n), [0 255 0], 2);
end
   axes(handles.imgT);
imshow(imageIn);


% --------------------------------------------------------------------
function Applications02_Callback(hObject, eventdata, handles)
% hObject    handle to Applications02 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageIn=handles.courant_data;
% finds the circles
[r c rad x x im] = circlefinder(imageIn, [], [], [], [], imageIn);
% draws the circles
   axes(handles.imgT);
imshow(im);


% --------------------------------------------------------------------
function Nagao_Callback(hObject, eventdata, handles)
% hObject    handle to Nagao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageIn=handles.courant_data;
orig_image=double(imageIn);
filter_image = orig_image;
[sizex, sizey] = size(orig_image);

m1 = [NaN NaN NaN NaN NaN;NaN 1 1 1 NaN;NaN 1 1 1 NaN;NaN 1 1 1 NaN;NaN NaN NaN NaN NaN];
m2 = [NaN 1 1 1 NaN;NaN 1 1 1 NaN;NaN NaN 1 NaN NaN;NaN NaN NaN NaN NaN;NaN NaN NaN NaN NaN];
m3 = [NaN NaN NaN NaN NaN;NaN NaN NaN 1 1;NaN NaN 1 1 1;NaN NaN NaN 1 1;NaN NaN NaN NaN NaN];
m4 = [NaN NaN NaN NaN NaN;NaN NaN NaN NaN NaN;NaN NaN 1 NaN NaN;NaN 1 1 1 NaN;NaN 1 1 1 NaN];
m5 = [NaN NaN NaN NaN NaN;1 1 NaN NaN NaN;1 1 1 NaN NaN;1 1 NaN NaN NaN;NaN NaN NaN NaN NaN];
m6 = [1 1 NaN NaN NaN;1 1 1 NaN NaN;NaN 1 1 NaN NaN;NaN NaN NaN NaN NaN;NaN NaN NaN NaN NaN];
m7 = [NaN NaN NaN 1 1;NaN NaN 1 1 1;NaN NaN 1 1 NaN;NaN NaN NaN NaN NaN;NaN NaN NaN NaN NaN];
m8 = [NaN NaN NaN NaN NaN;NaN NaN NaN NaN NaN;NaN NaN 1 1 NaN;NaN NaN 1 1 1;NaN NaN NaN 1 1];
m9 = [NaN NaN NaN NaN NaN;NaN NaN NaN NaN NaN;NaN 1 1 NaN NaN;1 1 1 NaN NaN;1 1 NaN NaN NaN];


for i = 3:sizex - 2
    for j = 3:sizey -2
        subwindow = orig_image(i-2:i+2,j-2:j+2);
        mean_array = zeros([1,9]);
        var_array = zeros([1,9]);
        temp = subwindow.*m1;
        mean_array(1) = mean(temp(~isnan(temp)));
        var_array(1) = var(temp(~isnan(temp)));
        temp = subwindow.*m2;
        mean_array(2) = mean(temp(~isnan(temp)));
        var_array(2) = var(temp(~isnan(temp)));
        temp = subwindow.*m3;
        mean_array(3) = mean(temp(~isnan(temp)));
        var_array(3) = var(temp(~isnan(temp)));
        temp = subwindow.*m4;
        mean_array(4) = mean(temp(~isnan(temp)));
        var_array(4) = var(temp(~isnan(temp)));
        temp = subwindow.*m5;
        mean_array(5) = mean(temp(~isnan(temp)));
        var_array(5) = var(temp(~isnan(temp)));
        temp = subwindow.*m6;
        mean_array(6) = mean(temp(~isnan(temp)));
        var_array(6) = var(temp(~isnan(temp)));
        temp = subwindow.*m7;
        mean_array(7) = mean(temp(~isnan(temp)));
        var_array(7) = var(temp(~isnan(temp)));
        temp = subwindow.*m8;
        mean_array(8) = mean(temp(~isnan(temp)));
        var_array(8) = var(temp(~isnan(temp)));
        temp = subwindow.*m9;
        mean_array(9) = mean(temp(~isnan(temp)));
        var_array(9) = var(temp(~isnan(temp)));
        MIN_VARIANCE = min(var_array)
        for k = 1:9
            if MIN_VARIANCE == var_array(k)
                filter_image(i,j) = mean_array(k);
                break
            end
        end
    end
end

   axes(handles.imgT);
imshow(filter_image);


% --------------------------------------------------------------------
function Filtre_Passe_Bande_Callback(hObject, eventdata, handles)
% hObject    handle to Filtre_Passe_Bande (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageIn=handles.courant_data;
filtered_image = butterworthbpf(imageIn,30,120,4);

   axes(handles.imgT);
imshow(filtered_image);


% --------------------------------------------------------------------
function Seuillage_Callback(hObject, eventdata, handles)
% hObject    handle to Seuillage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageIn=handles.courant_data;
thresholded = thresholdLocally(imageIn);

   axes(handles.imgT);
imshow(thresholded);
