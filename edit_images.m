%code for loading and croping faces from pictures manualy
[filename,pathname] = uigetfile('*.*','Select Input Image');
filewithpath = strcat(pathname,filename);
img_new = imread(filewithpath);
img_crop = imcrop(img_new);
img_final = imresize(im2uint8(img_crop),[256,256]);
imwrite(img_final,fullfile('D:\Etf\KV\HOG\Masks',strcat('cust_im_',num2str(floor(rand()*100)),'.png')));