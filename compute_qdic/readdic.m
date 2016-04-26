qdicfname = @(x) sprintf('/raid5/Mikhail/QDIC/dic_cell_40x/z_yellow_fast_process/0_0_1_%d_QDIC.tif',x);
intfname = @(x) sprintf('/raid5/Mikhail/QDIC/dic_cell_40x/z_yellow_fast_process/0_0_1_%d_int.tif',x);
jampfname = @(x) sprintf('/raid5/Mikhail/QDIC/dic_cell_40x/z_yellow_fast_process/0_0_1_%d_jamp.tif',x);
qdicimg=[];
intimg = [];
jampimg = [];
xrange=100:800;
for x=xrange
    disp(['QDIC: ' num2str(x)]);
    curqdicimg=imread(qdicfname(x));%imagesc(foo);axis image;colormap(gray);
    qdicimg(:,:,x-xrange(1)+1)=curqdicimg;
    
end
qdicimg=qdicimg(:,:,2:end);
writetif(qdicimg,'qdic_hela_cell_40x.tif');

for x=xrange
    disp(['Intensity' num2str(x)]);
    curintimg=imread(intfname(x));%imagesc(foo);axis image;colormap(gray);
    intimg(:,:,x-xrange(1)+1)=curintimg;
    
end
intimg=intimg(:,:,2:end);
writetif(intimg,'int_hela_cell_40x.tif');

for x=xrange
    disp(['Jamp: ' num2str(x)]);
    curjampimg=imread(jampfname(x));%imagesc(foo);axis image;colormap(gray);
    jampimg(:,:,x-xrange(1)+1)=curjampimg;
    
end
jampimg=jampimg(:,:,2:end);
writetif(jampimg,'jamp_hela_cell_40x.tif');