I=imread('TestImgResized.jpg');
I=im2double(I);
[R C P ]= size(I);
%I= imgaussfilt(I,3);
IR= I(:,:,1);
IG= I(:,:,2);
IB= I(:,:,3);
IBR= imbinarize(IR,graythresh(IR));
IBG= imbinarize(IG,graythresh(IG));
IBB= imbinarize(IB,graythresh(IB));
IBinary=imcomplement(IBR&IBG&IBB);
% IBinary is the binary Image%
IClean= bwareaopen(IBinary,1);
se=strel('disk',9,0);
Imorph= imopen(IClean,se);
imshow(Imorph);%Imorph is morphed image with colored object only%
[labels,numLabels]= bwlabel(Imorph);
disp(['Total Number of Colored object : ' num2str(numLabels)]); 
%%Finding the individual color object%%
RL=zeros(R,C);
GL=zeros(R,C);
BL=zeros(R,C);
for i=1:numLabels
    RL(labels==i)=median(IR(labels==i));
    GL(labels==i)=median(IG(labels==i));
    BL(labels==i)=median(IB(labels==i));
end
IL=cat(3,RL,GL,BL);
imshow(IL)
L1=bwlabel(RL);
%converting to LAB color space%%
[x y]=ginput(1);
scolor=IL(floor(y),floor(x),:);
c=makecform('srgb2lab');
Lab=applycform(IL,c);
SLab=applycform(scolor,c);
IA=Lab(:,:,2);
IB=Lab(:,:,3);
ISA=SLab(1,2);
ISB=SLab(1,3);
thresh=12;
Imask=zeros(R,C);
IDist=hypot(IA-ISA,IB-ISB);
Imask(IDist<thresh)=1;
[cl,cNum]=bwlabel(Imask);
Iseg=repmat(scolor,[R,C,1]).*repmat(Imask,[1,1,3]);
imshow(Iseg);
disp([' Number of selected object : ' num2str(cNum)]); 
%%Detection of white and transparent pin%%
se1=strel('disk',6,0);
i=imdilate(IClean,se1);
BW2 = bwareafilt(i,[1 500]);
%imshow(BW2);%% Transparent and white object%%
