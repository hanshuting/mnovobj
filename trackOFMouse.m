function [segAll,theta,centroid,a,b] = trackOFMouse(movieParam,box_region,obj_region)

%% initialize
dims = [movieParam.imageSize,movieParam.numImages];
segAll = zeros(dims,'uint8');
segB = zeros(dims,'uint8');
rawTheta = zeros(dims(3),1);
centroid = zeros(dims(3),2);
a = zeros(dims(3),1);
b = zeros(dims(3),1);
    
fprintf('processed time window:      0/%u',dims(3));
preva = NaN;
prevb = NaN;
prevc = NaN;
prevarea = NaN;
prevtheta = NaN;

%% segmentation, initial orientation estimation
vid = VideoReader([movieParam.filePath '\' movieParam.fileName '.avi']);
for i = 1:dims(3)
    
    if hasFrame(vid)

        % read image
        im = rgb2gray(readFrame(vid));
        % im = double(imread([movieParam.filePath movieParam.fileName '.tif'],i));

        % segmentation
        [segAll(:,:,i),segB(:,:,i),centroid(i,:),rawTheta(i),a(i),b(i),prevarea]...
            = segMouse(im,box_region,obj_region,preva,prevb,prevc,prevarea,prevtheta);
        preva = a(i);
        prevb = b(i);
        prevc = centroid(i,:);
        prevtheta = rawTheta(i);

        % update progress text
        fprintf(repmat('\b',1,length(num2str(dims(3)))+length(num2str(i))+1));
        fprintf('%u/%u',i,dims(3));

    else
        fprintf('No more frames available in %s: i=%u\n',movieParam.fileName,i);
    end
    
end
fprintf('\n');

%% smooth orientation estimation
% trajectory velocity
wthresh = nanmean(a)/2;

% forward velocity vector
fVel = zeros(dims(3),1);
fWei = zeros(dims(3),1);
findx = true(dims(3),1);
for i = 1:dims(3)-1
    count = 1;
    fw = 0;
    fvel = [NaN,NaN];
    while fw < wthresh
        if i+count <= dims(3)
            fvel = centroid(i+count,:)-centroid(i,:);
            fw = sqrt(fvel(1)^2+fvel(2)^2);
        else
            findx(i) = 0;
            break;
        end
        count = count+1;
    end
    fWei(i) = count;
    fVel(i) = -rad2deg(atan2(fvel(2),fvel(1)));
    % visualize
%     imagesc(segAll(:,:,i));colormap(gray);
%     hold on;scatter(centroid(i,1),centroid(i,2),'r*');
%     quiver(centroid(i,1),centroid(i,2),cos(degtorad(fVel(i)))*50,...
%         -sin(degtorad(fVel(i)))*50,'b');
%     hold off;title(num2str(i));pause(0.01);
end
fVel(end) = fVel(end-1);

% backward velocity vector
bVel = zeros(dims(3),1);
bWei = zeros(dims(3),1);
bindx = true(dims(3),1);
for i = 2:dims(3)
    count = 1;
    fw = 0;
    bvel = [NaN,NaN];
    while fw < wthresh
        if i-count >= 1
            bvel = centroid(i,:)-centroid(i-count,:);
            fw = sqrt(bvel(1)^2+bvel(2)^2);
        else
            bindx(i) = 0;
            break;
        end
        count = count+1;
    end
    bWei(i) = count;
    bVel(i) = -rad2deg(atan2(bvel(2),bvel(1)));
    % visualize
%     imagesc(segAll(:,:,i));colormap(gray);
%     hold on;scatter(centroid(i,1),centroid(i,2),'r*');
%     quiver(centroid(i,1),centroid(i,2),cos(degtorad(bVel(i)))*50,...
%         -sin(degtorad(bVel(i)))*50,'b');
%     hold off;title(num2str(i));pause(0.01);
end
bVel(1) = bVel(2);

% smooth by a moving window
% tw = 1;
% sthVel = zeros(dims(3),1);
% cindx = false(dims(3),1);
% for i = 1:dims(3)
%     if i <= dims(3)-tw-step
%         indx = max(1,i-tw):min(dims(3),i+tw);
% %         sthVel(i) = sum(thVel(indx).*wVel(indx))/sum(wVel(indx));
%         sthVel(i) = quantile(thVel(indx),0.5);
% %         if sqrt(sum((vel(indx(end),:)-vel(indx(1),:)).^2)) > wthresh
%         if sum(wVel(indx)) > wthresh
%             cindx(i) = 1;
%         end
%     else
%         indx = min(i-tw,dims(3)-tw-step):dims(3)-step;
% %         sthVel(i) = sum(thVel(indx).*wVel(indx))/sum(wVel(indx));
%         sthVel(i) = quantile(thVel(indx),0.5);
% %         if sqrt(sum((vel(indx(end),:)-vel(indx(1),:)).^2)) > wthresh
%         if sum(wVel(indx)) > wthresh
%             cindx(i) = 1;
%         end
%     end
% end

thetaThresh = 90;
fVel(fVel>360) = fVel(fVel>360)-360;
fVel(fVel<0) = fVel(fVel<0)+360;
bVel(bVel>360) = bVel(bVel>360)-360;
bVel(bVel<0) = bVel(bVel<0)+360;
theta = rawTheta;
theta(theta>360) = theta(theta>360)-360;
theta(theta<0) = theta(theta<0)+360;
meanVel = (fVel.*fWei+bVel.*bWei)./(fWei+bWei);
diffTheta = abs(meanVel-theta);
indx = diffTheta>thetaThresh;
theta(indx) = theta(indx)-180;
% cindxSeq = find(findx);
% indx = diffTheta>thetaThresh&findx&bindx;
% for i = 1:dims(3)
%     if findx(i)==0||bindx(i)==0
%         nnindx = find(sort([cindxSeq;i])==i);
%         nnindx = [max(nnindx-1,1),min(nnindx,length(cindxSeq))];
%         [~,diffindx] = min([abs(cindxSeq(nnindx(1))-i),abs(cindxSeq(nnindx(2))-i)]);
%         if abs(rawTheta-theta(cindxSeq(nnindx(diffindx(1))))) > 180
%             theta(i) = rawTheta(i)-180;
%         else
%             theta(i) = rawTheta(i);
%         end
%     end
% end

theta(theta>360) = theta(theta>360)-360;
theta(theta<0) = theta(theta<-0)+360;

% smooth again with a moving window
mw = 7;
diffThresh = 20;
% mwdiff = abs(theta(2:end)-theta(1:end-1));
% mwdiffIndx = mwdiff>diffThresh;
% changeIndx = reshape(find((mwdiffIndx(2:end)-mwdiffIndx(1:end-1))),2,[])';
% changeIndx = changeIndx((changeIndx(:,2)-changeIndx(:,1))<=mw,:);
% for i = 1:size(changeIndx,1)
%     indx = changeIndx(i,1)+1:changeIndx(i,2);
%     theta(indx) = theta(indx)-180;
% end
% theta(theta>180) = theta(theta>180)-180;
% theta(theta<-180) = theta(theta<-180)+180;
for i = 1:dims(3)-mw
    mwtheta = theta(i:i+mw-1);
    if abs(max(mwtheta)-min(mwtheta)-180) < diffThresh
%         fprintf('%u\n',i);
        if sum(mwtheta>max(mwtheta)-20)>sum(mwtheta<min(mwtheta)+20)
            modemw = quantile(mwtheta,0.8);
        else
            modemw = quantile(mwtheta,0.2);
        end
        indx = abs(abs(mwtheta-modemw)-180)<diffThresh;
        mwtheta(indx) = mwtheta(indx)-180;
        mwtheta(mwtheta>360) = mwtheta(mwtheta>360)-360;
        mwtheta(mwtheta<0) = mwtheta(mwtheta<0)+360;
        theta(i:i+mw-1) = mwtheta;
    end
end

%% plot
plot(centroid(:,1),centroid(:,2))
hold on;
quiver(centroid(:,1),centroid(:,2),cos(deg2rad(theta)),sin(deg2rad(theta)))
hold off

end