//
//  DNAPMMonitor.m
//  APMMonitor
//
//  Created by Andrew Pouliot on 8/9/10.
//  Copyright 2010 Darknoon. All rights reserved.
//

#import "DNAPMMonitor.h"

#import "NSEvent+Timestamp.h"


@implementation DNAPMMonitor

+ (id)sharedMonitor;
{
	static DNAPMMonitor *instance = nil;
	if (!instance) {
		instance = [[DNAPMMonitor alloc] init];
	}
	return instance;
}

- (id) init {
	[super init];
	if (self == nil) return self; 
	
	previousActions = [[NSMutableArray alloc] init];
	queueSize = 10;
	
	return self;
}

- (void) dealloc
{
	[previousActions release], previousActions = nil;
	
	[super dealloc];
}



/*
 
 <click>
 abc_
 abcd<return>
 oeu<return>
 
 */

- (double)currentAPMEstimate;
{
	//Return 1/the average difference in time for the last 10 actions
	double apmEstimate = 0.0;
	
	if (previousActions.count == queueSize) {
		NSEvent *firstEvent = [previousActions objectAtIndex:0];
		//NSEvent *lastEvent = [previousActions objectAtIndex:previousActions.count - 1];
		apmEstimate = previousActions.count * 1.0 / ([NSEvent timestamp] - [firstEvent timestamp]) * 60.0;
	}
	
	return apmEstimate;
}

//Called on some random thread
- (void)noticeEvent:(NSEvent *)inEvent;
{
	dispatch_async(dispatch_get_main_queue(), ^{
		//Process the event.
		//Mouse commands end typing mode
		BOOL shouldEnqueue = YES;
		switch ([inEvent type]) {
			case NSLeftMouseDown:
			case NSRightMouseDown:
				currentAction = DNAPMMonitorCurrentActionNone;
				break;
			case NSKeyDown:
				//If it's a command
				if ([inEvent modifierFlags] & (NSControlKeyMask | NSCommandKeyMask)) {
					currentAction = DNAPMMonitorCurrentActionNone;
				} else {
					if (currentAction == DNAPMMonitorCurrentActionTyping) {
						if ([[inEvent characters] isEqualToString:@" "]) {
							shouldEnqueue = YES;
						} else {
							//Don't count further typing actions
							shouldEnqueue = NO;
						}
					}					
				}
				currentAction = DNAPMMonitorCurrentActionTyping ;
				break;
		}
		
		if (shouldEnqueue) {
			if (previousActions.count >= queueSize) {
				[previousActions removeObjectAtIndex:0];
			}
			//Add to queue
			[previousActions addObject:inEvent];
		}
	});
}

- (void)startMonitoring;
{
	
	unsigned long long eventMask = NSLeftMouseDownMask | NSKeyDownMask | NSRightMouseDownMask;
	
	globalEventMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:eventMask
														  handler:^ (NSEvent *e){
															  [self noticeEvent:e];
														  }];
	localEventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:eventMask
															  handler:^ (NSEvent *e){
																  [self noticeEvent:e];
																  return e;
															  }];
	[globalEventMonitor retain];
	[localEventMonitor retain];
}

- (void)endMonitoring {
	[NSEvent removeMonitor:globalEventMonitor];
	[NSEvent removeMonitor:localEventMonitor];
	[globalEventMonitor release];
	[localEventMonitor release];
}

@end
