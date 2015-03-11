function score=dtw(input,template)
%
% Computes the Dynamic Time Warping score between an input and a template
% using euclidean distance.  (NOTE: this assumes that all dimensions are 
% equally important, which is probably not true for things like MFCCs, where a
% mahalanobis distance might be more appropriate, but oh well. :-)
%
% Assumes that input and template's columns vary by time, and that the rows
% represent different dimensions of the input (e.g. cepstral coefficients)
%


N=size(template,2);
M=size(input,2);

gscore=ones(1,M+1)*Inf;
gscore(1)=0;
newgscore=gscore;

for i=1:N
  D=repmat(template(:,i),1,M);
  %compute local distance
  L=[Inf sum((D-input).^2,1).^0.5];

  for j=2:M+1
    newgscore(j)=min([gscore(j),gscore(j-1),newgscore(j-1)])+L(j);
  end
  gscore=newgscore;
end

score=gscore(M+1);
