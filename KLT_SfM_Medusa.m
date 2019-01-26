% Read a video frame.
close all; clear all;clc;

videoFileReader = vision.VideoFileReader('Dataset/medusa.mp4');

% Create a point tracker and enable the bidirectional error constraint to
% make it more robust in the presence of noise and clutter.
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);

% Make a copy of the points to be used for computing the geometric
% transformation between the points in the previous and the current frames
startFrame = 140;endFrame = 180;tFrames = 300;
noFrames = 1;detectFlag = 0;

while noFrames <= tFrames %~isDone(videoFileReader)
  videoFrame = step(videoFileReader);
  % videoFrame = imresize(videoFrame,  [size(videoFrame,1) size(videoFrame,1)]);
  % figure(1);imshow(videoFrame); drawnow;title('Video Frame');
  if(noFrames >= startFrame && noFrames <= endFrame)
    % get the next frame  
    if (detectFlag == 0)
        % figure;imshow();
        figure(1);imshow(videoFrame); drawnow;title('Video Frame');
        ROI = getrect;
        % Detect feature points in the frame
        ROIFrame = imcrop(videoFrame,ROI);
        % ROIFrame = imresize( ROIFrame, [320 480]);
        ROIFrame = imresize( ROIFrame, [size(videoFrame,1) size(videoFrame,1)]);
        % videoFrame = ROIFrame;
        points = detectMinEigenFeatures(rgb2gray(ROIFrame),'MinQuality',0.002); %, 'ROI', ROI);
        % points = detectSURFFeatures(rgb2gray(ROIFrame)); %, 'ROI', ROI);
        points = points.Location;
        initialize(pointTracker, points, ROIFrame);
        oldPoints = points;
        featurePointsX = zeros(size(points,1),(endFrame-startFrame));
        featurePointsY = zeros(size(points,1),(endFrame-startFrame));
        ROIFrame = insertMarker(ROIFrame, points, '+', ...
                'Color', 'white');
        figure;imshow(ROIFrame);drawnow;
        % hold on; plot(points(:,1),points(:,2),'+');
        detectFlag = 1;
    end
    if detectFlag == 1
        % Track the points. Note that some points may be lost.
        ROIFrame = imcrop(videoFrame,ROI);
        % ROIFrame = imresize( ROIFrame, [320 480]);
        ROIFrame = imresize( ROIFrame,[size(videoFrame,1) size(videoFrame,1)]);
        videoFrame = ROIFrame;
        [points, isFound] = step(pointTracker, videoFrame);
        % [points, isFound] = step(pointTracker, ROIFrame);
        visiblePoints = points(isFound, :);
        oldInliers = oldPoints(isFound, :);
        if size(visiblePoints, 1) >= 2 % need at least 2 points
            % Display tracked points
            videoFrame = insertMarker(videoFrame, visiblePoints, '+', ...
                'Color', 'white');
            % Reset the points
            %oldPoints = visiblePoints;
            %setPoints(pointTracker, oldPoints);
            featurePointsX(isFound,(noFrames-startFrame)+1) = points(isFound,1);
            featurePointsY(isFound,(noFrames-startFrame)+1) = points(isFound,2);
            size(visiblePoints)
        end
        figure(2);imshow(videoFrame);drawnow;
        % plot(visiblePoints(1,:),visiblePoints(2,:),'*');title('Detected Features');
    end
  else
      % figure(1);imshow(videoFrame); drawnow;title('Video Frame');
  end
  noFrames = noFrames + 1
  % Display the annotated video frame using the video player object
%   step(videoPlayer, videoFrame);
end

featureU = [];
featureV = [];
for i = 1:size(points,1)
    if nnz(featurePointsX(i,:)) == (endFrame - startFrame)+1 %tFrames  
        featureU = [featureU; featurePointsX(i,:)];
        i
    end
    if nnz(featurePointsY(i,:)) == (endFrame - startFrame)+1 % tFrames  
        featureV = [featureV; featurePointsY(i,:)];
    end
    i = i+1;
end

meanU = mean(featureU);
meanV = mean(featureV);
for i = 1: (endFrame - startFrame) %tFrames-1
    objFeatureU(:,i) = featureU(:,i) - meanU(1,i);
    objFeatureV(:,i) = featureV(:,i) - meanV(1,i);
end

objW = [ objFeatureU'; objFeatureV'];
[O1,S,O2T] = svd(objW);
O2 = O2T';

O1P = O1(:,1:3);
O2P = O2(1:3,:);
SP = S(1:3,1:3);

objR = O1P*(SP^0.5);
objS = (SP^0.5)*O2P;

% Step 3: Metric Constraints 
Q = metricConstraints(objR);

% (iv) Find R and S [3.14]
R = objR * Q;
S = inv(Q) * objS;

% (v) Align the first camera reference system with the world reference
% system
F = endFrame - startFrame; %noFrames;
i1 = R(1,:)';
i1 = i1 / norm(i1);
j1 = R(F+1,:)';
j1 = j1 / norm(j1);
k1 = cross(i1, j1);
k1 = k1 / norm(k1);
R0 = [i1 j1 k1];
R = R * R0;
S = inv(R0) * S;


% Display Shape
figure; plot3(S(1, :), S(2, :), S(3, :), '*');
xlin = linspace(min(S(1,:)),max(S(1,:)),500);
ylin = linspace(min(S(2,:)),max(S(2,:)),500);
[X,Y] = meshgrid(xlin,ylin);
Z = griddata(S(1,:),S(2,:),S(3,:),X,Y,'cubic');
mesh(X,Y,Z);
axis tight; hold on;
plot3(S(1,:),S(2,:),S(3,:),'.','MarkerSize',15);


% plot3(S(1, :), S(3, :), S(2, :), '*');
% 
% figure; plot3(S(1, :), S(3, :), S(2, :), '*');
% figure; plot3(S(2, :), S(1, :), S(3, :), '*');
% figure; plot3(S(2, :), S(3, :), S(2, :), '*');
% figure; plot3(S(3, :), S(1, :), S(2, :), '*');
% figure; plot3(S(3, :), S(2, :), S(1, :), '*');
% 
% % Clean up
% release(videoFileReader);
% release(videoPlayer);
release(pointTracker);
