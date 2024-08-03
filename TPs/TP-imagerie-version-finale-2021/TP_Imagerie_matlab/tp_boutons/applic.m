function varargout = applic(varargin)
% APPLIC M-file for applic.fig
%      APPLIC, by itself, creates a new APPLIC or raises the existing
%      singleton*.
%
%      H = APPLIC returns the handle to a new APPLIC or the handle to
%      the existing singleton*.
%
%      APPLIC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APPLIC.M with the given input arguments.
%
%      APPLIC('Property','Value',...) creates a new APPLIC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before applic_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to applic_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help applic

% Last Modified by GUIDE v2.5 31-May-2012 22:34:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @applic_OpeningFcn, ...
                   'gui_OutputFcn',  @applic_OutputFcn, ...
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

% --- Executes just before applic is made visible.
function applic_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to applic (see VARARGIN)

% Choose default command line output for applic
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes applic wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = applic_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in brG.
function brG_Callback(hObject, eventdata, handles)
% hObject    handle to brG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=imread('cameraman.TIF');
imagray=rgb2gray(image);
imshow(imagray);


% --- Executes on button press in moy3.
function moy3_Callback(hObject, eventdata, handles)
% hObject    handle to moy3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%function [b]=Filtre_Moy(image)
%image=imread('cameraman.TIF');
imageO=imread('cameraman.TIF');
image=imnoise(imageO,'salt & pepper', 0.05);

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
imshow(b);


% --- Executes on button press in moy5.
function moy5_Callback(hObject, eventdata, handles)
% hObject    handle to moy5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%image=imread('cameraman.TIF');
imageO=imread('cameraman.TIF');
image=imnoise(imageO,'salt & pepper', 0.05);

[n,m]=size(image);
image = double(image);
b=image;
H=(1/25)*[1 1 1 1 1 ; 1 1 1 1 1 ; 1 1 1 1 1 ; 1 1 1 1 1 ; 1 1 1 1 1];
for x = 3 : n-2
    for y = 3 : m-2
     %img(x,y)=mean([image(x-2,y-2)+image(x-1,y-2)+image(x,y-2)+image(x+1,y-2)+image(x+2,y-2)+image(x-2,y-1)+image(x-2,y)+image(x-2,y+1)+image(x-2,y+2)+image(x+2,y-1)+image(x+2,y)+image(x+2,y+1)+image(x+2,y+2)+image(x-1,y+2)+image(x,y+2)+image(x+1,y+2)+image(x-1,y-1)+image(x-1,y)+image(x-1,y+1)+image(x,y-1)+image(x,y)+image(x,y+1)+image(x+1,y-1)+image(x+1,y)+image(x+1,y+1)]);
     f=image(x-2:x+2,y-2:y+2);
      v=f.*H;
      %b=conv2(img,H);
      b(x,y)=sum(v(:));
     % b(x,y)=mean(f(:));
    end 
end
b=uint8(b);
imshow(b);



% --- Executes on button press in goussien3.
function goussien3_Callback(hObject, eventdata, handles)
% hObject    handle to goussien3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%image=imread('cameraman.TIF');
imageO=imread('cameraman.TIF');
image=imnoise(imageO,'salt & pepper', 0.05);

[n,m]=size(image);
image = double(image);
b=image;
H=(1/16)*[1 2 1 ;2 4 2 ; 1 2 1];
for x = 2 : n-1
    for y = 2 : m-1
     %img(x,y)=mean([image(x-1,y-1)+image(x-1,y)*2+image(x-1,y+1)+image(x,y-1)*2+image(x,y)*4+image(x,y+1)*2+image(x+1,y-1)+image(x+1,y)*2+image(x+1,y+1)]);
      f=image(x-1:x+1,y-1:y+1);
      v=f.*H;
      b(x,y)=sum(v(:));
     %b=conv2(img,H);
     % b(x,y)=mean(f(:));
    end 
end
b=uint8(b);
imshow(b);


