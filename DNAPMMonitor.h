//
//  DNAPMMonitor.h
//  APMMonitor
//
//  Created by Andrew Pouliot on 8/9/10.
//  Copyright 2010 Darknoon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	DNAPMMonitorCurrentActionTyping = 1,
	DNAPMMonitorCurrentActionNone = 0
} DNAPMMonitorCurrentAction;

@interface DNAPMMonitor : NSObject {
	NSTimeInterval lastEventTime;
	id globalEventMonitor;
	id localEventMonitor;
	
	NSUInteger queueSize;
	
	DNAPMMonitorCurrentAction currentAction;
	
	NSMutableArray *previousActions;
}

+ (id)sharedMonitor;

- (void)startMonitoring;
- (void)endMonitoring;

- (double)currentAPMEstimate;

@end
