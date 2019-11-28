function [bwbody,bw_conv,centroid,theta,a,b,area] = segMouse(im,box_region,...
    obj_region,preva,prevb,prevc,prevarea,prevtheta)
% theta is in degrees

% parameters
gamma = 4;
dims = size(im);
P = round(dims(1)*dims(2)/(20*20));
flag = 0;

%% segmentation
im = 1-mat2gray(im);

% smooth image
fgauss = fspecial('gaussian',3,1);
im = imfilter(im,fgauss);

% substract background, adjust contrast
im_bkg = imopen(im,strel('disk',50));
im = im-im_bkg;
% im = imadjust(im-im_bkg);
im = imadjust(im,[0,1],[0,1],gamma);
% im = adapthisteq(im,'Distribution','uniform');

% keep only the box region
% some of the behavior videos have different image sizes across session, just to
% deal with this issue here
obj_region_all = logical(sum(obj_region,3));
boximsz = size(box_region);
if any(dims~=boximsz)
    flag = 1;
    finalsz = [max(boximsz(1),dims(1)),max(boximsz(2),dims(2))];
    im(finalsz(1),finalsz(2)) = 0;
    box_region(finalsz(1),finalsz(2)) = 0;
    obj_region_all(finalsz(1),finalsz(2)) = 0;
    init_dims = dims;
    dims = finalsz;
end
im(box_region==0) = NaN;

% remove object region
im(obj_region_all==1) = NaN;

% threshold intensity
% thresh = multithresh(im,2);
% bw = im>thresh(2);
bw = im>quantile(im(:),0.99);
bw = bw&(~obj_region_all);
bw = bwareaopen(bw,P);

if all(bw(:)==0)
    theta = NaN;
    centroid = [NaN,NaN];
    a = NaN;
    b = NaN;
    area = NaN;
    bwbody = false(dims);
    bw_conv = false(dims);
    if flag==1
        bwbody = bwbody(1:init_dims(1),1:init_dims(2));
        bw_conv = bw_conv(1:init_dims(1),1:init_dims(2));
    end
    return;
end

% image boundary
hx = [-1,0,1];
hy = hx';
grad_x = imfilter(im,hx);
grad_y = imfilter(im,hy);
grad_mag = sqrt(grad_x.^2+grad_y.^2);

% convolve with a gaussian filter to detect body
% fgauss = fspecial('gaussian',round(dims/20),round(mean(dims))/50);
fgauss = fspecial('gaussian',25,5);
im_conv = imfilter(im,fgauss);
thresh = multithresh(im_conv);
bw_conv = im_conv>thresh;
bw_conv = bw_conv&(~obj_region_all);
% imagesc(bw_conv);

%% fit ellipse
rs = regionprops(logical(bw_conv),'orientation','centroid','majoraxislength',...
    'minoraxislength','area','pixellist','solidity');

if nargin < 7 || isnan(prevarea)
    
    % if nothing is detected, return NaN
    if isempty(rs)
        theta = NaN;
        centroid = [NaN,NaN];
        a = NaN;
        b = NaN;
        area = NaN;
        bwbody = false(dims);
        if flag==1
            bwbody = bwbody(1:init_dims(1),1:init_dims(2));
            bw_conv = bw_conv(1:init_dims(1),1:init_dims(2));
        end
        return;
    end
    
    % find the region that is most similar to the given region
    arg = zeros(length(rs),1);
    for i = 1:length(rs)
        arg(i) = rs(i).Area*rs(i).Solidity;
    end
    [~,indx] = max(arg);
    
else
    
    % if nothing is detected, return NaN
    if isempty(rs)
        theta = NaN;
        centroid = [NaN,NaN];
        a = NaN;
        b = NaN;
        area = NaN;
        bwbody = false(dims);
        if flag==1
            bwbody = bwbody(1:init_dims(1),1:init_dims(2));
            bw_conv = bw_conv(1:init_dims(1),1:init_dims(2));
        end
        return;
    end
    
    % find the most similar region
    arg = zeros(length(rs),1);
    for i = 1:length(rs)
        arg(i) = sum((rs(i).Centroid-prevc).^2+...
            (rs(i).MinorAxisLength-prevb)^2+...
            (rs(i).MajorAxisLength-preva)^2);
%             sqrt(abs(rs(i).Area-prevarea));
    end
    [~,indx] = min(arg);
    
end

centroid = rs(indx).Centroid;
theta = rs(indx).Orientation;
a = rs(indx).MajorAxisLength;
b = rs(indx).MinorAxisLength;
area = rs(indx).Area;
    
theta_rad = pi*theta/180;
f = sqrt((a/2)^2-(b/2)^2);
f1 = centroid+[f*cos(theta_rad),-f*sin(theta_rad)];
f2 = centroid-[f*cos(theta_rad),-f*sin(theta_rad)];
rs_bwfull = regionprops(bw,'pixellist');
bwpixel_all = cell2mat(struct2cell(rs_bwfull)');
% ellipse region
bodyindx = pdist2(bwpixel_all,f1)+pdist2(bwpixel_all,f2)<=a;
ellp_region = zeros(dims);
ellp_region(sub2ind(dims,bwpixel_all(bodyindx,2),bwpixel_all(bodyindx,1))) = 1;
% whole body region
bwfull_area = zeros(length(rs_bwfull),1);
for i = 1:length(rs_bwfull)
    bwfull_part = false(dims);
    bwfull_part(sub2ind(dims,rs_bwfull(i).PixelList(:,2),...
        rs_bwfull(i).PixelList(:,1))) = 1;
    bwfull_area(i) = sum(sum(bwfull_part&ellp_region));
end
[~,bw_indx] = max(bwfull_area);
bwfull_pixels = rs_bwfull(bw_indx).PixelList;
bwbody = zeros(dims);
bwbody(sub2ind(dims,bwfull_pixels(:,2),bwfull_pixels(:,1))) = 1;

%% determine orientation 
if nargin < 6 || isnan(prevarea)
    
    % generate patchs
    rg(1,:) = [-a a a -a -a]/2;
    rg(2,:) = [-a -a a a -a]/2;
    rg = [cos(-theta_rad) -sin(-theta_rad);sin(-theta_rad) cos(-theta_rad)]*rg;

    % edge around first patch
    pscale = 1;
    rg1 = round(rg+(centroid'+[pscale*a*cos(theta_rad);-pscale*a*sin(theta_rad)])*ones(1,5));
    mask1 = poly2mask(rg1(1,:),rg1(2,:),dims(1),dims(2));

    % edge around second patch
    rg2 = round(rg+(centroid'+[-pscale*a*cos(theta_rad);pscale*a*sin(theta_rad)])*ones(1,5));
    mask2 = poly2mask(rg2(1,:),rg2(2,:),dims(1),dims(2));

    % determine head orientation
    edge1 = sum(sum(mask1.*grad_mag));
    edge2 = sum(sum(mask2.*grad_mag));
    if edge2 > edge1
        theta = theta-180;
    end
    
else
    
    if abs(prevtheta-theta)>150
        theta = theta-180;
    end
    
end

%% very ungraceful bug fix for mikki's dataset :'(
if flag==1
    bwbody = bwbody(1:init_dims(1),1:init_dims(2));
    bw_conv = bw_conv(1:init_dims(1),1:init_dims(2));
end

%% for debug - visualization
% clf
% imagesc(bw_conv); hold on
% scatter(centroid(1),centroid(2),'ro');
% plot(centroid(1)+[0 a*cos(pi*theta/180)/2],centroid(2)+[0 -a*sin(pi*theta/180)/2],'r');
% axis equal tight
% title('');
% pause(0.01);


end
