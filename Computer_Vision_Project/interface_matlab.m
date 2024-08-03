function varargout = interface_matlab(varargin)
% INTERFACE_MATLAB MATLAB code for interface_matlab.fig
%      INTERFACE_MATLAB, by itself, creates a new INTERFACE_MATLAB or raises the existing
%      singleton*.
%
%      H = INTERFACE_MATLAB returns the handle to a new INTERFACE_MATLAB or the handle to
%      the existing singleton*.
%
%      INTERFACE_MATLAB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE_MATLAB.M with the given input arguments.
%
%      INTERFACE_MATLAB('Property','Value',...) creates a new INTERFACE_MATLAB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interface_matlab_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interface_matlab_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface_matlab

% Last Modified by GUIDE v2.5 12-Apr-2024 14:31:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_matlab_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_matlab_OutputFcn, ...
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


% --- Executes just before interface_matlab is made visible.
function interface_matlab_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface_matlab (see VARARGIN)

% Choose default command line output for interface_matlab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface_matlab wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interface_matlab_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Fichier_Callback(hObject, eventdata, handles)
% hObject    handle to Fichier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Bruit_Callback(hObject, eventdata, handles)
% hObject    handle to Bruit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function filtres_passe_haut_Callback(hObject, eventdata, handles)
% hObject    handle to filtres_passe_haut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Filtres_passe_bas_Callback(hObject, eventdata, handles)
% hObject    handle to Filtres_passe_bas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Contraste_Callback(hObject, eventdata, handles)
% hObject    handle to Contraste (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = handles.courant_data;
image = double(image);

[l, c] = size(image);
v = zeros(l, c);

a = min(min(image(:)));
b = max(max(image(:)));

% Compute P as a scalar
P = 255 / (b - a);
% Compute L using the scalar P
L = -P *a;
for i = 1:l
    for j = 1:c
        fpixel = (image(i, j)) * P + L;

        % Verify that the value is within [0, 255]
        if fpixel > 255
            fpixel = 255;
        elseif fpixel < 0
            fpixel = 0;
        end

        v(i, j) = fpixel;
    end
end

v = uint8(v);

axes(handles.axes2);
imshow(v);

% --------------------------------------------------------------------
function Histogramme_Callback(hObject, eventdata, handles)
% hObject    handle to Histogramme (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to histogramme (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = handles.courant_data;

d = length(size(img));
if d==3
    I = rgb2gray(img);
elseif d==2
    I = img;
end
axes(handles.axes1);
imshow(I);

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
axes(handles.axes2);plot(vec);

% --------------------------------------------------------------------
function Decalage_additif_Callback(hObject, eventdata, handles)
% hObject    handle to Decalage_additif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;
image = double(image);

L=100;
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
axes(handles.axes2);
imshow(v);

% --------------------------------------------------------------------
function Inversion_Callback(hObject, eventdata, handles)
% hObject    handle to Inversion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to negative (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;
%[n,m]=size(image);
image = double(image);
[l c]=size(image);
%image = double(image);
v=image;
for i=1:l
   for j=1:c
     v(i,j)=-double(image(i,j))+255;
    end
 end 

v=uint8(v); 
axes(handles.axes2);
imshow(v);

% 

% --------------------------------------------------------------------
function Binarisation_Callback(hObject, eventdata, handles)
% hObject    handle to Binarisation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

I4 = handles.courant_data;
image=double(I4);
seuil_aleatoire = 128;

[l c]=size(image);

v=image;
for i=1:l
   for j=1:c
       if v(i,j) < seuil_aleatoire
           v(i,j)=0;
       else
           v(i,j)=255;
       end
    end
 end 

V=uint8(v); 
axes(handles.axes2);
imshow(V);

% --------------------------------------------------------------------
function Ouvrir_Callback(hObject, eventdata, handles)
% hObject    handle to Ouvrir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.*');
handles.ima = imread(sprintf('%s',path,file));
axes(handles.axes1)
handles.courant_data = handles.ima;
imshow(handles.courant_data);

axes(handles.axes2)
imshow(handles.courant_data);

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
function Niveau_du_gris_Callback(hObject, eventdata, handles)
% hObject    handle to Niveau_du_gris (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB

ima = handles.courant_data;
d = length(size(ima));
if d == 3
    imagray = rgb2gray(ima);
else
    imagray = ima;
end

min_val = min(imagray(:));
max_val = max(imagray(:));

imagray_transformed = (255/(max_val - min_val)) * (imagray - min_val);
% Afficher l'image transformée
axes(handles.axes2);
imshow(uint8(imagray_transformed));

% --------------------------------------------------------------------
function luminosite_Callback(hObject, eventdata, handles)
% hObject    handle to luminosite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;
[l c]=size(image);
image = double(image);
v=image;
for i=1:l
    for j=1:c
        pix=image(i,j)+50;
         if(pix>255)
            pix=255;
         else if (pix<0)
                pix=0;
             
              end 
          end
       v(i,j)=pix;    
    end
end  
v=uint8(v); 
axes(handles.axes2);
imshow(v);

% --------------------------------------------------------------------
function Mise_echelle_multiplicative_Callback(hObject, eventdata, handles)
% hObject    handle to Mise_echelle_multiplicative (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;
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
axes(handles.axes2);
imshow(v);


% --------------------------------------------------------------------
function Gaussien_Callback(hObject, eventdata, handles)

imageO = handles.courant_data;

% Parameters for Gaussian noise
mean =0;
standard_deviation =150;

% Generate Gaussian noise
noise = randn(size(imageO)) * standard_deviation + mean;

% Add noise to the image
Imgb = double(imageO) + noise;

% Display the noisy image
axes(handles.axes2);
imshow(Imgb);

% --------------------------------------------------------------------
function Poivre_et_sel_Callback(hObject, eventdata, handles)
% hObject    handle to Poivre_et_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageO = handles.courant_data;

% Probability of adding salt and pepper noise
noise_prob = 0.01;

% Generate salt and pepper noise mask
salt_pepper_noise = rand(size(imageO));

% Add salt noise
imageO(salt_pepper_noise < noise_prob/2) = 200;  % Assuming image is in uint8 format

% Add pepper noise
imageO(salt_pepper_noise > 1 - noise_prob/2) = 0;

% Display the noisy image
axes(handles.axes2);
imshow(imageO);

% --------------------------------------------------------------------
function Gradient_Callback(hObject, eventdata, handles)
% hObject    handle to Gradient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image = handles.courant_data;
[n, m] = size(image);
image = double(image);
output = zeros(size(image));

maskhor = [0, 0, 0; -1, 0, 1; 0, 0, 0];
maskver = [0, -1, 0; 0, 0, 0; 0, 1, 0];

for i = 2:(n - 1)
    for j = 2:(m - 1)
        outputhor = sum(sum(image(i-1:i+1, j-1:j+1) .* maskhor));
        outputver = sum(sum(image(i-1:i+1, j-1:j+1) .* maskver));
        
        output(i, j) = sqrt(outputhor^2 + outputver^2);
    end
end

output = uint8(output);

axes(handles.axes2);
imshow(output);



% --------------------------------------------------------------------
function Sobel_Callback(hObject, eventdata, handles)
% hObject    handle to Sobel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = handles.courant_data;
[n, m] = size(image);
image = double(image);
output = zeros(size(image));

maskhor = [-1,0,1;-2,0,2;-1,0,1]; 
maskver = [-1,-2,-1;0,0,0;1,2,1];

for i = 2:(n - 1)
    for j = 2:(m - 1)
        outputhor = sum(sum(image(i-1:i+1, j-1:j+1) .* maskhor));
        outputver = sum(sum(image(i-1:i+1, j-1:j+1) .* maskver));
        
        output(i, j) = sqrt(outputhor^2 + outputver^2);
    end
end

output = uint8(output);

axes(handles.axes2);
imshow(output);


% --------------------------------------------------------------------
function Prewitt_Callback(hObject, eventdata, handles)
% hObject    handle to Prewitt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = handles.courant_data;
[n, m] = size(image);
image = double(image);
output = zeros(size(image));

maskhor = [-1,0,1;-1,0,1;-1,0,1]; 
maskver = [-1,-1,-1;0,0,0;1,1,1];

for i = 2:(n - 1)
    for j = 2:(m - 1)
        outputhor = sum(sum(image(i-1:i+1, j-1:j+1) .* maskhor));
        outputver = sum(sum(image(i-1:i+1, j-1:j+1) .* maskver));
        
        output(i, j) = sqrt(outputhor^2 + outputver^2);
    end
end

output = uint8(output);

axes(handles.axes2);
imshow(output);


% --------------------------------------------------------------------
function Roberts_Callback(hObject, eventdata, handles)
% hObject    handle to Roberts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = handles.courant_data;
[n, m] = size(image);
image = double(image);
output = zeros(size(image));

for i = 1:(n - 1)
    for j = 1:(m - 1)
        G = abs(image(i, j) - image(i+1, j+1)) + abs(image(i, j+1) - image(i+1, j));
        output(i, j) = G;
    end
end

output = uint8(output);

axes(handles.axes2);
imshow(output);


% --------------------------------------------------------------------
function Laplacien_Callback(hObject, eventdata, handles)
% hObject    handle to Laplacien (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;

[n,m]=size(image);
image = double(image);

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
axes(handles.axes2);
imshow(b);

% --------------------------------------------------------------------
function Canny_Callback(hObject, eventdata, handles)
% hObject    handle to Canny (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Obtenir l'image actuelle à partir des données de l'interface utilisateur
img = handles.courant_data;

% Définir les seuils bas et haut pour la détection de contours
T_Low = 0.075;
T_High = 0.175;

% Coefficients du filtre gaussien
B = [2, 4, 5, 4, 2; 4, 9, 12, 9, 4; 5, 12, 15, 12, 5; 4, 9, 12, 9, 4; 2, 4, 5, 4, 2];
B = 1/159 .* B;

% Appliquer la convolution avec les coefficients gaussiens
A = conv2(img, B, 'same');

% Filtres pour les directions horizontale et verticale
KGx = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
KGy = [1, 2, 1; 0, 0, 0; -1, -2, -1];

% Convolution de l'image par les filtres horizontaux et verticaux
Filtered_X = conv2(A, KGx, 'same');
Filtered_Y = conv2(A, KGy, 'same');

% Calculer les directions/orientations des gradients
arah = atan2(Filtered_Y, Filtered_X);
arah = arah * 180/pi;

pan = size(A, 1);
leb = size(A, 2);

% Ajustement pour les directions négatives, rendant toutes les directions positives
for i = 1:pan
    for j = 1:leb
        if (arah(i, j) < 0)
            arah(i, j) = 360 + arah(i, j);
        end
    end
end

arah2 = zeros(pan, leb);

% Ajuster les directions aux valeurs les plus proches de 0, 45, 90 ou 135 degrés
for i = 1:pan
    for j = 1:leb
        if ((arah(i, j) >= 0) && (arah(i, j) < 22.5) || (arah(i, j) >= 157.5) && (arah(i, j) < 202.5) || (arah(i, j) >= 337.5) && (arah(i, j) <= 360))
            arah2(i, j) = 0;
        elseif ((arah(i, j) >= 22.5) && (arah(i, j) < 67.5) || (arah(i, j) >= 202.5) && (arah(i, j) < 247.5))
            arah2(i, j) = 45;
        elseif ((arah(i, j) >= 67.5 && arah(i, j) < 112.5) || (arah(i, j) >= 247.5 && arah(i, j) < 292.5))
            arah2(i, j) = 90;
        elseif ((arah(i, j) >= 112.5 && arah(i, j) < 157.5) || (arah(i, j) >= 292.5 && arah(i, j) < 337.5))
            arah2(i, j) = 135;
        end
    end
end

% Calculer la magnitude des gradients
magnitude = (Filtered_X.^2) + (Filtered_Y.^2);
magnitude2 = sqrt(magnitude);

% Initialiser une matrice binaire pour la suppression du maximum local
BW = zeros(pan, leb);

% Suppression du maximum local
for i = 2:pan-1
    for j = 2:leb-1
        if (arah2(i, j) == 0)
            BW(i, j) = (magnitude2(i, j) == max([magnitude2(i, j), magnitude2(i, j+1), magnitude2(i, j-1)]));
        elseif (arah2(i, j) == 45)
            BW(i, j) = (magnitude2(i, j) == max([magnitude2(i, j), magnitude2(i+1, j-1), magnitude2(i-1, j+1)]));
        elseif (arah2(i, j) == 90)
            BW(i, j) = (magnitude2(i, j) == max([magnitude2(i, j), magnitude2(i+1, j), magnitude2(i-1, j)]));
        elseif (arah2(i, j) == 135)
            BW(i, j) = (magnitude2(i, j) == max([magnitude2(i, j), magnitude2(i+1, j+1), magnitude2(i-1, j-1)]));
        end
    end
end

% Multiplication de la magnitude par la matrice binaire pour obtenir les contours
BW = BW .* magnitude2;

% Seuillage par hystérésis
T_Low = T_Low * max(max(BW));
T_High = T_High * max(max(BW));

T_res = zeros(pan, leb);

for i = 1:pan
    for j = 1:leb
        if (BW(i, j) < T_Low)
            T_res(i, j) = 0;
        elseif (BW(i, j) > T_High)
            T_res(i, j) = 1;
        % Utilisation des composants 8-connectés
        elseif (BW(i+1, j) > T_High || BW(i-1, j) > T_High || BW(i, j+1) > T_High || BW(i, j-1) > T_High || BW(i-1, j-1) > T_High || BW(i-1, j+1) > T_High || BW(i+1, j+1) > T_High || BW(i+1, j-1) > T_High)
            T_res(i, j) = 1;
        end
    end
end

% Convertir le résultat en image binaire
edge_final = uint8(T_res * 255);

% Afficher l'image des contours dans la deuxième fenêtre
axes(handles.axes2);
imshow(edge_final);


% --------------------------------------------------------------------
function Kirsch_Callback(hObject, eventdata, handles)
% hObject    handle to Kirsch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageIn=handles.courant_data;
x=double(imageIn);

g1=[5,5,5; -3,0,-3; -3,-3,-3];
g2=[5,5,-3; 5,0,-3; -3,-3,-3];
g3=[5,-3,-3; 5,0,-3; 5,-3,-3];
g4=[-3,-3,-3; 5,0,-3; 5,5,-3];
g5=[-3,-3,-3; -3,0,-3; 5,5,5];
g6=[-3,-3,-3; -3,0,5;-3,5,5];
g7=[-3,-3,5; -3,0,5;-3,-3,5];
g8=[-3,5,5; -3,0,5;-3,-3,-3];


x1 = conv2(x, g1, 'same');
x2 = conv2(x, g2, 'same');
x3 = conv2(x, g3, 'same');
x4 = conv2(x, g4, 'same');
x5 = conv2(x, g5, 'same');
x6 = conv2(x, g6, 'same');
x7 = conv2(x, g7, 'same');
x8 = conv2(x, g8, 'same');


y1=max(x1,x2);
y2=max(y1,x3);
y3=max(y2,x4);
y4=max(y3,x5);
y5=max(y4,x6);
y6=max(y5,x7);
y7=max(y6,x8);
y=y7;


axes(handles.axes2);
imshow(uint8(y));

% --------------------------------------------------------------------
function Marr_Hildreth_Callback(hObject, eventdata, handles)
% hObject    handle to Marr_Hildreth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imageIn = handles.courant_data;
im = im2double(imageIn);

% Smoothening the image with a filter
gfilter = [0 -1 -2 -1 0;
           -1 0 2 0 -1;
           -2 2 8 2 -2;
           -1 0 2 0 -1;
           0 -1 -2 -1 0];

smim = conv2(im, gfilter);

% Finding the zero crossings
[rr, cc] = size(smim);
zc = zeros([rr, cc]);

for i = 2:rr-1
    for j = 2:cc-1
        if (smim(i,j) > 0)
            if (smim(i,j+1) >= 0 && smim(i,j-1) < 0) || (smim(i,j+1) < 0 && smim(i,j-1) >= 0)
                zc(i,j) = smim(i,j+1);
            elseif (smim(i+1,j) >= 0 && smim(i-1,j) < 0) || (smim(i+1,j) < 0 && smim(i-1,j) >= 0)
                zc(i,j) = smim(i,j+1);
            elseif (smim(i+1,j+1) >= 0 && smim(i-1,j-1) < 0) || (smim(i+1,j+1) < 0 && smim(i-1,j-1) >= 0)
                zc(i,j) = smim(i,j+1);
            elseif (smim(i-1,j+1) >= 0 && smim(i+1,j-1) < 0) || (smim(i-1,j+1) < 0 && smim(i+1,j-1) >= 0)
                zc(i,j) = smim(i,j+1);
            end
        end
    end
end

axes(handles.axes2);
imshow(smim);

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
axes(handles.axes2);
imshow(b);

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
axes(handles.axes2);
imshow(b);

handles.ima_traite = b;
handles.output = hObject;
guidata(hObject, handles);


% --------------------------------------------------------------------
function Median_Callback(hObject, eventdata, handles)
% hObject    handle to Median (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = handles.courant_data;
image = double(image);
[n, m] = size(image);
img = image;

for i = 2:n-1
    for j = 2:m-1
        fenetre = image(i-1:i+1, j-1:j+1);
        v = [fenetre(1, :) fenetre(2, :) fenetre(3, :)];
        sort(v);
        a = median(v);
        img(i, j) = a;
    end
end

b = uint8(img);

% Use imshow instead of subimage
axes(handles.axes2);
imshow(b);


% --------------------------------------------------------------------
function Moyenneur_Callback(hObject, eventdata, handles)
% hObject    handle to Moyenneur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_8_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Gaussien3_3_Callback(hObject, eventdata, handles)
% hObject    handle to Gaussien3_3 (see GCBO)
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
axes(handles.axes2);
imshow(b);

% --------------------------------------------------------------------
function Gaussien5_5_Callback(hObject, eventdata, handles)
% hObject    handle to Gaussien5_5 (see GCBO)
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
axes(handles.axes2);
imshow(b);

% --------------------------------------------------------------------
function Moyenneur3_3_Callback(hObject, eventdata, handles)
% hObject    handle to Moyenneur3_3 (see GCBO)
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
axes(handles.axes2);
imshow(b);


% --------------------------------------------------------------------
function Moyenneur5_5_Callback(hObject, eventdata, handles)
% hObject    handle to Moyenneur5_5 (see GCBO)
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
axes(handles.axes2);
imshow(b);
     


% --------------------------------------------------------------------
function Filtre_passe_bas_FFT_Callback(hObject, eventdata, handles)
% hObject    handle to Filtre_passe_bas_FFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I = handles.courant_data; 
image=fftshift(fft2(I));
 [l,c,d]=size(I); 
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
axes(handles.axes2);
imshow(abs(imageS),[0,255]);

% --------------------------------------------------------------------
function Filtre_passe_bas_Butterworth_Callback(hObject, eventdata, handles)
% hObject    handle to Filtre_passe_bas_Butterworth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I = handles.courant_data;
image=fftshift(fft2(I));
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
        H(i,j)=1/(1+(H(i,j)/D0)^(2*n)); 
        v(i,j)=image(i,j)*H(i,j);  
    end
 end
imageS=ifft2(v); 
axes(handles.axes2);
imshow(abs(imageS),[0,255]);


% --------------------------------------------------------------------
function Filtre_passe_haut_FFT_Callback(hObject, eventdata, handles)
% hObject    handle to Filtre_passe_haut_FFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I=handles.courant_data; 
image=fftshift(fft2(I));
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
axes(handles.axes2);
imshow(255-abs(imageS),[0,255]); 

% --------------------------------------------------------------------
function Filtre_passe_haut_Butterworth_Callback(hObject, eventdata, handles)
% hObject    handle to Filtre_passe_haut_Butterworth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I=handles.courant_data; 
image=fftshift(fft2(I));
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
axes(handles.axes2);
imshow(255-abs(imageS),[0,255]);


% --------------------------------------------------------------------
function Filtrage_Homomorphique_Callback(hObject, eventdata, handles)
% hObject    handle to Filtrage_Homomorphique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% Charger les données d'image actuelles à partir de handles
imageIn = handles.courant_data;
I = double(imageIn);
% Ajouter 1 aux pixels pour supprimer les valeurs 0 qui entraîneraient des valeurs de logarithme indéfinies
I = I + 1;
% Prendre le logarithme de l'image
log_image = log(I);
% Effectuer la transformée de Fourier
fft_image = fft2(log_image);
% Définir les dimensions du filtre
[M, N] = size(fft_image);
H1 = ones(M, N);
D0 = 1;
M2 = round(M/2);
N2 = round(N/2);

% Appliquer le filtre
H1(M2-D0:M2+D0, N2-D0:N2+D0) = 0;
n = 3;
H = ones(M, N);
for i = 1:M
    for j = 1:N
        H(i, j) = 1 / (1 + (H1(i, j) / D0)^(2 * n));
    end
end

% Appliquer le filtre à l'image transformée par Fourier
filtered_fft = fft_image .* H;

% Effectuer la transformée de Fourier inverse
ifft_image = ifft2(filtered_fft);

% Exponentier le résultat pour revenir au domaine logarithmique
eim = exp(ifft_image);

% Mettre à jour l'image affichée dans handles.imgT
axes(handles.axes2);
%imshow(uint8(eim));
imshow(eim, []);


% --------------------------------------------------------------------
function Filtre_passe_bande_Callback(hObject, eventdata, handles)
% hObject handle to Filtre_passe_bande (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
I = handles.courant_data;
% Définir les paramètres du filtre
d0 = 30;
d1 = 120;
n = 4;

% Convertir l'image en double précision
f = double(I);
[nx, ny] = size(f);
f = uint8(f);

% Effectuer la transformée de Fourier
fftI = fft2(f, 2 * nx - 1, 2 * ny - 1);
fftI = fftshift(fftI);

% Initialiser le filtre
filter1 = ones(2 * nx - 1, 2 * ny - 1);
filter2 = ones(2 * nx - 1, 2 * ny - 1);
filter3 = ones(2 * nx - 1, 2 * ny - 1);

% Calculer le filtre de Butterworth
for i = 1:2 * nx - 1
    for j = 1:2 * ny - 1
        dist = ((i - (nx + 1))^2 + (j - (ny + 1))^2)^0.5;
        % Créer le filtre de Butterworth
        filter1(i, j) = 1 / (1 + (dist / d1)^(2 * n));
        filter2(i, j) = 1 / (1 + (dist / d0)^(2 * n));
        filter3(i, j) = 1.0 - filter2(i, j);
        filter3(i, j) = filter1(i, j) * filter3(i, j);
    end
end

% Appliquer le filtre à l'image transformée par Fourier
filtered_image = fftI + filter3 .* fftI;

% Effectuer la transformée de Fourier inverse
filtered_image = ifftshift(filtered_image);
filtered_image = ifft2(filtered_image, 2 * nx - 1, 2 * ny - 1);
filtered_image = real(filtered_image(1:nx, 1:ny));
filtered_image = uint8(filtered_image);

% Mettre à jour l'image affichée dans handles.axes2
axes(handles.axes2);
imshow(filtered_image);

% --------------------------------------------------------------------
function op_ponctuelles_Callback(hObject, eventdata, handles)
% hObject    handle to op_ponctuelles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Morphologie_Callback(hObject, eventdata, handles)
% hObject    handle to Morphologie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Erosion_Callback(hObject, eventdata, handles)
% hObject    handle to Erosion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = handles.courant_data;
elementS=[1 2 1 ;1 3 10 ; 1 2 1];

inputImge=double(image);
[l,c,d]=size(image);
outputImg=zeros(l,c);
for i = 1:l
for j = 1:c
    if i-1>0 && j-1>0 && i+1<=255 && j+1<=255 
    img=inputImge((i-1:i+1),(j-1:j+1));
    M=img-elementS;
    else
      M=255;  
    end
    outputImg(i,j) = min(M(:));       
end
end
imageS=uint8(outputImg);     
axes(handles.axes2);
imshow(imageS);

% --------------------------------------------------------------------
function Dilatation_Callback(hObject, eventdata, handles)
% hObject    handle to Dilatation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = handles.courant_data;

elementS=[1 2 1 ;1 3 10 ; 1 2 1];
inputImge=double(image);
[l,c,d]=size(image);
outputImg=zeros(l,c);

for i = 1:l
    for j = 1:c
        if i-1>0 && j-1>0 && i+1<=255 && j+1<=255 
        img=inputImge((i-1:i+1),(j-1:j+1));
        M=img+elementS;
        else
          M=0;  
        end
        outputImg(i,j) = max(M(:)); 
    end
end
    imageS=uint8(outputImg);   

axes(handles.axes2);
imshow(imageS);

% --------------------------------------------------------------------
function Ouverture_Callback(hObject, eventdata, handles)

image = handles.courant_data;
elementS=[1 2 1 ;1 3 10 ; 1 2 1];

inputImge=double(image);
[l,c,d]=size(image);
outputImg=zeros(l,c);
outputImg2=zeros(l,c);
for i = 1:l
for j = 1:c
    if i-1>0 && j-1>0 && i+1<=255 && j+1<=255 
    img=inputImge((i-1:i+1),(j-1:j+1));
    M=img-elementS;
    else
      M=255;  
    end
    outputImg(i,j) = min(M(:));       
end
end

for i = 1:l
    for j = 1:c
        if i-1>0 && j-1>0 && i+1<=255 && j+1<=255 
        img=outputImg((i-1:i+1),(j-1:j+1));
        M=img+elementS;
        else
          M=0;  
        end
        outputImg2(i,j) = max(M(:)); 
    end
end
    imageS=uint8(outputImg2);   

axes(handles.axes2);
imshow(imageS);


% --------------------------------------------------------------------
function Fermeture_Callback(hObject, eventdata, handles)

image = handles.courant_data;
elementS=[1 2 1 ;1 3 10 ; 1 2 1];

inputImge=double(image);
[l,c,d]=size(image);
outputImg=zeros(l,c);
outputImg2=zeros(l,c);
for i = 1:l
for j = 1:c
    if i-1>0 && j-1>0 && i+1<=255 && j+1<=255 
    img=inputImge((i-1:i+1),(j-1:j+1));
    M=img+elementS;
    else
      M=0;  
    end
    outputImg(i,j) = max(M(:));       
end
end

for i = 1:l
    for j = 1:c
        if i-1>0 && j-1>0 && i+1<=255 && j+1<=255 
        img=outputImg((i-1:i+1),(j-1:j+1));
        M=img-elementS;
        else
          M=255;  
        end
        outputImg2(i,j) = min(M(:)); 
    end
end
    imageS=uint8(outputImg2);   

axes(handles.axes2);
imshow(imageS);

% --------------------------------------------------------------------
function filtrage_freq_Callback(hObject, eventdata, handles)
% hObject    handle to filtrage_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Gradient_interne_Callback(hObject, eventdata, handles)
% hObject    handle to Gradient_interne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = handles.courant_data;
elementS=[1 2 1 ;1 3 10 ; 1 2 1];

inputImge=double(image);
[l,c,d]=size(image);
outputImg=zeros(l,c);
for i = 1:l
for j = 1:c
    if i-1>0 && j-1>0 && i+1<=255 && j+1<=255 
    img=inputImge((i-1:i+1),(j-1:j+1));
    M=img-elementS;
    else
      M=255;  
    end
    outputImg(i,j) = min(M(:));       
end
end
I=inputImge-outputImg
imageS=uint8(I);     
axes(handles.axes2);
imshow(imageS);

% --------------------------------------------------------------------
function Gradient_externe_Callback(hObject, eventdata, handles)
% hObject    handle to Gradient_externe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = handles.courant_data;

elementS=[1 2 1 ;1 3 10 ; 1 2 1];
inputImge=double(image);
[l,c,d]=size(image);
outputImg=zeros(l,c);

for i = 1:l
    for j = 1:c
        if i-1>0 && j-1>0 && i+1<=255 && j+1<=255 
        img=inputImge((i-1:i+1),(j-1:j+1));
        M=img+elementS;
        else
          M=0;  
        end
        outputImg(i,j) = max(M(:)); 
    end
end
I=outputImg-inputImge
imageS=uint8(I);   

axes(handles.axes2);
imshow(imageS);


% --------------------------------------------------------------------
function Gradient_morphologique_Callback(hObject, eventdata, handles)
% hObject    handle to Gradient_morphologique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = handles.courant_data;

elementS=[1 2 1 ;1 3 10 ; 1 2 1];
inputImge=double(image);
[l,c,d]=size(image);
outputImg1=zeros(l,c);
outputImg2=zeros(l,c);
for i = 1:l
    for j = 1:c
        if i-1>0 && j-1>0 && i+1<=255 && j+1<=255 
        img=inputImge((i-1:i+1),(j-1:j+1));
        M=img+elementS;
        else
          M=0;  
        end
        outputImg1(i,j) = max(M(:)); 
    end
end

for i = 1:l
for j = 1:c
    if i-1>0 && j-1>0 && i+1<=255 && j+1<=255 
    img=inputImge((i-1:i+1),(j-1:j+1));
    M=img-elementS;
    else
      M=255;  
    end
    outputImg2(i,j) = min(M(:));       
end
end
I=outputImg1 - outputImg2
imageS=uint8(I);
axes(handles.axes2);
imshow(imageS);


% --------------------------------------------------------------------
function points_interet_Callback(hObject, eventdata, handles)
% hObject    handle to points_interet (see GCBO)
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
% Récupérer l'image courante
img = handles.courant_data;
% Vérifier si l'image est en couleur
if size(img, 3) == 3
    img = rgb2gray(img);
end
% Paramètres pour la détection de points d'intérêt Harris
lambda = 0.04;
sigma = 1;
seuil = 200;
r = 6;
w = 5 * sigma;

[m, n] = size(img);
imd = double(img);

% Filtres de Sobel
dx = [-1 0 1; -2 0 2; -1 0 1];
dy = dx';

% Créer un filtre Gaussien sans utiliser fspecial
x = linspace(-w / 2, w / 2, max(1, fix(w)));
g = exp(-x.^2 / (2 * sigma^2)) / (sqrt(2 * pi) * sigma);

% Normaliser le filtre Gaussien
g = g / sum(g);

% Appliquer les filtres
Ix = conv2(imd, dx, 'same');
Iy = conv2(imd, dy, 'same');
Ix2 = conv2(Ix.^2, g, 'same');
Iy2 = conv2(Iy.^2, g, 'same');
Ixy = conv2(Ix.*Iy, g, 'same');

% Calcul de la matrice Harris
detM = Ix2 .* Iy2 - Ixy.^2;
trM = Ix2 + Iy2;
R = detM - lambda * trM.^2;

% Normalisation
R1 = (1000 / (1 + max(max(R)))) * R;

% Seuillage
[u, v] = find(R1 <= seuil);
nb = length(u);
for k = 1:nb
    R1(u(k), v(k)) = 0;
end

% Suppression des non-maxima locaux
R11 = zeros(m + 2 * r, n + 2 * r);
R11(r + 1:m + r, r + 1:n + r) = R1;
[m1, n1] = size(R11);
for i = r + 1:m1 - r
    for j = r + 1:n1 - r
        fenetre = R11(i - r:i + r, j - r:j + r);
        ma = max(max(fenetre));
        if fenetre(r + 1, r + 1) < ma
            R11(i, j) = 0;
        end
    end
end

% Afficher l'image avec les points d'intérêt détectés
axes(handles.axes2);
imshow(img);
hold on;
R11 = R11(r + 1:m + r, r + 1:n + r);
[x, y] = find(R11);
nb = length(x);
plot(y, x, '.r');
title(['Détection de ', num2str(nb), ' points d''intérêt']);
    
    
% --------------------------------------------------------------------
function Modele_electrostatique_Callback(hObject, eventdata, handles)
% Récupérer l'image courante
img = handles.courant_data;
% Vérifier si l'image est en couleur
if size(img, 3) == 3
    img = rgb2gray(img);
end
k = 0.04; 
sigma = 1; 
seuil = 100; 
r = 6;

imd = double(img);
dxa = [-sqrt(2)/4, 0, sqrt(2)/4; -1, 0, 1; -sqrt(2)/4, 0, sqrt(2)/4];  % forces attractives 
dya = dxa'; % derivée verticale

% Créer un filtre gaussien sans utiliser fspecial
[x, y] = meshgrid(-floor(5*sigma):floor(5*sigma), -floor(5*sigma):floor(5*sigma));
g = exp(-(x.^2 + y.^2) / (2*sigma^2));
g = g / sum(g(:));

Ixa = conv2(imd, dxa, 'same');
Iya = conv2(imd, dya, 'same');
Ixa2 = conv2(Ixa.^2, g, 'same');  
Iya2 = conv2(Iya.^2, g, 'same');
Ixya = conv2(Ixa.*Iya, g, 'same');

detM = Ixa2 .* Iya2 - Ixya.^2;
trM = Ixa2 + Iya2;
R = detM - k * (trM.^2);

% Normalisation
R1 = (1000 / (1 + max(max(R)))) * R;

% Seuillage
[u, v] = find(R1 <= seuil);
nb = length(u);
for k = 1:nb
    R1(u(k), v(k)) = 0;
end

R11 = zeros(size(img) + 2 * r);
R11(r+1:size(img, 1)+r, r+1:size(img, 2)+r) = R1;

for i = r+1:size(R11, 1)-r
    for j = r+1:size(R11, 2)-r
        fenetre = R11(i-r:i+r, j-r:j+r);
        ma = max(max(fenetre));
        if fenetre(r+1, r+1) < ma
            R11(i, j) = 0;
        end
    end
end

R11 = R11(r+1:size(img, 1)+r, r+1:size(img, 2)+r);

[x, y] = find(R11);
imageS = img;

axes(handles.axes2);
imshow(img);
hold on;
plot(y, x, '.r', 'MarkerSize', 10);
hold off;
