//
//  RMBaseService.h
//  MindBodyStaffApp
//
//  Created by macmoniz on 2014-04-27.
//  Copyright (c) 2014 ryanmoniz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMBaseService : NSObject

@property(nonatomic, weak)id delegate;
@property(nonatomic, assign)SEL selector;
@property(nonatomic, strong)NSString *wsdlMethodURL;

@property(nonatomic, strong)NSString *xmlDetail;

- (void) dispatchSelector:(SEL)selector
                   target:(id)target
                  objects:(NSArray*)objects
             onMainThread:(BOOL)onMainThread;

@end
