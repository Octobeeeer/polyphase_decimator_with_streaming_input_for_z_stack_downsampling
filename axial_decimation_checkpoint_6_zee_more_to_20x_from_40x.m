%Downsample the xy dimension , make the size change by a factor. 
clc;
close all;
clear all;
Ma = 0.5; %Downsampling factor in xy
curfolder = 'E:\Tan_QDIC_embryos\Embryo\40x_data\checkpoint6_zees_more\qdic';
outdir = 'E:\Tan_QDIC_embryos\Embryo\20x_data\checkpoint6_zees_more\qdic';
if (~exist(outdir))
    mkdir(outdir);
end
ff=[4,5,10];
tt=0;
chh=1;
ii=0;
cc=0;
rr=0;
zz = 11:1015;
fname =@(odir,f,t,i,ch,c,r,z,s) sprintf('%s\\f%d_t%d_i%d_ch%d_c%d_r%d_z%d_%s.tif',odir,f,t,i,ch,c,r,z,s);

%Now, go downsampling the data
%p=gcp;
%delete(p);
%p=parpool(4);
override = 1;
frametype = 'qdic';
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



