function modifier_var_den
global baravancD  edittext3
    d=get(baravancD,'Value');
    den=num2str(d);
    set(edittext3,'String',den);