% --- Executes on button press in goussien5.
function goussien5_Callback(hObject, eventdata, handles)
% hObject    handle to goussien5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%image=imread('cameraman.TIF');
imageO=imread('cameraman.TIF');
image=imnoise(imageO,'salt & pepper', 0.05);
[n,m]=size(image);
image = double(image);
b=image;
H=(1/256)*[1 4 6 4 1 ; 4 16 24 16 4 ; 6 24 36 24 6 ; 4 16 24 16 4 ; 1 4 6 4 1];
for x = 3 : n-2
    for y = 3 : m-2
     %img(x,y)=mean([image(x-1,y-1)+image(x-1,y)*2+image(x-1,y+1)+image(x,y-1)*2+image(x,y)*4+image(x,y+1)*2+image(x+1,y-1)+image(x+1,y)*2+image(x+1,y+1)]);
      f=image(x-2:x+2,y-2:y+2);
      v=f.*H;
      b(x,y)=sum(v(:));
     %b=conv2(img,H);
     % b(x,y)=mean(f(:));
    end 
end
b=uint8(b);
imshow(b);



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in brsel.
function brsel_Callback(hObject, eventdata, handles)
% hObject    handle to brsel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=imread('cameraman.TIF');
imgBr=imnoise(image,'salt & pepper', 0.05);
imshow(imgBr);



% --- Executes on button press in median.
function median_Callback(hObject, eventdata, handles)
% hObject    handle to median (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I4 = handles.courant_data;
%blanc = imnoise(I4,'poisson'); %création du bruit sur l’image
L = medfilt2(I4,[3 3]);
axes(handles.imaS);
subimage(I4);
axes(handles.imaT);
handles.ima_traite = L;
subimage(handles.ima_traite);

%Grrr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in deriv.
function deriv_Callback(hObject, eventdata, handles)
% hObject    handle to deriv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I4 = derive(handles.courant_data);
axes(handles.imaS);
subimage(handles.courant_data);
axes(handles.imaT);
handles.ima_traite = I4;
subimage(handles.ima_traite);

%Grrr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);









% --- Executes on button press in inver.
function inver_Callback(hObject, eventdata, handles)
% hObject    handle to inver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = handles.courant_data;
handles.ima_traite = imrotate(img,180);
axes(handles.imaS);
subimage(img);
axes(handles.imaT);
subimage(handles.ima_traite);

%Grrr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in bina.
function bina_Callback(hObject, eventdata, handles)
% hObject    handle to bina (see GCBO)
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
axes(handles.imaS);
subimage(I4);
axes(handles.imaT);
handles.ima_traite = bin;
subimage(handles.ima_traite);

%Grrr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in segm.
function segm_Callback(hObject, eventdata, handles)
% hObject    handle to segm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I4 = handles.courant_data;%rgb2gray(y);
blanc = I4 ;%imnoise(I4,'gaussian');
bin1=(blanc<50)*25;
bin2=((49<blanc) & (blanc<100))*75;
bin3=((99<blanc) & (blanc<150))*125;
bin4=((149<blanc) & (blanc<200))*175;
bin5=(199<blanc)*225;
seg=uint8(bin1+bin2+bin3+bin4+bin5);
axes(handles.imaS);
subimage(blanc);
axes(handles.imaT);
handles.ima_traite = seg;
subimage(handles.ima_traite);

%Grrr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in histog.
function histog_Callback(hObject, eventdata, handles)
% hObject    handle to histog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im = handles.courant_data;
% création de l’histogramme manuellement
%histo=zeros(256);
% for j=1:320
% for i=1:240
% histo(I4(i,j)+1)=histo(I4(i,j)+1)+1;
%
% end
% end
d = length(size(im));
if d==3
    I4 = rgb2gray(im);
elseif d==2
    I4 = im;
end


axes(handles.imaS);
subimage(I4);
axes(handles.imaT);
handles.ima_traite = imhist(I4) ; % histogramme via matlab
imhist(I4) ;
%Grrr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);




% --- Executes on button press in Cont_sobl.
function Cont_sobl_Callback(hObject, eventdata, handles)
% hObject    handle to Cont_sobl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I4 = sobelprewitt(handles.courant_data,4);
axes(handles.imaS);
subimage(handles.courant_data);
axes(handles.imaT);
handles.ima_traite = I4;
subimage(handles.ima_traite);

%Grrr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in sobel.
function sobel_Callback(hObject, eventdata, handles)
% hObject    handle to sobel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I4 = EdgeCheck(handles.courant_data,'sobel');
axes(handles.imaS);
subimage(handles.courant_data);
axes(handles.imaT);
handles.ima_traite = I4;
subimage(handles.ima_traite);

%Grrr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in prewitt.
function prewitt_Callback(hObject, eventdata, handles)
% hObject    handle to prewitt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I4 = EdgeCheck(handles.courant_data,'prewitt');
axes(handles.imaS);
subimage(handles.courant_data);
axes(handles.imaT);
handles.ima_traite = I4;
subimage(handles.ima_traite);

