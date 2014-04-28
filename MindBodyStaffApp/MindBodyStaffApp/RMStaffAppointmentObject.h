//
//  RMStaffAppointmentObject.h
//  MindBodyStaffApp
//
//  Created by macmoniz on 2014-04-28.
//  Copyright (c) 2014 ryanmoniz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMStaffAppointmentObject : NSObject
@property(nonatomic, strong)NSString *apptDate;
@property(nonatomic, strong)NSString *startTime;
@property(nonatomic, strong)NSString *endTime;
@property(nonatomic, strong)NSString *clientName;
@property(nonatomic, strong)NSString *sessionType;

@end
