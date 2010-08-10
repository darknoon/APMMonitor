//
//  APMMonitorAppDelegate.h
//  APMMonitor
//
//  Created by Andrew Pouliot on 8/9/10.
//  Copyright 2010 Darknoon. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface APMMonitorAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	IBOutlet NSTextField *outputTextField;
	
	NSTimer *updateTimer;
}

@property (nonatomic, retain) NSTextField *outputTextField;
@property (assign) IBOutlet NSWindow *window;

@end
