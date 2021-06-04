clear all
close all
clc
xml_file = 'maksssksksss358.xml';
image = 'maksssksksss358.png';
img = im2uint8(imread(image));
figure, imshow(img)
objects = extract_from_xml(xml_file);
labels = [''];
 for i = 1:length(objects)
     I = imcrop(img,[objects(i).xmin,objects(i).ymin,objects(i).height, objects(i).width]);
     I = imresize(I,[200,200]);
     CS = [16,16];
     [hogfv,hogvis] = extractHOGFeatures(I,'CellSize',CS);
     figure(i), imshow(I), hold on
     plot(hogvis);
     title(objects(i).label)
 end