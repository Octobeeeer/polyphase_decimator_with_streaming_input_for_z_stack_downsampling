%Downsample the xy dimension , make the size change by a factor. 
clc;
close all;
clear all;
Ma = 0.5; %Downsampling factor in xy
curfolder = '/Users/Tan_Nguyen/Documents/Data_for_QDIC/Embryo_20x_checkpoint_8';
outdir = '/Users/Tan_Nguyen/Documents/Data_for_QDIC/Embryo_20x_checkpoint_8_true_scale';
ff=0;
tt=0;
chh=1;
ii=0;
cc=0;
rr=0;
zz = 677:819
fname =@(odir,f,t,i,ch,c,r,z,s) sprintf('%s/f%d_t%d_i%d_ch%d_c%d_r%d_z%d_%s.tif',odir,f,t,i,ch,c,r,z,s);

%Now, go downsampling the data
%p=gcp;
%delete(p);
%p=parpool(4);
ss = {'qdic'};

    for z=zz
        for f=ff
            for t=tt
                for i=ii
                    for ch=chh
                        for c=cc
                            for r=rr
                                for s=ss
                                    disp(['Current z: ' num2str(z) ', mode: ' char(s)])
                                    curim = imread(fname(curfolder,f,t,i,ch,c,r,z,char(s)));
                                    outname = fname(outdir,f,t,i,ch,c,r,z,char(s));
                                    if (~strcmp(s,'qdic'))
                                        curim_resize = cast(imresize(curim,Ma),'uint16');
                                        writeTIFF(curim_resize,outname,'uint16');
                                    else
                                        curim_resize = cast(imresize(curim,Ma),'double');
                                        writeTIFF(curim_resize,outname);
                                    end
                                end
                                
                            end
                        end
                    end
                end
            end
        end
    end
%end



