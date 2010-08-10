
#import "NSEvent+Timestamp.h"

#include <assert.h>
#include <mach/mach.h>
#include <mach/mach_time.h>

//I blatantly stole this from: http://www.iphonedevsdk.com/forum/iphone-sdk-development/11312-time-since-system-startup.html
//I don't know the author, but it's short and probably nobody is going to care.
double getUpTime() {
	
	static mach_timebase_info_data_t sTimebaseInfo;
	// If this is the first time we've run, get the timebase.
	// We can use denom == 0 to indicate that sTimebaseInfo is
	// uninitialised because it makes no sense to have a zero
	// denominator is a fraction.
	if ( sTimebaseInfo.denom == 0 ) {
		(void) mach_timebase_info(&sTimebaseInfo);
	}
	uint64_t thenano;
	thenano = mach_absolute_time() * sTimebaseInfo.numer / sTimebaseInfo.denom;
	return thenano / 1000000000.0;
	
}
@implementation NSEvent(Timestamp)

+ (NSTimeInterval)timestamp;
{	
	return getUpTime();
}

@end