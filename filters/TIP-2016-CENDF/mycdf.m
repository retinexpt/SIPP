function i=mycdf(initValue,step,endValue,sample)
temp=0;
totalNum=length(sample);
for i=initValue:step:endValue
    temp=length(find(sample<=i))/totalNum;
    if temp>=0.92
        break;
    end
end
end