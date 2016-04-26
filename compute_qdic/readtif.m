function [d]= readtif(filename)
foo=imfinfo(filename);
z=length(foo);
w=foo(1).Width;
h=foo(1).Height;
d=zeros(h,w,z,'single');
for i=1:z
    d(:,:,i)=imread(filename,i);
end
end