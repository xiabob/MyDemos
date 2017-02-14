//
//  ViewController.h
//  ARDemo
//
//  Created by xiabob on 17/1/5.
//  Copyright © 2017年 xiabob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AR/ar.h>
#import <AR/video.h>
#import <AR/gsub_es.h>
#import "ARView.h"
#import "../ARAppCore/ARMarker.h"
#import "../ARAppCore/VirtualEnvironment.h"
#import <AR/sys/CameraVideo.h>

#import <pthread.h>
#import <thread_sub.h>
#import <AR2/tracking.h>
#import <KPM/kpm.h>

#define PAGES_MAX 10

@interface ARViewController : UIViewController <CameraVideoTookPictureDelegate> {
}

- (void)start;
- (void)stop;
- (void)processFrame:(AR2VideoBufferT *)buffer;

// Markers.
@property (readonly) NSMutableArray *markers;

// Drawing.
@property (readonly) ARView *glView;
@property (nonatomic, retain) VirtualEnvironment *virtualEnvironment;
@property (readonly) ARGL_CONTEXT_SETTINGS_REF arglContextSettings;

@property (readonly, nonatomic, getter=isRunning) BOOL running;
@property (nonatomic, getter=isPaused) BOOL paused;

// Frame interval defines how many display frames must pass between each time the
// display link fires. The display link will only fire 30 times a second when the
// frame internal is two on a display that refreshes 60 times a second. The default
// frame interval setting of one will fire 60 times a second when the display refreshes
// at 60 times a second. A frame interval setting of less than one results in undefined
// behavior.
@property (nonatomic) NSInteger runLoopInterval;

@end


