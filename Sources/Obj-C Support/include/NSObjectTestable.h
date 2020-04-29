//
//  NSObjectTestable.h
//
//  Copyright © 2019-2020 Purgatory Design. Licensed under the MIT License.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (NSObjectTestable)

+ (void) initializeTestableFromObjC;

- (SEL) selectorForKey: (NSString* _Nonnull) key;

@end

NS_ASSUME_NONNULL_END
