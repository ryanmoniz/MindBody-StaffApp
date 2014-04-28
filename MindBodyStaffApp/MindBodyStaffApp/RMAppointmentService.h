//
//  RMAppointmentService.h
//  MindBodyStaffApp
//
//  Created by macmoniz on 2014-04-27.
//  Copyright (c) 2014 ryanmoniz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMBaseService.h"

extern const int RMIndexFirstCharacterNameInteger;

@interface RMAppointmentService : RMBaseService

@property(nonatomic, strong)NSString *siteIDString;

- (void)getAppointmentForStaffWithFirstName:(NSString *)firstNameString lastName:(NSString *)lastNameString staffID:(NSString *)staffIDString withStartDate:(NSString *)startDateString toEndDate:(NSString *)endDateString;
@end