%Grrr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in robert.
function robert_Callback(hObject, eventdata, handles)
% hObject    handle to robert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Chargement de l’image
I4 = EdgeCheck(handles.courant_data,'roberts');
axes(handles.imaS);
subimage(handles.courant_data);
axes(handles.imaT);
handles.ima_traite = I4;
subimage(handles.ima_traite);

%Grrr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in Cont_Lapla.
function Cont_Lapla_Callback(hObject, eventdata, handles)
% hObject    handle to Cont_Lapla (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I4 = contourlaplacien(handles.courant_data);
% L = imfilter(I4,3,'circular','conv');
% wnr1 = deconvwnr(L,3);
axes(handles.imaS);
subimage(handles.courant_data);
axes(handles.imaT);
handles.ima_traite = I4;
subimage(handles.ima_traite);

%Grrr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% --- Executes on button press in detc_cont.
function detc_cont_Callback(hObject, eventdata, handles)
% hObject    handle to detc_cont (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I4 = handles.courant_data;
%blanc = imnoise(I4,'gaussian');
BW1 = edge(I4,'prewitt');
axes(handles.imaS);
subimage(I4);
axes(handles.imaT);
handles.ima_traite = BW1;
subimage(handles.ima_traite);


%Grrr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in marr.
function marr_Callback(hObject, eventdata, handles)
% hObject    handle to marr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I4 = EdgeCheck(handles.courant_data,'marr');
axes(handles.imaS);
subimage(handles.courant_data);
axes(handles.imaT);
handles.ima_traite = I4;
subimage(handles.ima_traite);

%Grrr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in canny.
function canny_Callback(hObject, eventdata, handles)
% hObject    handle to canny (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I4 = EdgeCheck(handles.courant_data,'canny');
axes(handles.imaS);
subimage(handles.courant_data);
axes(handles.imaT);
handles.ima_traite = I4;
subimage(handles.ima_traite);

%Grrr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in bcharger.
function bcharger_Callback(hObject, eventdata, handles)
% hObject    handle to bcharger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.*');
%Chargement de l'image et affichage
handles.ima = imread(sprintf('%s',path,file));
%Affichage de l'aperçu
axes(handles.imaS)
handles.courant_data = handles.ima;
subimage(handles.courant_data);
axes(handles.imaT)
handles.ima_traite = 256;
subimage(handles.ima_traite);

%Grrrrrrrr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = handles.ima_traite;
[file,path] = uiputfile('*.png','Enregistrer Votre Image ...');
imwrite(image, sprintf('%s',path,file),'png');



% --- Executes on button press in quitter.
function quitter_Callback(hObject, eventdata, handles)
% hObject    handle to quitter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1)


% --- Executes on button press in Mor_cont.
function Mor_cont_Callback(hObject, eventdata, handles)
% hObject    handle to Mor_cont (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I4 = handles.courant_data;%rgb2gray(y);
h1=[0 1 0;
    1 1 1;
    0 1 0];
img= imnoise(I4,'salt & pepper',0.01);
img1 = imerode(I4,h1);
img2 = imdilate(I4,h1);
img5= abs(img2-img1);
axes(handles.imaS);
subimage(I4);
axes(handles.imaT);
handles.ima_traite =img5;
subimage(handles.ima_traite);

%Grrr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in ouver.
function ouver_Callback(hObject, eventdata, handles)
% hObject    handle to ouver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I = handles.courant_data;
Ic = imcomplement(I); % inverse vidéo de l’image de départ
SE = strel('ball',5,5);
Iouv = imopen(Ic,SE);
axes(handles.imaS);
subimage(handles.courant_data);
axes(handles.imaT);
handles.ima_traite = imcomplement(Iouv);
subimage(imcomplement(Iouv));

%Grrr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);




% --- Executes on button press in ferm.
function ferm_Callback(hObject, eventdata, handles)
% hObject    handle to ferm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I = handles.courant_data;
Ic = imcomplement(I); % inverse vidéo de l’image de départ
SE = strel('ball',5,5);
Iferm = imclose(Ic,SE);
axes(handles.imaS);
subimage(handles.courant_data);
axes(handles.imaT);
handles.ima_traite = imcomplement(Iferm);
subimage(imcomplement(Iferm));

%Grrr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);




