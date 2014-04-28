//
//  RMStaffService.h
//  GetStaffSOAP
//
//  Created by macmoniz on 2014-04-27.
//  Copyright (c) 2014 ryanmoniz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMStaffService : NSObject

- (void)getStaff;

@property(nonatomic, weak)id delegate;
@property(nonatomic, assign)SEL selector;

@property(nonatomic, strong)NSString *xmlDetail;

@property(nonatomic, strong)NSString *siteIDString;

@end
