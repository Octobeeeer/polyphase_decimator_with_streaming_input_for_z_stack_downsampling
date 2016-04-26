clc; clear all;close all;
r=0;t=0;c=1;n=1:1200;
%49
%284 600 298 , middle 119,251,169
basedir='/raid5/Mikhail/QDIC/dic_cell_40x/z_yellow_fast';
outdir='/raid5/Mikhail/QDIC/dic_cell_40x/z_yellow_fast_process';
fname=@(r,t,c,n,p) sprintf('%s//%i_%i_%i_%i_%s.tif',basedir,r,t,c,n,p); % FOV, TIME, Channel, Frame Number, PAT
fout=@(r,t,c,n,p) sprintf('%s//%i_%i_%i_%i_%s.tif',outdir,r,t,c,n,p); % FOV, TIME, Channel, Frame Number, PAT
region='nope';%Used to compensate the attenuation
thebars=[-0.3,0.7];
colormap(jet);
%
if (strcmp(region,'pick'))
    fm=@(x) floor(mean(x));
    A=single(imread(fname(fm(r),fm(t),fm(c),fm(n),'3')));
    B=single(imread(fname(fm(r),fm(t),fm(c),fm(n),'0')));
    C=single(imread(fname(fm(r),fm(t),fm(c),fm(n),'1')));
    D=single(imread(fname(fm(r),fm(t),fm(c),fm(n),'2')));
    imagesc(A);
    axis image;
    rect=getrect;
    rect=ceil(rect);
    CPM =@(img) mean2(img(rect(2):(rect(2)+rect(4)),rect(1):(rect(1)+rect(3))));
    comp=[CPM(A),CPM(B),CPM(C),CPM(D)];
else
    comp=[1,1,1,1];
end
cc=1;%Because Phase is only on this channel?
for rr=r
    for tt=t
        parfor nn=n
            A=single(imread(fname(rr,tt,cc,nn,'3')));
            B=single(imread(fname(rr,tt,cc,nn,'0')));
            C=single(imread(fname(rr,tt,cc,nn,'1')));
            D=single(imread(fname(rr,tt,cc,nn,'2')));
            [dphi,sinmap,cosmap,inten,jamp]=QDIC(A,B,C,D,comp);
            foutname=fout(rr,tt,cc,nn,'QDIC');
            sinname=fout(rr,tt,cc,nn,'sin');
            cosname=fout(rr,tt,cc,nn,'cos');
            intenname = fout(rr,tt,cc,nn,'int');
            jampname = fout(rr,tt,cc,nn,'jamp');
           
            writetif(dphi,foutname);
            writetif(sinmap,sinname);
            writetif(cosmap,cosname);
            writetif(inten,intenname);
            writetif(jamp,jampname);
            
            if (0)
                figure(1);
                subplot(221);imagesc(sinmap);colormap gray; title('Sin map');axis image;
                subplot(222);imagesc(cosmap);colormap gray;title('Cos map');axis image;
                subplot(223);imagesc(dphi);colormap gray; title('Phase difference');axis image;
                subplot(224);imagesc(inten);colormap gray;title('Intensity');axis image;drawnow;
            end
            fprintf('%d %d %d %d %s\n',cc,rr,tt,nn,foutname);
        end
    end
end
