# ConcAnalyzer - Blood Analysis App (iOS)

This repository contains the sources for GSoC 2017 project named [**Mobile Based Blood Analysis (iOS)**](https://summerofcode.withgoogle.com/projects/#4809191788118016) with Computational Biology @ **University of Nebraska-Lincoln**. This project is a continuation of the [GSoC 2016 project](https://github.com/abdulfatir/blood-analysis-app) of the same name. This year the iOS version of ConcAnalyzer was developed.

## Introduction

The aim of this project is to use the camera and processing power of modern day cell phones to develop an intuitive and user-friendly application for the detection and concentration estimation of various bio-markers in blood sample images. It is later planned to be used as a screening test for cancer. The application will allow the user to take images of the blood samples in a set format. The image will then be segmented to detect the regions of interest. After noise removal, the intensity of each individual blob will be calculated. A linear curve will be fit through the intensity and known concentration data and the concentrations of the unknown samples will be estimated from the standard curve which will quantify the various molecules present in the sample.

## Demo

A video showing entire usage flow of the final iOS Application can be found [here](https://www.youtube.com/watch?v=MH3_-PCBkHk).

## Downloads

### How to Build

1. Clone the repository or download it as a [zip file](https://github.com/abdulfatir/blood-analysis-app-ios/archive/master.zip) and extract it.
2. Open it as an Xcode project.

#### Dependencies

1. Cocoapods for [Charts](https://github.com/danielgindi/Charts) pod.
2. [OpenCV](http://opencv.org/releases.html) 3.1.0 iOS Pack


## Acknowledgment

I'm indebted to Dr. Tomas Helikar for giving me the opportunity of working on this amazing project. I would also like to thank Daniel Cohen Gindi & Philipp Jahoda, whose library, [Charts](https://github.com/danielgindi/Charts), has been used in this project. It has been released under Apache License 2.0.

Also, Thank you, Google. :D

### License for Charts

Copyright 2016 Daniel Cohen Gindi & Philipp Jahoda

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

```
http://www.apache.org/licenses/LICENSE-2.0
```

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

