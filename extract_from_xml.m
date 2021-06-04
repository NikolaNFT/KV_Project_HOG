function objects = extract_from_xml(file)
xml = parseXML(file);
chNo = length(xml.Children);
s = struct('label',{},'xmin',{},'ymin',{},'height',{},'width',{});
objects = [s];
cnt = 0; 
for i = 1:chNo
    if (strcmp(xml.Children(i).Name,'object'))
        cnt = cnt+1;
        objects(cnt).label = xml.Children(i).Children(2).Children.Data;
        xmin =  str2num(xml.Children(i).Children(12).Children(2).Children.Data);
        objects(cnt).xmin = xmin;
        ymin =  str2num(xml.Children(i).Children(12).Children(4).Children.Data);
        objects(cnt).ymin = ymin;
        xmax = str2num(xml.Children(i).Children(12).Children(6).Children.Data);
        ymax = str2num(xml.Children(i).Children(12).Children(8).Children.Data);
        objects(cnt).height = ymax - ymin;
        objects(cnt).width = xmax - xmin;      
    end
end
end

