//
//  RMAppointmentService.m
//  MindBodyStaffApp
//
//  Created by macmoniz on 2014-04-27.
//  Copyright (c) 2014 ryanmoniz. All rights reserved.
//

#import "RMAppointmentService.h"
#import "RMMBOManager.h"
#import "AFHTTPRequestOperation.h"
#import "AFXMLDictionaryResponseSerializer.h"

@implementation RMAppointmentService

- (id)init {
   if (self = [super init]) {
      self.wsdlMethodURL = @"https://api.mindbodyonline.com/0_5/AppointmentService.asmx.asmx";
      return self;
   }
   return nil;
}

@end
