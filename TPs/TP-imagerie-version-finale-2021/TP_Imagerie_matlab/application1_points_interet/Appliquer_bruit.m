function Appliquer_bruit
global checkBruit popupMethodebruit baravancD
global baravancV baravancM edittext1 edittext2 edittext3

a=get(checkBruit,'value');

if a 
   set(popupMethodebruit, 'Enable', 'on');
   set(baravancV, 'Enable', 'on');
   set(baravancM, 'Enable', 'on');
   set(baravancD, 'Enable', 'on');
   set(edittext1, 'Enable', 'on');
   set(edittext2, 'Enable', 'on');
   set(edittext3, 'Enable', 'on');
else
   set(popupMethodebruit, 'Enable', 'off');
   set(baravancV, 'Enable', 'off');
   set(baravancM, 'Enable', 'off');
   set(baravancD, 'Enable', 'off');
   set(edittext1, 'Enable', 'off');
   set(edittext2, 'Enable', 'off');
   set(edittext3, 'Enable', 'off');
   affich_image;
  appliquerAll;
end