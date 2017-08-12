//
//  OpenCVWrapper.h
//  ConcAnalyzer
//
//  Created by Abdul Fatir Ansari on 20/07/17.
//  Copyright © 2017 Abdul Fatir Ansari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenCVWrapper : NSObject{
    bool resultAvailable;
    NSArray *finalSamples;
}
+(NSString *) getOpenCVVersion;
-(UIImage *) analyzeCard : (UIImage *) image;
-(NSArray *) getFinalSamples;
-(void) testImage : (UIImage*) image;
@end
