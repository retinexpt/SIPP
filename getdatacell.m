function structA = getdatacell(hFig)

global structArray;

idx = uint16(get(hFig, 'UserData'));

if idx == 0
	structA = [];
else
	structA = structArray(idx);
end