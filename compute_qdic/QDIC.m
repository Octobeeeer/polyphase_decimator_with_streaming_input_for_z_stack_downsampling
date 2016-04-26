function [deltaPhi,sinval,cosval,inten,jamp]=QDIC(A,B,C,D,comp)
%     h= fspecial('gaussian',[25 25],2);
%     A=imfilter(A,h);
%     B=imfilter(B,h);
%     C=imfilter(C,h);
%     D=imfilter(D,h);
inten = (A+C+B+D)/4;
cosval = (C-A)./inten;
sinval = (B-D)./inten;
deltaPhi = atan2(sinval,cosval);
jamp = sqrt(cosval.^2+sinval.^2);
end