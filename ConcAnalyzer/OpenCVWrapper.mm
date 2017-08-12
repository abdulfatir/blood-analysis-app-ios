//
//  OpenCVWrapper.m
//  ConcAnalyzer
//
//  Created by Abdul Fatir Ansari on 20/07/17.
//  Copyright © 2017 Abdul Fatir Ansari. All rights reserved.
//

#import "OpenCVWrapper.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <vector>
#import <map>
#import <algorithm>

using std::cout;
using std::endl;
using std::vector;
using std::map;
using namespace cv;

@implementation OpenCVWrapper
+(NSString *) getOpenCVVersion{
    return @CV_VERSION;
}
-(bool) isValidBlob:(vector<cv::Point>) contour{
    bool flag = true;
    double area = contourArea(contour);
    if(area < 1000 || area > 16000){
        flag = false;
    }
    cv::Rect r = boundingRect(contour);
    float aspectRatio = 0;
    int w = r.width, h = r.height;
    if(w > h){
        aspectRatio = ((float)w)/ h;
    }
    else{
        aspectRatio = ((float)h)/ w;
    }
    if(aspectRatio >= 1.5)
        flag = false;
    return flag;
}

-(UIImage *) analyzeCard:(UIImage *)image{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *cardModeKey = @"cardMode";
    int NO_OF_RECTS = 7;
    if([prefs objectForKey:cardModeKey] != nil){
        int cardType = int([prefs integerForKey:cardModeKey]);
        if(cardType == 1){
            NO_OF_RECTS = 6;
        }
    }
    int rectIdx = 0;
    cv::Rect rects[NO_OF_RECTS];
    vector<CGRect> samples;
    Mat rawImage;
    UIImageToMat(image, rawImage);
    int width = 600;
    float ratio = ((float)rawImage.rows)/rawImage.cols;
    int height = width * ratio;
    resize(rawImage, rawImage, cv::Size(width, height));
    Mat rawCopy;
    rawImage.copyTo(rawCopy);
    if(rawCopy.channels() == 4){
        cvtColor(rawCopy, rawCopy, CV_BGRA2BGR);
    }
    Mat grayImage;
    cvtColor(rawImage, grayImage, CV_BGR2GRAY);
    GaussianBlur(grayImage, grayImage, cv::Size(5, 5), 0);
    Mat threshImage;
    adaptiveThreshold(grayImage, threshImage, 255.0, ADAPTIVE_THRESH_MEAN_C, THRESH_BINARY, 85, 2);
    medianBlur(threshImage, threshImage, 5);
    Mat strEl = getStructuringElement(MORPH_RECT, cv::Size(15, 15));
    morphologyEx(threshImage, threshImage, MORPH_CLOSE, strEl);
    vector<vector<cv::Point> > contours;
    vector<Vec4i> hierarchy;
    findContours(threshImage, contours, hierarchy, RETR_LIST, CHAIN_APPROX_SIMPLE);
    map<int, int> dict;
    for(int i = 0; i < contours.size(); i++){
        vector<cv::Point> contour = contours[i];
        if([self isValidBlob:contour]){
            cv::Rect r = boundingRect(contour);
            cv::Point center(r.x + r.width/2, r.y + r.height/2);
            bool found = false;
            map<int, int>::iterator iter;
            for(iter = dict.begin(); iter != dict.end(); iter++){
                int Y = iter->first;
                if(abs(Y - center.y) <= 15){
                    found = true;
                    int count = iter->second;
                    count++;
                    dict[Y] = count;
                }
            }
            if(!found){
                dict[center.y] = 1;
            }
        }
    }
    
    bool foundRequiredBlobs = false;
    int centerY = 0;
    map<int, int>::iterator iter;
    
    for(iter = dict.begin(); iter != dict.end(); iter++){
        int count = iter->second;
        if(count == NO_OF_RECTS-1){
            centerY = iter->first;
            foundRequiredBlobs = true;
        }
    }
    
    if(!foundRequiredBlobs)
        cout << "Couldn't detect ROI." << endl;
    else
        cout << "First level ROIs detected." << endl;
    
    int minX = rawImage.cols;
    int maxX = 0;
    
    vector<vector<cv::Point>> sampleCandidates;
    for(int i = 0; i < contours.size(); i++){
        vector<cv::Point> contour = contours[i];
        if([self isValidBlob:contour]){
            cv::Rect r = boundingRect(contour);
            cv::Point center(r.x + r.width/2, r.y + r.height/2);
            if(centerY - center.y > 20){
                sampleCandidates.push_back(contour);
            }
            if(abs(centerY - center.y) <= 15 && rectIdx < NO_OF_RECTS-1){
                if(r.x < minX)
                    minX = r.x;
                if(r.x + r.width > maxX)
                    maxX = r.x + r.width;
                rects[rectIdx] = cv::Rect(r.x, r.y, r.width, r.height);
                cv::Rect rSmall =  cv::Rect(r.x+10, r.y+10, r.width-20, r.height-20);
                Mat clip;
                Mat(rawCopy, rSmall).copyTo(clip);

                //rectangle(rawImage, cv::Point(rSmall.x, rSmall.y), cv::Point(rSmall.x + rSmall.width, rSmall.y + rSmall.height), cv::Scalar(0, 0, 255, 255), 1);
                int bins[3][256];
                std::fill(bins[0], bins[0] + 3 * 256, 0);
                for (int y = 0; y < r.height-20; y++) {
                    for (int x = 0; x < r.width-20; x++) {
                        Vec3b color = clip.at<Vec3b>(cv::Point(x, y));
                        bins[0][(int)color.val[0]]++;
                        bins[1][(int)color.val[1]]++;
                        bins[2][(int)color.val[2]]++;
                    }
                }
                double mostFrequentIntensity = -1;
                int frequency=-1;
                for(int i=1; i<255; i++)
                {
                    if(bins[0][i] > frequency)
                    {
                        frequency = bins[0][i];
                        mostFrequentIntensity = i;
                    }
                }
                double redIntensity = mostFrequentIntensity;
                mostFrequentIntensity = -1;
                frequency=-1;
                for(int i=1; i<255; i++)
                {
                    if(bins[1][i] > frequency)
                    {
                        frequency = bins[1][i];
                        mostFrequentIntensity = i;
                    }
                }
                double greenIntensity = mostFrequentIntensity;
                mostFrequentIntensity = -1;
                frequency=-1;
                for(int i=1; i<255; i++)
                {
                    if(bins[2][i] > frequency)
                    {
                        frequency = bins[2][i];
                        mostFrequentIntensity = i;
                    }
                }
                double blueIntensity = mostFrequentIntensity;
                samples.push_back(CGRectMake(r.x, redIntensity, greenIntensity, blueIntensity));
                rectIdx++;
                rectangle(rawImage, cv::Point(r.x, r.y), cv::Point(r.x + r.width, r.y + r.height), cv::Scalar(0, 255, 0, 255), 2);
                clip.release();
            }
        }
    }
    
    std::sort(samples.begin(), samples.end(),
              [](const CGRect a, const CGRect b) {
                  return a.origin.x < b.origin.x;
              });
    
    
    double centerOfStandard = (minX + maxX) / 2;
    if (sampleCandidates.size() > 0) {
        vector<cv::Point> sample = sampleCandidates[0];
        cv::Rect r = boundingRect(sample);
        cv::Point center(r.x + r.width / 2, r.y + r.height / 2);
        double delta = abs(center.x - centerOfStandard);
        for (int idx = 1; idx < sampleCandidates.size(); idx++) {
            vector<cv::Point> contour = sampleCandidates[idx];
            r = boundingRect(contour);
            center = cv::Point(r.x + r.width / 2, r.y + r.height / 2);
            double d = abs(center.x - centerOfStandard);
            if (d < delta) {
                delta = d;
                sample = contour;
            }
        }
        r = boundingRect(sample);
        center = cv::Point(r.x + r.width / 2, r.y + r.height / 2);
        rects[rectIdx] = cv::Rect(r.x, r.y, r.width, r.height);
        cv::Rect rSmall = cv::Rect(r.x+10, r.y+10, r.width-20, r.height-20);
        
        Mat clip;
        Mat(rawCopy, rSmall).copyTo(clip);
        
        //rectangle(rawImage, cv::Point(rSmall.x, rSmall.y), cv::Point(rSmall.x + rSmall.width, rSmall.y + rSmall.height), cv::Scalar(0, 0, 255, 255), 1);
        
        int bins[3][256];
        std::fill(bins[0], bins[0] + 3 * 256, 0);
        for (int y = 0; y < r.height-20; y++) {
            for (int x = 0; x < r.width-20; x++) {
                Vec3b color = clip.at<Vec3b>(cv::Point(x, y));
                bins[0][(int)color.val[0]]++;
                bins[1][(int)color.val[1]]++;
                bins[2][(int)color.val[2]]++;
            }
        }
        double mostFrequentIntensity = -1;
        int frequency=-1;
        for(int i=1; i<255; i++)
        {
            if(bins[0][i] > frequency)
            {
                frequency = bins[0][i];
                mostFrequentIntensity = i;
            }
        }
        double redIntensity = mostFrequentIntensity;
        mostFrequentIntensity = -1;
        frequency=-1;
        for(int i=1; i<255; i++)
        {
            if(bins[1][i] > frequency)
            {
                frequency = bins[1][i];
                mostFrequentIntensity = i;
            }
        }
        double greenIntensity = mostFrequentIntensity;
        mostFrequentIntensity = -1;
        frequency=-1;
        for(int i=1; i<255; i++)
        {
            if(bins[2][i] > frequency)
            {
                frequency = bins[2][i];
                mostFrequentIntensity = i;
            }
        }
        double blueIntensity = mostFrequentIntensity;
        rectIdx++;
        samples.push_back(CGRectMake(r.x, redIntensity, greenIntensity, blueIntensity));
        rectangle(rawImage, cv::Point(r.x, r.y), cv::Point(r.x + r.width, r.y + r.height), Scalar(0, 255, 0, 255), 2);
        clip.release();
    }
    
    cout << "Sorted: " << endl;
    for(int i=0; i < samples.size(); i++){
        cout << samples[i].origin.x << ": " << samples[i].origin.y << ", " << samples[i].size.width << ", " << samples[i].size.height << endl;
    }
    
    
    UIImage *finalImage = MatToUIImage(rawImage);
    rawImage.release();
    grayImage.release();
    threshImage.release();
    rawCopy.release();
    
    if(rectIdx == NO_OF_RECTS){
        cout << "Final ROIs detected." << endl;
        if(NO_OF_RECTS == 7){
            finalSamples = @[[NSValue valueWithCGRect:samples[0]],
                                  [NSValue valueWithCGRect:samples[1]],
                                  [NSValue valueWithCGRect:samples[2]],
                                  [NSValue valueWithCGRect:samples[3]],
                                  [NSValue valueWithCGRect:samples[4]],
                                  [NSValue valueWithCGRect:samples[5]],
                                  [NSValue valueWithCGRect:samples[6]]];
            resultAvailable = true;
        }
        else{
            finalSamples = @[[NSValue valueWithCGRect:samples[0]],
                             [NSValue valueWithCGRect:samples[1]],
                             [NSValue valueWithCGRect:samples[2]],
                             [NSValue valueWithCGRect:samples[3]],
                             [NSValue valueWithCGRect:samples[4]],
                             [NSValue valueWithCGRect:samples[5]]];
            resultAvailable = true;
        }
        
        return finalImage;
    }
    resultAvailable = false;
    cout << "Couldn't detect ROI." << endl;
    return nil;
}
-(void) testImage:(UIImage*) image{
    Mat raw;
    UIImageToMat(image, raw);
    if(raw.channels() == 4)
    {
        cvtColor(raw, raw, CV_BGRA2BGR);
    }
    for (int y = 0; y < raw.rows; y++) {
        for (int x = 0; x < raw.cols; x++) {
            Vec3b color = raw.at<Vec3b>(cv::Point(x, y));
            int r = (int)color.val[0];
            int g = (int)color.val[1];
            int b = (int)color.val[2];
            //int a = (int)color.val[3];
            
            cout << r << "," << g << "," << b << endl;// "," << a <<endl;
        }
    }
}
-(NSArray *) getFinalSamples{
    if(resultAvailable){
        resultAvailable = false;
        return finalSamples;
    }
    return nil;
}
@end
