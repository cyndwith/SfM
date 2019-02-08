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

<img src="http://bit.ly/2RRu28g" align="center" border="0" alt="W = [ \frac{U}{V} ]" width="75" height="43" />

<img src="http://bit.ly/2RPO4zG" align="center" border="0" alt=" \widetilde{W}  = [ \frac{ \widetilde{U} }{ \widetilde{V} } ]" width="75" height="49" />

<img src="http://bit.ly/2WPLEVJ" align="center" border="0" alt=" \widetilde{u_{fp}} =  u_{fp}  -  a_{f}  " width="114" height="22" />

<img src="http://bit.ly/2WQUGBy" align="center" border="0" alt=" \widetilde{v_{fp}} =  v_{fp}  -  b_{f}  " width="114" height="22" />

<img src="http://bit.ly/2WHZPvM" align="center" border="0" alt=" a_{f} =  \frac{1}{P}  \sum_1^P  u_{fp}" width="110" height="51" />

<img src="http://bit.ly/2WNIUb8" align="center" border="0" alt=" b_{f} =  \frac{1}{P}  \sum_1^P  v_{fp}" width="111" height="51" />

We apply factorization method by computing SVD decomposition

<img src="http://bit.ly/2WRrVEP" align="center" border="0" alt="W = O_{1} \sum^.  O_{2}" width="114" height="33" />

Define

<img src="http://bit.ly/2WNNF4u" align="center" border="0" alt="R = O_{1} (\sum^.)^{1/2} " width="117" height="33" />


where prime stands for block partions O' is 2Fx3 sub matrix of O, Sigma prime is first 3x3 sub matrix of Sigma and O2 is 3xP submatrix of O2

We compute Q matrix using constraints specified by:

<img src="http://bit.ly/2RPXjAd" align="center" border="0" alt="R = R^{'} Q " width="69" height="22" />

<img src="http://bit.ly/2RJLLOM" align="center" border="0" alt="S = Q^{-1} S" width="81" height="21" />

We use orthographic projection as assumptions for solving for matrix Q. 

Medusa Image Sequence:











