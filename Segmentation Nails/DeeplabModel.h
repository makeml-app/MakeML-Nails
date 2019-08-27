//
//  DeeplabModel.h
//  Segmentation Nails
//
//  Created by Alexey Korotkov on 8/26/19.
//  Copyright © 2019 Alexey Korotkov. All rights reserved.
//

#include <stdio.h>

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface DeepLabModel : NSObject
- (unsigned char *) process:(CVPixelBufferRef)pixelBuffer additionalColor:(unsigned int)additionalColor;
- (BOOL) loadModel;
@end
