/******************************************************************************
 *  Name:      Yiran Fan
 *  NetID:     yiranf
 *  Course:    cos429
 *
 *  Assignment #2 
 *  Note: all of the output images are in the folder output/. Extra credit 
 *  included in output/ as well. 
 ******************************************************************************/


/******************************************************************************
 *  What happens to performance on the training set as the number of training 
 *  images increases? If at some point you don't get perfect training 
 *  performance any more, why not?
 *****************************************************************************/
The training set will stop having perfect performance as the number of 
training images increases. Because with a large amount of inputs, the model
becomes overly complex and therefore overfitting occurs — there are too much 
noise and the model is representing too much error instead of the actual 
relationship between. 


/******************************************************************************
 *  What happens to performance on the test set as the number of training 
 *  images increases?
 *****************************************************************************/
As the training set increases, the testing results slowly improve and then 
plateaus. And of course, the errors still vary then but generally it gathers
around the 10^-1 to 10^-2 range.  


/******************************************************************************
 *  What happens to performance on the test set as the number of orientations 
 *  increases?
 *****************************************************************************/
The test result improves as the number of orientation increases because more 
orientations we take into account, the more accurate binning we will have. 
However, the improvement in performance flats out and becomes marginal as the 
bin size gets smaller and smaller (more orientations are binned).


/******************************************************************************
 *  Do you see the same behavior as Dalal and Triggs, in that turning off the 
 *  wrapping of orientations at 180 degrees makes little difference to 
 *  performance? If not (e.g., not wrapping is better), can you hypothesize why?
 *****************************************************************************/
In my results, not wrapping produces better results. Because not wrapping means
that the gradients will be treated as signed gradients. In the case of Dalal and
Triggs, turning on the wrapping produced better results because they are 
detecting the entire human body including the great variety of their clothing 
and background colors. However, in our data set, we’re dealing with faces and 
generally uniform backgrounds in grayscale. Therefore, turning off the wrapping
(bin orientation 0-360) is a better solution for this assignment. 


/******************************************************************************
 *  In parts III and IV of this assignment, you will run this detector at many 
 *  locations throughout an image that may or may not contain some faces. 
 *  Would you prefer to run the detector with a threshold that favors fewer 
 *  false positives, fewer false negatives, or some balance? Why?
 *****************************************************************************/
We would prefer to run the detector with a balanced threshold that has a 
relatively high threshold. However, the actual threshold and whether we should 
prefer false positives over false negatives will need to be based on the goal
of the application — if it’s for self-driving cars, it’s obviously better to 
have a looser threshold (fewer false negatives) because the risk of missing 
a person is high. However, if it’s for entertainment purposes, for example, 
face detection on pictures (e.g. Facebook auto face detection in pictures), 
it’s better to have a fewer false positives because it’s easier to add a 
missed face than to delete/edit all the of the false detections.  


/******************************************************************************
 *  Discuss when your detector tends to fail (part 3)
 *****************************************************************************/
It fails usually when the face is not frontal enough, partially covered, or 
when face has a color that’s closer to the background color. In other words, 
darker skin tone has poorer performance when the background color (the color 
surrounding the face) is dark. For example, in figure “part3_voyager_img.jpg”, 
the black person’s face is correctly detected because the background color is 
lighter. 

/******************************************************************************
 *  Discuss when your detector tends to fail or find large numbers of false 
 *  positives. Be aware that the multi-scale detector may take a few minutes 
 *  to run on the larger input images. (part 4)
 *****************************************************************************/
Figure “part4_addams2.jpg” is a good example of a large number of false positives, 
in which hands, torsos, clothes, and a part of the fireplace are identified as
faces when they are clearly not supposed to. This result was generated with a 
smaller training set and a lower threshold, which are two major reasons that 
lead to large numbers of false positives. Other potential reasons for a poor 
performance are an overly high threshold (that leads to high false negatives), 
too big of a training set (leads to overfitting and therefore more errors), 
overly generalized orientations, window size/stride size scaling too rapidly, etc.

/******************************************************************************
 *  Experiment&image description
 *****************************************************************************/
part2_test.jpg — false positive/false negative graph for testing
part2_training.jpg — false positive/false negative graph for training
part3_addmas_img.jpg (and …_prob) — part 3 experiment with 4000 training set, 
	orientation: 9, stride: 3, thresh: .97, wrap180: false.
part3_bttf_img.jpg (and …_prob) — with 4000 training set, orientation: 9, 
	stride: 3, thresh: .95, wrap180: false.
part3_england_img.jpg (and …_prob) — 5000 training, orientation: 8, 
	stride: 5, thresh: .95, wrap180: true.
part3_paceu_img.jpg (and …prob) — 3000 training, orientation: 4, 
	stride: 3, thresh: .95, wrap180: false.
part3_voyager_img.jpg (and …prob) —  5000 training, orientation: 9, 
	stride: 5, thresh: .95, wrap180: true.
part4_addams.jpg — 5000 training, orientation: 9, stride: 3 , 
	thresh: .95, wrap180: false.
part4_addams2.jpg — 1000 training, orientation: 4, stride: 3 , 
	thresh: .93, wrap180: true.
part4_aerosmith.jpg — 2000 training, orientation 6, stride: 5, thresh: .95
	wrap180: false.
part4_lawoman.jpg — 5000 training, orientation 9, stride: 3, thresh: .95
	wrap180: false.
part4_panda.jpg — 5000 training, orientation 9, stride: 3, thresh: .95
	wrap180: false.
EXTRACREDIT_addams.jpg — 5000 training, orientation 9, stride: 3, thresh: .95
	wrap180: false.


