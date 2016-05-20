clc; clear all;close all;
r=0;t=0;c=1;n=1:1200;
%49
%284 600 298 , middle 119,251,169
basedir='V:\Mikhail\QDIC\Embryos_2016_02_26\checkpoint6_zees_more';
outdir='E:\Tan_QDIC_embryos\Embryo\40x_data\checkpoint6_zees_more\qdic';

fname =@(odir,f,t,i,ch,c,r,z,m) sprintf('%s\\f%d_t%d_i%d_ch%d_c%d_r%d_z%d_m%d.tif',odir,f,t,i,ch,c,r,z,m);
fout =@(odir,f,t,i,ch,c,r,z,str) sprintf('%s\\f%d_t%d_i%d_ch%d_c%d_r%d_z%d_%s.tif',odir,f,t,i,ch,c,r,z,str);

%Get dimension of the first image

ff=0:13;
tt=0:0;
chh=1;
ii=0;
cc=0;
rr=0;
zz = 0:2048;
mm=0:3;

tempim = imread(fname(basedir,ff(1),tt(1),ii(1),chh(1),cc(1),rr(1),zz(1),mm(1)));
nrows = size(tempim,1);
ncols = size(tempim,2);
p=gcp;
delete(p);
p=parpool(8);
parfor f=ff
    for t=tt
            for i=ii
                for ch=chh
                    for c=cc
                        for r=rr
                            out_sub_dir = sprintf('',f,t);
                            outdir1 = strcat(outdir,out_sub_dir);
                            if (~exist(outdir1))
                                mkdir(outdir1);
                            end
                            
                            %Compute the background image
                            A=single(imread(fname(basedir,f,t,i,ch,c,r,zz(1),0)));
                            B=single(imread(fname(basedir,f,t,i,ch,c,r,zz(1),1)));
                            C=single(imread(fname(basedir,f,t,i,ch,c,r,zz(1),2)));
                            D=single(imread(fname(basedir,f,t,i,ch,c,r,zz(1),3)));
                            %dphi_bg=QDIC(A,B,C,D,[1 1 1 1]);
                            dphi_bg = single(imread('E:\Tan_QDIC_embryos\Embryo\40x_data\checkpoint6_zees_more\qdic\bg_median_proj.tif'));
                            
                            for z=zz
                                if (exist(fname(basedir,f,t,i,ch,c,r,z,0),'file'))
                                    A=single(imread(fname(basedir,f,t,i,ch,c,r,z,0)));
                                    B=single(imread(fname(basedir,f,t,i,ch,c,r,z,1)));
                                    C=single(imread(fname(basedir,f,t,i,ch,c,r,z,2)));
                                    D=single(imread(fname(basedir,f,t,i,ch,c,r,z,3)));
                                    [dphi,sinmap,cosmap,inten,jamp]=QDIC(A,B,C,D,[1 1 1 1]);
                                    dphi = dphi - dphi_bg;%Background subtractin
                                    foutname=fout(outdir1,f,t,i,ch,c,r,z,'qdic');
                                    intenname =fout(outdir1,f,t,i,ch,c,r,z,'int');
                                    jampname =fout(outdir1,f,t,i,ch,c,r,z,'jamp');

                                    writetif(dphi,foutname);
                                    writetif(inten,intenname);
                                    %writetif(jamp,jampname);

                                    fprintf('Processed f = %d, t=%d, z = %d \n',f,t,z);
                                else
                                    disp('Cannot find the necessary files')
                                end
                            end

                        end
                    end
                end
            end
        end
end
%delete(p);

