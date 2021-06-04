% resizing pictures from aditional data set
clear all 
close all
clc
path1 = 'D:\Etf\KV\HOG\FaceImgsNew';
path2 = 'D:\Etf\KV\HOG\FacesImgs';
name_prefix = '1 (';
imgdb = imageDatastore(path2);

for i = 1:885
    img = im2uint8(readimage(imgdb,i)); %read images
    I = imresize(img,[256,256]);  %resize images
    imwrite(I,fullfile(path1,strcat('image',num2str(i),'.png')));
end