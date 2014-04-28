//
//  RMMBOManager.m
//  GetStaffSOAP
//
//  Created by macmoniz on 2014-04-27.
//  Copyright (c) 2014 ryanmoniz. All rights reserved.
//

#import "RMMBOManager.h"

@implementation RMMBOManager

+ (instancetype)sharedInstance
{
   static dispatch_once_t once;
   static RMMBOManager *sharedInstance;
   dispatch_once(&once, ^{
      sharedInstance = [[self alloc] init];
   });
   return sharedInstance;
}

@end
