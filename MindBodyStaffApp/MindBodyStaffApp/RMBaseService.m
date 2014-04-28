//
//  RMBaseService.m
//  MindBodyStaffApp
//
//  Created by macmoniz on 2014-04-27.
//  Copyright (c) 2014 ryanmoniz. All rights reserved.
//

#import "RMBaseService.h"

@interface RMBaseService ()

@end

@implementation RMBaseService

- (void) dispatchSelector:(SEL)selector
                   target:(id)target
                  objects:(NSArray*)objects
             onMainThread:(BOOL)onMainThread {

   if(target && [target respondsToSelector:selector]) {
      NSMethodSignature* signature
      = [target methodSignatureForSelector:selector];
      if(signature) {
         NSInvocation* invocation
         = [NSInvocation invocationWithMethodSignature:signature];

         @try {
            [invocation setTarget:target];
            [invocation setSelector:selector];

            if(objects) {
               NSInteger objectsCount	= [objects count];

               for(NSInteger i=0; i < objectsCount; i++) {
                  NSObject* obj = [objects objectAtIndex:i];
                  [invocation setArgument:&obj atIndex:i+2];
               }
            }

            [invocation retainArguments];

            if(onMainThread) {
               [invocation performSelectorOnMainThread:@selector(invoke)
                                            withObject:nil
                                         waitUntilDone:NO];
            }
            else {
               [invocation performSelector:@selector(invoke)
                                  onThread:[NSThread currentThread]
                                withObject:nil
                             waitUntilDone:NO];
            }
         }
         @catch (NSException *e) {
            NSLog(@"e = %@",[e description]);
         }
         @finally {
         }
      }		
   }
}


@end
