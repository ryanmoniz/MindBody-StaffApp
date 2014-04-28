//
//  RMMBOManager.h
//  GetStaffSOAP
//
//  Created by macmoniz on 2014-04-27.
//  Copyright (c) 2014 ryanmoniz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMMBOManager : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic, strong)NSString *sourceNameString;
@property(nonatomic, strong)NSString *sourcePasswordString;
@property(nonatomic, strong)NSString *xmlnsURLString;

@end
