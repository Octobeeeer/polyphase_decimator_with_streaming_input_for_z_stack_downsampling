%Downsample z-stack with an integer factor. The input is band-passed with a
%bandpass-filter
clc;
close all;
clear all;
Mz = 2; %Downsampling factor in z
L = 19; %Filter length
h = fir1(L,1/Mz*0.9);
freqz(h,1,1024);
title('Frequency response.');
%Dimension of each image
curfolder = 'H:\checkpoint7_zee_high_na\';
outdir = 'C:\Embryo_checkpoint_7_ds\';
ff=0;
tt=0;
chh=1;
ii=0;
cc=0;
rr=0;
zz = 1:4812;
mm=0:3;
fname =@(odir,f,t,i,ch,c,r,z,m) sprintf('%s\\f%d_t%d_i%d_ch%d_c%d_r%d_z%d_m%d.tif',odir,f,t,i,ch,c,r,z,m);
%Get dimension of the first image
tempim = imread(fname(curfolder,ff(1),tt(1),ii(1),chh(1),cc(1),rr(1),zz(1),mm(1)));
nrows = size(tempim,1);
ncols = size(tempim,2);

%Polyphase filtering on the input
h_L = length(h(:));
h_L1 = ceil(h_L/Mz)*Mz;
%Zeropad the data with 0 to make the filter polyphase
h_poly = [h(:);zeros(h_L1-h_L,1)];
%Select polyphase filter
h_poly_length = h_L1/Mz; %Length of each polyphase filter


%Before moving, make sure the length of zz is a multiple of Mz
zz = zz(1:floor(length(zz)/Mz)*Mz);
datalength = length(zz);
%Now, go downsampling the data
p=gcp;
delete(p);
p=parpool(4);
parfor m=mm
    for f=ff
        for t=tt
            for i=ii
                for ch=chh
                    for c=cc
                        for r=rr
                            input_buffer = zeros(nrows,ncols,size(h_poly,1));%Buffer the input
                            outputidx = 1;
                            for sampleidx = 1:Mz:datalength
                                disp(['Processing at: ' num2str(outputidx) '/' num2str(datalength/Mz) ' frameidx: ' num2str(m)]);
                                lastidx = sampleidx;
                                firstidx = lastidx - Mz +1;
                                if (lastidx ==1)
                                    curim = cast(imread(fname(curfolder,f,t,i,ch,c,r,zz(lastidx),m)),'single');
                                    input_buffer(:,:,1) = curim;
                                else
                                    input_buffer = circshift(input_buffer,Mz,3);
                                    %Read M images and save in the reverse
                                    %order
                                    for idx2 = 1:Mz
                                            curim = cast(imread(fname(curfolder,f,t,i,ch,c,r,zz(lastidx-(idx2-1)),m)),'single');
                                            input_buffer(:,:,idx2)=curim;
                                    end
                                end
                                outputim = cast(sum(input_buffer.*repmat(reshape(h_poly,[1 1 length(h_poly(:))]),...
                                                [size(input_buffer,1),size(input_buffer,2),1]),3),'uint16');
                                %Be very careful when saving the data...We
                                %don't want to save anything that relates
                                %to the boundary...Modify the input buffer
                                %to do replication if you really need to
                                %use the first few frames.
                                if ((sampleidx>=(h_L1))&(sampleidx<(datalength-h_L1)))
                                    outname = fname(outdir,f,t,i,ch,c,r,outputidx,m);
                                    writeTIFF(outputim,outname,'uint16');
                                end
                                outputidx = outputidx+1;
                            end
                        end
                    end
                end
            end
        end
    end
end


