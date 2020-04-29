//
//  NSObjectTestable.m
//
//  Copyright © 2019-2020 Purgatory Design. Licensed under the MIT License.
//

#import "NSObjectTestable.h"

@implementation NSObject (NSObjectTestable)

/**
 Provides an override point for initialization during module load.
 */
+ (void) initializeTestableFromObjC
{
}

/**
 Returns the value of the receiver for a key as a selector.

 @param key The key of the desired selector.
 @return The selector for the specified key (or a null selector).
 */
- (SEL) selectorForKey: (NSString* _Nonnull) key
{
	SEL keySelector = NSSelectorFromString(key);
	NSMethodSignature* methodSignature = [[self class] instanceMethodSignatureForSelector: keySelector];
	if (![self respondsToSelector: keySelector] || [methodSignature methodReturnLength] != sizeof(SEL))
		return (SEL) 0;

	NSInvocation* invocation = [NSInvocation invocationWithMethodSignature: methodSignature];
	[invocation setSelector: keySelector];
	[invocation setTarget: self];
	[invocation invoke];

	SEL result;
	[invocation getReturnValue: &result];
	return result;
}

@end
