//
//  RMStaffService.h
//  GetStaffSOAP
//
//  Created by macmoniz on 2014-04-27.
//  Copyright (c) 2014 ryanmoniz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMBaseService.h"

@interface RMStaffService : RMBaseService

- (void)getStaff;

@property(nonatomic, strong)NSString *siteIDString;

@end
