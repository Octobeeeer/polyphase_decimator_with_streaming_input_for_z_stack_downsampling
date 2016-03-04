%This source code demonstrate the polyphase decimator with an integer
%factor M.
%The decimation is along the third dimension of the input
%Author:Tan H. Nguyen
%University of Illinois at Urbana-Champaign
%Version: 1.0
%Last update: 03/04/16
clc;
clear all;
close all;
%Generate input samples
N = 1e6+1; %Input length
x = randn(N,1);
xin = reshape(x,1,1,N);

%Polyphase FIR filter for decimation
M = 5; %Decimation factor

%Truncate the output signal so that it is a multiple of the input signal
xin = xin(:,:,1:floor(size(xin,3)/M)*M);
L = 100; %Filter length
h = fir1(L,1/M*0.9);
freqz(h,1,1024);
title('Frequency response.');

%Generate filter response and downsample
%Direct form filtering
xo = filter(h,1,xin,[],3);
%Display the ouput
figure(1);
plot(squeeze(xin(:,:,1:200)),'b');
hold on;
plot(squeeze(xo(:,:,1:200)),'r');
legend('Input signal','Output signal');
xo_ds = xo(1:M:end);
figure(2);
plot(squeeze(xo_ds(end-40:end)));title('Downsample signal - Direct form');

%Polyphase filtering on the input
h_L = length(h(:));
h_L1 = ceil(h_L/M)*M;
%Zeropad the data with 0 to make the filter polyphase
h_poly = [h(:);zeros(h_L1-h_L,1)];
%Select polyphase filter
h_poly_length = h_L1/M; %Length of each polyphase filter
%hp_arr = reshape(h_poly,M,h_poly_length); %Each row is a polyphase filter
%Compute polyphase signal

xo_ds_poly = zeros(size(xin,1),size(xin,2),size(xin,3)/M);
for polyidx = 1:M
    %Add delay to the input signal
    xtemp = padarray(xin,[0 0 (polyidx-1)],0);
    tmp = filter(h_poly(polyidx:M:end),1,xtemp(1:M:size(xin,3)));
    xo_ds_poly = xo_ds_poly + tmp; %Output of the polyphase filter
end

%Error between the normal input and the polyphase output
err_norm = norm(squeeze(xo_ds-xo_ds_poly),'fro');
disp(['Frobenius norm of the error: ' num2str(err_norm)]);
%Polyphase filtering and add the results

%Streaming input polyphase filtering
xo_ds_poly_iter = zeros(size(xin,1),size(xin,2),size(xin,3)/M);
input_buffer = zeros(size(xin,1),size(xin,2),size(h_poly,1));%Buffer the input
outputidx = 1;
for sampleidx = 1:M:size(xin,3)
    %disp(['Output idx: ' num2str(outputidx)]);
    lastidx = sampleidx;
    firstidx = lastidx-M+1;
    if (lastidx ==1)
        input_buffer(:,:,1) = xin(:,:,1);
    else
        %Read the streamed input samples
        inputdatablock = xin(:,:,lastidx:-1:firstidx);
        %Generate the input of each polyphase
        input_buffer = circshift(input_buffer,M,3);
        input_buffer(:,:,1:M)=inputdatablock;
    end
    %Polyphase op. for faster output here...
    xo_ds_poly_iter(:,:,outputidx)=sum(input_buffer.*repmat(reshape(h_poly,[1 1 length(h_poly(:))]),...
        [size(input_buffer,1),size(input_buffer,2),1]),3);
    outputidx = outputidx+1;
end

%Error between the normal input and the polyphase streaming output
err_norm = norm(squeeze(xo_ds-xo_ds_poly_iter),'fro');
disp(['Frobenius norm of the error 2: ' num2str(err_norm)]);

figure(2);
hold on;
plot(squeeze(xo_ds_poly(end-40:end)),'r');title('Polyphase decimated (Memory)');
hold on;
plot(squeeze(xo_ds_poly_iter(end-40:end)),'g');title('Polyphase decimated (Streaming)');



