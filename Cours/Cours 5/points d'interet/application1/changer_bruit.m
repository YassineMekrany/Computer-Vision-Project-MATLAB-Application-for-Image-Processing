function changer_bruit
global  popupMethodebruit baravancV baravancM edittext1 edittext2 
global  labelM labelV labelD baravancD edittext3

num_bruit = get(popupMethodebruit, 'Value');

if num_bruit==1
    
  set(labelM, 'Visible', 'on');
  set(labelV, 'Visible', 'on');
  set(baravancV, 'Visible', 'on');
  set(baravancM, 'Visible', 'on');
  set(edittext1, 'Visible', 'on');
  set(edittext2, 'Visible', 'on');
  
  set(labelD, 'Visible', 'off');
  set(baravancD, 'Visible', 'off');
  set(edittext3, 'Visible', 'off');
end  

if num_bruit==2
   
  set(labelM, 'Visible', 'off');
  set(labelV, 'Visible', 'off');
  set(labelD, 'Visible', 'on');
  set(labelD, 'string', 'densité');
  
  set(baravancM, 'Visible', 'off');
  set(baravancV, 'Visible', 'off');
  set(baravancD, 'Visible', 'on');
  set(baravancD, 'Value', 0.1);

  set(edittext1, 'Visible', 'off');
  set(edittext2, 'Visible', 'off');
  set(edittext3, 'Visible', 'on');
  set(edittext3, 'string', '0.1');
end 

if num_bruit==3
    
  set(labelM, 'Visible', 'off');
  set(labelV, 'Visible', 'off');
  set(labelD, 'Visible', 'on');
  set(labelD, 'string', 'variance');
  
  set(baravancM, 'Visible', 'off');
  set(baravancV, 'Visible', 'off');
  set(baravancD, 'Visible', 'on');
  set(baravancD, 'Value', 0.04);

  set(edittext1, 'Visible', 'off');
  set(edittext2, 'Visible', 'off');
  set(edittext3, 'Visible', 'on');
  set(edittext3, 'string', '0.04');
   
end     