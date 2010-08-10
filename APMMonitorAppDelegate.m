//
//  APMMonitorAppDelegate.m
//  APMMonitor
//
//  Created by Andrew Pouliot on 8/9/10.
//  Copyright 2010 Darknoon. All rights reserved.
//

#import "APMMonitorAppDelegate.h"

#import "DNAPMMonitor.h"

@implementation APMMonitorAppDelegate

@synthesize outputTextField;
@synthesize window;

- (void)dealloc
{
	[outputTextField release];
	outputTextField = nil;

	[super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	
	if (!AXAPIEnabled()) {
		NSAlert *alert = [NSAlert alertWithMessageText:@"Settings Error"
										 defaultButton:@"Quit"
									   alternateButton:nil
										   otherButton:nil
							 informativeTextWithFormat:@"To use this application, you must enable the \"Enable access for assistive devices\" setting in System Preferences.\n\nThis requirement will be removed in a future version."];
		[alert runModal];
		exit(1);
	}
	
	[[DNAPMMonitor sharedMonitor] startMonitoring];
	
	updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkAPM) userInfo:nil repeats:YES];
	
	[window setLevel:NSFloatingWindowLevel];
}

- (void)checkAPM;
{
	double currentAPMEstimate = [[DNAPMMonitor sharedMonitor] currentAPMEstimate];
	if (currentAPMEstimate > 0.0) {
		[outputTextField setStringValue:[NSString stringWithFormat:@"%.f", currentAPMEstimate]];
	} else {
		[outputTextField setStringValue:@"…"];
	}

}

@end
