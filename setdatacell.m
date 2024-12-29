function setdatacell(varargin)
%set the global dataArray and figure handles

global structArray;

handle = varargin{1};
idx = uint16(get(handle, 'UserData'));

findidx = 0;
if idx > 0
    for r=1:numel(structArray)
        if structArray(r).handle_index == idx
            findidx = 1;
            break;
        end
    end
else
    for r=1:numel(structArray)
        if isempty(structArray(r).imgArray) == 1
            idx = r;
            set(handle,'UserData',double(idx))
            structArray(r).handle_index = idx;
            findidx = 1;
            break;
        end
    end
end

if findidx == 0
    idx = 1+numel(structArray);
    set(handle,'UserData',double(idx));
end

if nargin==6
    structArray(idx).handle_index = idx;
    structArray(idx).Fig=varargin{1};
    structArray(idx).imgArray=varargin{2};
    structArray(idx).cmap=varargin{3};
    structArray(idx).isModified=varargin{4};
    structArray(idx).imgfilename=varargin{5};
    structArray(idx).imginfo=varargin{6};
else    
    structArray(idx).handle_index = -1;
    structArray(idx).Fig=[];
    structArray(idx).imgArray=[];
    structArray(idx).cmap=[];
    structArray(idx).isModified=[];
    structArray(idx).imgfilename=[];
    structArray(idx).imginfo=[];
end
