%This code perform
clc; clear all;close all;
r=0;t=0;c=1;n=1:1200;
%49
%284 600 298 , middle 119,251,169
basedir='E:\QDIC\Embryo_data_for_tomography_March_4\10x\Checkpoint5_zee_again';
outdir='E:\QDIC\Embryo_data_for_tomography_March_4\10x\Checkpoint5_zee_again';
fname =@(odir,f,t,i,ch,c,r,z,m) sprintf('%s\\f%d_t%d_i%d_ch%d_c%d_r%d_z%d_m%d.tif',odir,f,t,i,ch,c,r,z,m);
fout =@(odir,f,t,i,ch,c,r,z,str) sprintf('%s\\f%d_t%d_i%d_ch%d_c%d_r%d_z%d_%s.tif',odir,f,t,i,ch,c,r,z,str);

%Get dimension of the first image

ff=[0:0];
tt=0:6;
chh=1;
ii=0;
cc=0;
rr=0;
zz = 5:247;


p=gcp;
delete(p);
p=parpool(4);
for f=ff
    parfor t=tt
            for i=ii
                for ch=chh
                    for c=cc
                        for r=rr
                           
                            out_sub_dir = sprintf('\\f%d_t%d',f,t);
                            outdir1 = strcat(outdir,out_sub_dir);
                            if (~exist(outdir1))
                                mkdir(outdir1);
                            end
                            foutname=fout(basedir,f,t,i,ch,c,r,zz(1),'qdic');
                            dic_bg = single(imread(foutname));       
                            for z=zz
                                fprintf('Processed f = %d, t=%d, z = %d \n',f,t,z);
                        
                                foutname_org=fout(basedir,f,t,i,ch,c,r,z,'qdic');
                                if (exist(foutname_org))
                                    cur_qdic = single(imread(foutname_org)); 
                                    cur_qdic = cur_qdic - dic_bg;
                                    foutname=fout(outdir1,f,t,i,ch,c,r,z,'qdic');
                                    writetif(cur_qdic,foutname);
                                    if (z~=zz(1))
                                        %delete(foutname_org);
                                    end
                                end
                                if (exist(fout(basedir,f,t,i,ch,c,r,z,'int')))
                                    movefile(fout(basedir,f,t,i,ch,c,r,z,'int'),fout(outdir1,f,t,i,ch,c,r,z,'int'));
                                end
                                if (exist(fout(basedir,f,t,i,ch,c,r,z,'jamp')))
                                    movefile(fout(basedir,f,t,i,ch,c,r,z,'jamp'),fout(outdir1,f,t,i,ch,c,r,z,'jamp'));
                                end
                                
                           end

                        end
                    end
                end
            end
        end
end
%delete(p);

