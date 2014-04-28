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

const int RMIndexFirstCharacterNameInteger = 1;

@interface RMAppointmentService ()
- (void)sendRequestForSOAPMethod:(NSString *)soapActionString withSOAPMessage:(NSString *)soapMessage;
@end

@implementation RMAppointmentService

- (id)init {
   if (self = [super init]) {
      self.wsdlMethodURL = @"https://api.mindbodyonline.com/0_5/AppointmentService.asmx";
      return self;
   }
   return nil;
}

- (void)getAppointmentForStaffWithFirstName:(NSString *)firstNameString lastName:(NSString *)lastNameString staffID:(NSString *)staffIDString withStartDate:(NSString *)startDateString toEndDate:(NSString *)endDateString {

   NSString *soapActionString= @"http://clients.mindbodyonline.com/api/0_5/GetStaffAppointments";

   if (([firstNameString length] > 0) && ([lastNameString length] > 0) && ([staffIDString length] > 0)) {
      NSString *staffUserNameString = [NSString stringWithFormat:@"%@.%@",firstNameString,lastNameString];
      NSString *staffPasswordString = [NSString stringWithFormat:@"%@%@%@",[[firstNameString substringToIndex:RMIndexFirstCharacterNameInteger] lowercaseString],[[lastNameString substringToIndex:RMIndexFirstCharacterNameInteger] lowercaseString],staffIDString];

      //assume if startDate/endDate is nil, use today.
      if (([startDateString length] == 0) && ([endDateString length] == 0)) {
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         [dateFormatter setDateFormat:@"YYYY-MM-DD"];
         startDateString = [dateFormatter stringFromDate:[NSDate date]];
         endDateString = [dateFormatter stringFromDate:[NSDate date]];
      }

      NSString *soapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:_5=\"%@\"><soapenv:Header/>"
                               "<soapenv:Body>"
                               "<_5:GetStaffAppointments>"
                               "<_5:Request>"
                               "<_5:SourceCredentials>"
                               "<_5:SourceName>%@</_5:SourceName>"
                               "<_5:Password>%@</_5:Password>"
                               "<_5:SiteIDs><!--Zero or more repetitions:-->"
                               "<_5:int>%@</_5:int>"
                               "</_5:SiteIDs>"
                               "</_5:SourceCredentials>"
                               "<_5:XMLDetail>%@</_5:XMLDetail>"
                               "<_5:StaffCredentials>"
                               "<_5:Username>%@</_5:Username>"
                               "<_5:Password>%@</_5:Password>"
                               "<_5:SiteIDs><!--Zero or more repetitions:-->"
                               "<_5:int>%@</_5:int>"
                               "</_5:SiteIDs>"
                               "</_5:StaffCredentials>"
                               "<_5:StartDate>%@</_5:StartDate>"
                               "<_5:EndDate>%@</_5:EndDate>"
                               "</_5:Request>"
                               "</_5:GetStaffAppointments>"
                               "</soapenv:Body>"
                               "</soapenv:Envelope>",[RMMBOManager sharedInstance].xmlnsURLString,[RMMBOManager sharedInstance].sourceNameString,[RMMBOManager sharedInstance].sourcePasswordString,self.siteIDString,self.xmlDetail,staffUserNameString,staffPasswordString,self.siteIDString,startDateString,endDateString];

      //---print the XML to examine---
      NSLog(@"Request XML*****************\n%@\n*********************", soapMessage);

      [self sendRequestForSOAPMethod:soapActionString withSOAPMessage:soapMessage];

   }
}

- (void)sendRequestForSOAPMethod:(NSString *)soapActionString withSOAPMessage:(NSString *)soapMessage {
   NSURL *url = [NSURL URLWithString:self.wsdlMethodURL];
   NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
   NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];

   [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
   [theRequest addValue: soapActionString forHTTPHeaderField:@"SOAPAction"];
   [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
   [theRequest setHTTPMethod:@"POST"];
   [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];

   AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                        initWithRequest:theRequest];
   operation.responseSerializer = [AFXMLDictionaryResponseSerializer serializer];

   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      NSLog(@"responseObject = %@",responseObject);

      NSDictionary *staffResponseDict = [responseObject valueForKey:@"soap:Body"];
      NSDictionary *getStaffApptResponsetDict = [staffResponseDict valueForKey:@"GetStaffAppointmentsResponse"];
      NSDictionary *getStaffApptResults = [getStaffApptResponsetDict valueForKey:@"GetStaffAppointmentsResult"];
      NSDictionary *appointmentsDict = [getStaffApptResults valueForKey:@"Appointments"];
      
      NSArray *apptArray = [appointmentsDict valueForKey:@"Appointment"];

      if ((self.delegate != nil) && ([self.delegate respondsToSelector:self.selector])) {
         dispatch_async(dispatch_get_main_queue(), ^{
            [self dispatchSelector:self.selector
                            target:self.delegate
                           objects:[NSArray arrayWithObjects:apptArray, nil]
                      onMainThread:YES];
         });
      }
   }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       NSLog(@"failed");
                                       [self dispatchSelector:self.selector
                                                       target:self.delegate
                                                      objects:[NSArray arrayWithObjects:error,nil]
                                                 onMainThread:YES];
                                    }];
   [operation start];
}


@end
