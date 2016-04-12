%Downsample the xy dimension , make the size change by a factor. 
clc;
close all;
clear all;
Ma = 0.6349; %Downsampling factor in xy
curfolder = 'H:\Tan_QDIC_hela_63x\';
outdir = 'H:\Tan_QDIC_hela_40x\';
if (~exist(outdir))
    mkdir(outdir);
end
ff=[4,6,8,10,14,22,24,26];
tt=2:22;
chh=0;
ii=0;
cc=0;
rr=0;
zz = 1:401;
singletif=1;
if (~singletif)
    fname =@(odir,f,t,i,ch,c,r,z,s) sprintf('%s\\f%d_t%d_i%d_ch%d_c%d_r%d_z%d_%s.tif',odir,f,t,i,ch,c,r,z,s);
    foutname = fname;
else
    fname =@(odir,f,t,i,ch,c,r,z,s) sprintf('%s\\f%d_t%d_i%d_ch%d_c%d_r%d_z0_%s.tif',odir,f,t,i,ch,c,r,s);
    foutname =@(odir,f,t,i,ch,c,r,z,s) sprintf('%s\\f%d_t%d_i%d_ch%d_c%d_r%d_z%d_%s.tif',odir,f,t,i,ch,c,r,z,s);

end
%Now, go downsampling the data
%p=gcp;
%delete(p);
%p=parpool(8);
override = 0;
frametype = 'qdic';
if (strcmp(frametype,'raw'))
    ss = {'m0','m1','m2','m3'}; 
else
    ss = {'mqdic'};    
end
    for f=ff
        for t=tt
            for i=ii
                for ch=chh
                    for r=rr
                        for c=cc
                            for z=zz
                                for s=ss
                                    disp(['Current z: ' num2str(z) ', mode: ' char(s) 'f: ' num2str(f) 't: ' num2str(t)])
                                    curname = fname(curfolder,f,t,i,ch,c,r,z,char(s));
                                    outname = foutname(outdir,f,t,i,ch,c,r,z,char(s));
                                    if ((exist(curname)&(~exist(outname)))|override)
                                        curim = imread(curname,z);
                                        if (~strcmp(s,'mqdic'))
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



