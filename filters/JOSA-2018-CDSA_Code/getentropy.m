function entropy=getentropy(list)
    entropy=list/sum(list(:));
    entropy=entropy(entropy~=0);
    entropy=-entropy.*(log2(entropy));
    entropy=sum(entropy);
end