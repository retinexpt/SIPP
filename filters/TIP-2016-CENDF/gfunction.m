function g=gfunction(x)
%K=0.9-0.95 of B
initValue=0;
step=0.001;
endValue=ceil(max(x(:)));
K=mycdf(initValue,step,endValue,x(:));

g=x;
pos=find(x<=K);
pos2=find(x>K);
g(pos)=0.98*(1-(x(pos)/K).^2).^2+0.08;
%g(pos)=2;
g(pos2)=0.08;
end