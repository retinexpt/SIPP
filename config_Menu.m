function config_Menu(menu_handle, ui_name, cb_func)

char_pos = strfind(ui_name,'\');
if char_pos>0
	sub_menu_name = ui_name(1:char_pos-1);
	%find submenu first
	sub_menu = get(menu_handle,'Children');
	if length(sub_menu)
		for ss=1:length(sub_menu)
			label = get(sub_menu(ss),'Label');
			if strcmpi(label, sub_menu_name) == 1
				ui_name = ui_name(char_pos+1:length(ui_name));
				config_Menu(sub_menu(ss),ui_name,cb_func);		
				return;
			end
		end
	end
	
	sub_menu = uimenu(menu_handle,'Label',sub_menu_name);
	ui_name = ui_name(char_pos+1:length(ui_name));
	config_Menu(sub_menu,ui_name,cb_func);	

else
	%no sub menu
	item_handle = uimenu(menu_handle,'Label',ui_name,'Callback',cb_func);
end