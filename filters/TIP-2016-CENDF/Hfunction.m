function H=Hfunction(INPUT)
%将小于0的值置零
H=INPUT;     
H(H<0)=0;
end