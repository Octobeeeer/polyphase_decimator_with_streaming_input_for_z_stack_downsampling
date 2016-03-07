%Downsample z-stack with an integer factor. The input is band-passed with a
%bandpass-filter
clc;
close all;
clear all;
Md = 3; %Downsampling factor in z
Mu = 2; %Upsampling factor in z. The combined factor between downsampling and upsampling will be a new resampling factor of Mu/Mz
L = 19; %Filter length
h = fir1(L,1/Md*0.9);
figure(1);freqz(h,1,1024);
title('(Downsampling filter) Frequency response.');


%Dimension of each image
curfolder = '/Volumes/Tan_750GB/QDIC/Embryo_data_for_tomography_March_4/Checkpoint_7_63x_dx_eq_dz_0_1_um/';
outdir = '/Volumes/Tan_750GB/QDIC/Embryo_data_for_tomography_March_4/Checkpoint_7_40x_z_0_15/';
ff=0;
tt=0;
chh=1;
ii=0;
cc=0;
rr=0;
zz = 11:2396;
mm=0:3;
fname =@(odir,f,t,i,ch,c,r,z,m) sprintf('%s/f%d_t%d_i%d_ch%d_c%d_r%d_z%d_m%d.tif',odir,f,t,i,ch,c,r,z,m);
%Get dimension of the first image
tempim = imread(fname(curfolder,ff(1),tt(1),ii(1),chh(1),cc(1),rr(1),zz(1),mm(1)));
nrows = size(tempim,1);
ncols = size(tempim,2);


%Now, go downsampling the data
p=gcp;
delete(p);
p=parpool(4);


hr = fir1(L,1/max(Mu,Md)*0.9);
figure(1);freqz(hr,1,1024);
title('(Resampling filter) Frequency response.');
disp(['Downsampling: ' num2str(Md) 'x, upsampling: ' num2str(Mu) 'x...']);
    
%Polyphase filtering, make sure the length of the polyphase filter is  
h_L = length(hr(:));
h_L1 = ceil(h_L/lcm(Md,Mu))*lcm(Md,Mu); %Make sure the length of the filter is a multiple of Mu and Md. This will make the indexing less...crazy.
%Zeropad the data with 0 to make the filter polyphase
h_poly = [hr(:);zeros(h_L1-h_L,1)];
%Select polyphase filter
h_poly_length = h_L1/Md; %Length of each polyphase filter

    
newdatalength = ceil(length(zz)*Mu/Md)*Md;%Make sure the new size is is 
disp(['Original data length: ' num2str(length(zz)) ', new length after upsampling: ' num2str(newdatalength)]);
    for m=mm
        for f=ff
            for t=tt
                for i=ii
                    for ch=chh
                        for c=cc
                            for r=rr
                                input_buffer = zeros(nrows,ncols,size(h_poly,1));%Buffer the input
                                outputidx = 1;
                                lastidx_non_upsampled = 0; %This is the indices of the original dataset that was added and not upsampled
                                lastposition_non_upsampled = 0; %Position of the last non-upsampled data
                                    
                                for sampleidx = 1:Md:newdatalength
                                    disp(['Processing at: ' num2str(outputidx) '/' num2str(newdatalength/Md) ' frameidx: ' num2str(m)]);
                                    lastidx = sampleidx; %These are the indices in the upsampled dataset
                                    firstidx = lastidx - Md +1;
                                    if (lastidx ==1)
                                        curim = cast(imread(fname(curfolder,f,t,i,ch,c,r,zz(lastidx),m)),'single');
                                        input_buffer(:,:,1) = curim;
                                        lastidx_non_upsampled = 1; %Only the first sample added
                                        lastposition_non_upsampled = 1; %It is at position 1
                                    else
                                        input_buffer = circshift(input_buffer,Md,3);
                                        lastposition_non_upsampled = lastposition_non_upsampled+Md; %Update the location of the last sample
                                       
                                        while (lastposition_non_upsampled>Mu)
                                           lastidx_non_upsampled = lastidx_non_upsampled+1;
                                           curim = cast(imread(fname(curfolder,f,t,i,ch,c,r,zz(lastidx_non_upsampled),m)),'single'); %Read next image in
                                           lastposition_non_upsampled = lastposition_non_upsampled-Mu; %Calculate its new position
                                           input_buffer(:,:,lastposition_non_upsampled)=curim;
                                        end
                                        
                                    end
                                    outputim = cast(sum(input_buffer.*repmat(reshape(h_poly,[1 1 length(h_poly(:))]),...
                                                    [size(input_buffer,1),size(input_buffer,2),1]),3),'uint16');
                               
                                    if ((sampleidx>=(h_L1))&(sampleidx<(newdatalength-h_L1)))
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



