function limiter_suielle
global editSeuille startPlus startMoins
str=get(editSeuille,'String');
a=Str2num(char(str));

if a>30 
%     set(editSeuille,'enable','off');
    set(editSeuille,'String','20');
 errordlg('le seuille doit étre compris entre 10 et 30');
elseif a<10
   set(editSeuille,'String','20');
   errordlg('le seuille doit étre compris entre 10 et 30'); 
end