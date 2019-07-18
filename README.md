## Project Title

Project implements shape and motion from image stream using factorization method

## Getting Started

This project implements factorization method for estimation of object shape and camera motion from image stream. 
Factorization method relies on good feature selection and tracking algorithm. In this we use minimum eigen values as feature, 
KLT feature tracker on medusa image sequence.

## Framework used

Matlab

## Implementation

We track P points through F frames of images, which is used to build 2FxP matrix called measurement matrix (W). 
The rotation and translation are measured w.r.t centroid of the object which enables the application of rank theorem []
The rotation matrix is defined by: 1) Rotation (R) of dimensions: 2Fx3 and 2) Translation (T) of dimensions: 3xP

We apply factorization method by computing SVD decomposition to estimate the rotation and translation matrix. 
We use orthographic projection as assumptions for solving for matrix Q. For more details about the algorithms available in the paper [1]


## Medusa Image Sequence

<p align="center">
  <img width="460" height="300" src="https://github.com/cyndwith/SfM/blob/master/Images/Medussa.PNG">
</p>

## Feature Tracking (KLT)


<include links for images>


## Structure from Motion (SfM)

<p align="center">
  <img width="460" height="300" src="https://github.com/cyndwith/SfM/blob/master/Images/SfM_points.PNG">
</p>  

## References
[1] C. Tomasi and T. Kanade, "Shape and motion from image streams under orthography-- a
factorization method," International Journal of Computer Vision, 9(2):137--154, 1992.

[2] Implementation of KLT feature tracking algorithm, https://www.mathworks.com /help/vision/examples/face-detection-and-tracking-using-the-klt-algorithm.html


  











