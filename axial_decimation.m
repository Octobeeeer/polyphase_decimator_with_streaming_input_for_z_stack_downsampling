%Downsample the xy dimension , make the size change by a factor. 
clc;
close all;
clear all;
Ma = 0.9375; %Downsampling factor in xy
curfolder = 'D:\Mikhail\QDIC\Embryos_2016_02_26\checkpoint5_zee_timelapse';
outdir = 'D:\Mikhail\QDIC\Embryos_2016_02_26\40x_data\Checkpoint5_zee_timelapse\Raw_frames';
ff=0;
tt=5;
chh=1;
ii=0;
cc=0;
rr=0;
zz = 0:1024;
fname =@(odir,f,t,i,ch,c,r,z,s) sprintf('%s\\f%d_t%d_i%d_ch%d_c%d_r%d_z%d_%s.tif',odir,f,t,i,ch,c,r,z,s);

%Now, go downsampling the data
%p=gcp;
%delete(p);
%p=parpool(4);
override = 1;
frametype = 'raw';
if (strcmp(frametype,'raw'))
    ss = {'m0','m1','m2','m3'}; 
else
    ss = {'qdic'};    
end
    for f=ff
        for z=zz
            for t=tt
                for i=ii
                    for ch=chh
                        for c=cc
                            for r=rr
                                for s=ss
                                    disp(['Current z: ' num2str(z) ', mode: ' char(s)])
                                    curname = fname(curfolder,f,t,i,ch,c,r,z,char(s));
                                    outname = fname(outdir,f,t,i,ch,c,r,z,char(s));
                                    if ((exist(curname)&(~exist(outname)))|override)
                                        curim = imread(curname);
                                        if (~strcmp(s,'qdic'))
                                            curim_resize = cast(imresize(curim,Ma,'Antialiasing',true),'uint16');
                                            writeTIFF(curim_resize,outname,'uint16');
                                        else
                                            curim_resize = cast(imresize(curim,Ma,'Antialiasing',true),'double');
                                            writeTIFF(curim_resize,outname);
                                        end
                                    else
                                        disp('Skipping');
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



