function varargout = InterfaceMatlab(varargin)
% INTERFACEMATLAB M-file for InterfaceMatlab.fig
%      INTERFACEMATLAB, by itself, creates a new INTERFACEMATLAB or raises the existing
%      singleton*.
%
%      H = INTERFACEMATLAB returns the handle to a new INTERFACEMATLAB or the handle to
%      the existing singleton*.
%
%      INTERFACEMATLAB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACEMATLAB.M with the given input arguments.
%
%      INTERFACEMATLAB('Property','Value',...) creates a new INTERFACEMATLAB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before InterfaceMatlab_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to InterfaceMatlab_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help InterfaceMatlab

% Last Modified by GUIDE v2.5 02-Jun-2012 10:56:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @InterfaceMatlab_OpeningFcn, ...
                   'gui_OutputFcn',  @InterfaceMatlab_OutputFcn, ...
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


% --- Executes just before InterfaceMatlab is made visible.
function InterfaceMatlab_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to InterfaceMatlab (see VARARGIN)

% Choose default command line output for InterfaceMatlab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes InterfaceMatlab wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = InterfaceMatlab_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function menuFichier_Callback(hObject, eventdata, handles)
% hObject    handle to menuFichier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuFPB_Callback(hObject, eventdata, handles)
% hObject    handle to menuFPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuLineaire_Callback(hObject, eventdata, handles)
% hObject    handle to menuLineaire (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuNonLineaire_Callback(hObject, eventdata, handles)
% hObject    handle to menuNonLineaire (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuOuvrir_Callback(hObject, eventdata, handles)
% hObject    handle to menuOuvrir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.*');
handles.ima = imread(sprintf('%s',path,file));
axes(handles.imgO)
handles.courant_data = handles.ima;
subimage(handles.courant_data);
axes(handles.imgT)
handles.ima_traite = 256;
subimage(handles.ima_traite);
handles.output = hObject;
guidata(hObject, handles);

% --------------------------------------------------------------------
function menuEnregistrer_Callback(hObject, eventdata, handles)
% hObject    handle to menuEnregistrer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = handles.ima_traite;
[file,path] = uiputfile('*.png','Enregistrer Votre Image ...');
imwrite(image, sprintf('%s',path,file),'png');

% --------------------------------------------------------------------
function menuQuitter_Callback(hObject, eventdata, handles)
% hObject    handle to menuQuitter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1)

% --------------------------------------------------------------------
function menuMedian_Callback(hObject, eventdata, handles)
% hObject    handle to menuMedian (see GCBO)
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
function menuMy33_Callback(hObject, eventdata, handles)
% hObject    handle to menuMy33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;
[n,m]=size(image);
image = double(image);
b=image;
H=(1/9)*[1 1 1 ; 1 1 1 ; 1 1 1 ];
for x = 2 : n-1
    for y = 2 : m-1
     %img(x,y)=mean([image(x-1,y-1)+image(x-1,y)+image(x-1,y+1)+image(x,y-1)+image(x,y)+image(x,y+1)+image(x+1,y-1)+image(x+1,y)+image(x+1,y+1)]);
      f=image(x-1:x+1,y-1:y+1);
      v=f.*H;
      %b=conv2(img,H);
      b(x,y)=sum(v(:));
      %b(x,y)=mean(f(:));
    end 
end
b=uint8(b);
%imshow(b);
axes(handles.imgT);
subimage(b);

% --------------------------------------------------------------------
function menuMy55_Callback(hObject, eventdata, handles)
% hObject    handle to menuMy55 (see GCBO)
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
handles.ima_traite = b;
handles.output = hObject;
guidata(hObject, handles);

% --------------------------------------------------------------------
function menuGaus33_Callback(hObject, eventdata, handles)
% hObject    handle to menuGaus33 (see GCBO)
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
handles.ima_traite = b;
handles.output = hObject;
guidata(hObject, handles);

% --------------------------------------------------------------------
function menuGauss55_Callback(hObject, eventdata, handles)
% hObject    handle to menuGauss55 (see GCBO)
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
handles.ima_traite = b;
handles.output = hObject;
guidata(hObject, handles);


% --------------------------------------------------------------------
function menuTransform_Callback(hObject, eventdata, handles)
% hObject    handle to menuTransform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuNegatif_Callback(hObject, eventdata, handles)
% hObject    handle to menuNegatif (see GCBO)
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
function menuContraste_Callback(hObject, eventdata, handles)
% hObject    handle to menuContraste (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;
%[n,m]=size(image);
image = double(image);
%output=image;

%ima=imread('cameraman.tif');
[l c]=size(image);
image = double(image);
v=image;
for i=1:l
    for j=1:c
      fpixel = (image(i,j)-128)*5 + 128; 
    % on vérifie que la valeur obtenue est bien dans [0..255]
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


% --------------------------------------------------------------------
function menuLuminos_Callback(hObject, eventdata, handles)
% hObject    handle to menuLuminos (see GCBO)
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
axes(handles.imgT);
subimage(v);

% --------------------------------------------------------------------
function menuBinaris_Callback(hObject, eventdata, handles)
% hObject    handle to menuBinaris (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I4 = handles.courant_data;
%****************************
% Calcule du seuil
%****************************
%calucle des m:
m0=1;
m1=mean2(I4);
m2=mean2(I4.^2);
m3=mean2(I4.^3);
%calcule des C:
C1=(m3-(m1*m2))/(m2-m1);
C0=(-m2-(C1*m1))/m0;
%calcule des z:
z1=(-C1-sqrt(C1^2-4*C0))/2;
z2=(-C1+sqrt(C1^2-4*C0))/2;
seuil=(z1+z2)/2;
% première solution:
% bin=zeros(240,320);
% for i=1:240
% for j=1:320
% if I4(i,j)>seuil;
% bin(i,j)=255;
% end
% end
% end
bin=(I4>seuil)*255;
text(2,10,num2str(seuil));
%
% Solution via matlab de la binarisation :
% level=graythresh(I4); %calcule seuil
% bin = im2bw(I4,level); %binarisation matlab
axes(handles.imgO);
subimage(I4);
axes(handles.imgT);
handles.ima_traite = bin;
subimage(handles.ima_traite);

%Grrr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function menuNivGris_Callback(hObject, eventdata, handles)
% hObject    handle to menuNivGris (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ima=handles.courant_data;
d = length(size(ima));
if d==3
    imagray=rgb2gray(ima);
elseif d==2
   imagray=ima;
end
axes(handles.imgT);
subimage(imagray);
% --------------------------------------------------------------------
function menuHistog_Callback(hObject, eventdata, handles)
% hObject    handle to menuHistog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = handles.courant_data;
d = length(size(img));
if d==3
    I = rgb2gray(img);
elseif d==2
    I = img;
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
function menuFPH_Callback(hObject, eventdata, handles)
% hObject    handle to menuFPH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuLaplac_Callback(hObject, eventdata, handles)
% hObject    handle to menuLaplac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;
%image=imnoise(imageO,'salt & pepper', 0.05);
[n,m]=size(image);
image = double(image);
%b=image;
[n m]=size(image);
b=zeros(n,m);
%M1=[0 1 0;1 -4 1;0 1 0];
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
function menuGradien_Callback(hObject, eventdata, handles)
% hObject    handle to menuGradien (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;
[n,m]=size(image);
image = double(image);
output=image;
%image=rgb2gray(image);
image=double(image);
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
%mymin=min(min(output))
%mymax=max(max(output))
for i=4:(m-3)
for j=4:(n-3)       
    output(i,j)=sqrt(outputhor(i,j)*outputhor(i,j) + outputver(i,j)*outputver(i,j));
end 
end 
%outputhor=uint8(outputhor); 
%outputver=uint8(outputver); 
output=uint8(output); 

%b=uint8(b);
axes(handles.imgT);
subimage(output);

%figure(10);colormap(gray(256));imagesc(outputhor);title('gradient hor'); 
%figure(11);colormap(gray(256));imagesc(outputver);title('gradient ver'); 
%figure(12);colormap(gray(256));imagesc(output);title('gradient');

% --------------------------------------------------------------------
function menuSobel_Callback(hObject, eventdata, handles)
% hObject    handle to menuSobel (see GCBO)
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
%maskhor = [-1,0,1;-b,0,b;-1,0,1]; 
%maskver = [-1,-b,-1;0,0,0;1,b,1];
%b=2 pour sobel
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
%mymin=min(min(output))
%mymax=max(max(output))
for i=4:(m-3)
   for j=4:(n-3) 
output(i,j)=sqrt(outputhor(i,j)*outputhor(i,j) + outputver(i,j)*outputver(i,j)); 
   end
end
%outputhor=uint8(outputhor); 
%outputver=uint8(outputver); 
output=uint8(output); 
axes(handles.imgT);
subimage(output);

%figure(10);colormap(gray(256));imagesc(outputhor);title(gradient hor); 
%figure(11);colormap(gray(256));imagesc(output);title(gradient ver); 
%figure(12);colormap(gray(256));imagesc(output);title(gradient);


% --------------------------------------------------------------------
function menuPrewit_Callback(hObject, eventdata, handles)
% hObject    handle to menuPrewit (see GCBO)
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
%maskhor = [-1,0,1;-b,0,b;-1,0,1]; 
%maskver = [-1,-b,-1;0,0,0;1,b,1];
%b=1 pour prewitt
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
%mymin=min(min(output))
%mymax=max(max(output))
for i=4:(m-3)
   for j=4:(n-3) 
output(i,j)=sqrt(outputhor(i,j)*outputhor(i,j) + outputver(i,j)*outputver(i,j)); 
   end
end
%outputhor=uint8(outputhor); 
%outputver=uint8(outputver); 
output=uint8(output); 
axes(handles.imgT);
subimage(output);

%figure(10);colormap(gray(256));imagesc(outputhor);title(gradient hor); 
%figure(11);colormap(gray(256));imagesc(output);title(gradient ver); 
%figure(12);colormap(gray(256));imagesc(output);title(gradient);


% --------------------------------------------------------------------
function menuRober_Callback(hObject, eventdata, handles)
% hObject    handle to menuRober (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = handles.courant_data;
[n,m]=size(image);
image = double(image);
 %num = get(handles.slider1, 'value');
% set(handles.edit1, 'String', num2str(num));
for x=1:n-1
 for y=1:m-1
  b(x,y)= abs(uint8( double(image(x,y))-double(image(x+1,y+1))))+ abs(uint8( double(image(x,y+1)) - double(image(x+1,y))));
 end
end
    % num = get(handles.slider1, 'Value');
    % set(handles.txt1, 'String', num2str(num));
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
%Grrr
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function menufiltrefreq_Callback(hObject, eventdata, handles)
% hObject    handle to menufiltrefreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuFpb_Callback(hObject, eventdata, handles)
% hObject    handle to menuFpb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

I = handles.courant_data;
 F=fftshift(fft2(I)); 
% %calcul de la taille de l'image; 
 M=size(F,1); 
 N=size(F,2); 
 P=size(F,3); 
 H0=zeros(M,N); 
 D0=10; 
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
function menuFpbb_Callback(hObject, eventdata, handles)
% hObject    handle to menuFpbb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


I = handles.courant_data;
%I = imread('eight.tif');

F=fftshift(fft2(I)); 
%calcul de la taille de l'image; 
M=size(F,1); 
N=size(F,2); 
P=size(F,3);

H0=zeros(M,N); 
D0=20; 
M2=round(M/2); 
N2=round(N/2); 
H0(M2-D0:M2+D0,N2-D0:N2+D0)=1; 

n=3; 

for i=1:M 
for j=1:N 
%H(i,j)=1/(1+(H0(i,j)/D0)^(2*n)); 
G(i,j)=F(i,j)*H0(i,j); 
end 
end 

g=ifft2(G); 

%subplot(1,2,1);imshow(I);title('image originale'); 
%subplot(1,2,2);
imshow(abs(g),[0,255]);%title('image filtrée'); 
% --------------------------------------------------------------------
function menuFph_Callback(hObject, eventdata, handles)
% hObject    handle to menuFph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I=handles.courant_data;
%charge; 
F=fftshift(fft2(I)); 
%calcul de la taille de l'image; 
M=size(F,1); 
N=size(F,2); 
P=size(F,3); 

H1=ones(M,N); 
D0=3; 
M2=round(M/2); 
N2=round(N/2); 
H1(M2-D0:M2+D0,N2-D0:N2+D0)=0; 
for i=1:M 
for j=1:N 
G(i,j)=F(i,j)*H1(i,j); 
end 
end 
g=ifft2(G); 
%subplot(1,2,1);imshow(I);title('image originale'); 
%subplot(1,2,2);
imshow(255-abs(g),[0,255]);
%title('image filtrée');

% --------------------------------------------------------------------
function menuFphb_Callback(hObject, eventdata, handles)
% hObject    handle to menuFphb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


I=handles.courant_data;

F=fftshift(fft2(I)); 
%calcul de la taille de l'image; 
M=size(F,1); 
N=size(F,2); 
P=size(F,3); 

H1=ones(M,N); 
D0=3; 
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

%subplot(1,2,1);imshow(I);title('image originale'); 
%subplot(1,2,2);
imshow(255-abs(g),[0,255]);%title('image filtrée');


% --------------------------------------------------------------------
function menuConique_Callback(hObject, eventdata, handles)
% hObject    handle to menuConique (see GCBO)
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
function menuPiramid_Callback(hObject, eventdata, handles)
% hObject    handle to menuPiramid (see GCBO)
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
handles.ima_traite = b;
handles.output = hObject;
guidata(hObject, handles);

