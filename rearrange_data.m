% code for extracting faces from pictures based on data from xml file and
% resizing images to 256x256 dimensions 
% separating pictures into different folders
clear all 
close all
clc
path1 = 'D:\Etf\KV\HOG\Masks\images';
path2 = 'D:\Etf\KV\HOG\Masks\annotations';
path3 = 'D:\Etf\KV\HOG\Masks\imagedb\with_mask';
% path3 = 'D:\Etf\KV\HOG\Masks\imagedb2\with mask';
path4 = 'D:\Etf\KV\HOG\Masks\imagedb\without_mask';
% path4 = 'D:\Etf\KV\HOG\Masks\imagedb2\without mask';
name = 'maksssksksss';
a=dir([path1, '/*.png']);
len=size(a,1);
cl1_cnt = 0; 
cl2_cnt = 0;
for i = 0:len-1
    img = im2uint8(imread(strcat(name,num2str(i),'.png'))); %read images
    data = extract_from_xml(strcat(name,num2str(i),'.xml')); %extract data from xml
 for j = 1:length(data)
     if ((~strcmp(data(j).label,'mask_weared_incorrect'))&&(data(j).height>30)&&(data(j).width>30))     %skip third class and small faces
        I1 = imcrop(img,[data(j).xmin,data(j).ymin,data(j).height, data(j).width]); %crop faces
        I = imresize(I1,[256,256]);  %resize images
%        I = I1;
        if (strcmp(data(j).label,'with_mask'))  %save as class1
            cl1_cnt = cl1_cnt + 1;
            imwrite(I,fullfile(path3,strcat('image',num2str(cl1_cnt),'.png')));
        else %save as class2
            cl2_cnt = cl2_cnt + 1;
            imwrite(I,fullfile(path4,strcat('image',num2str(cl2_cnt),'.png')));
        end
     end    
 end
end