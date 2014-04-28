//
//  RMStaffService.m
//  GetStaffSOAP
//
//  Created by macmoniz on 2014-04-27.
//  Copyright (c) 2014 ryanmoniz. All rights reserved.
//

#import "RMStaffService.h"
#import "RMMBOManager.h"
#import "AFHTTPRequestOperation.h"
#import "AFXMLDictionaryResponseSerializer.h"

@interface RMStaffService ()
@property(nonatomic, strong)NSString *wsdlMethodURL;

@end

@implementation RMStaffService

- (id)init {
   if (self = [super init]) {
      self.wsdlMethodURL = @"https://api.mindbodyonline.com/0_5/StaffService.asmx";
      return self;
   }

   return nil;
}

- (void)getStaff {
   NSString *soapActionString= @"http://clients.mindbodyonline.com/api/0_5/GetStaff";

   NSString *soapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:_5=\"%@\"><soapenv:Header/>"
                        "<soapenv:Body>"
                        "<_5:GetStaff>"
                        "<_5:Request>"
                        "<_5:SourceCredentials>"
                        "<_5:SourceName>%@</_5:SourceName>"
                        "<_5:Password>%@</_5:Password>"
                        "<_5:SiteIDs><!--Zero or more repetitions:-->"
                        "<_5:int>%@</_5:int>"
                        "</_5:SiteIDs>"
                        "</_5:SourceCredentials>"
                        "<_5:XMLDetail>%@</_5:XMLDetail>"
                        "</_5:Request>"
                        "</_5:GetStaff>"
                        "</soapenv:Body>"
                        "</soapenv:Envelope>",[RMMBOManager sharedInstance].xmlnsURLString,[RMMBOManager sharedInstance].sourceNameString,[RMMBOManager sharedInstance].sourcePasswordString,self.siteIDString,self.xmlDetail];

   //---print the XML to examine---
   NSLog(@"Request XML*****************\n%@\n*********************", soapMessage);


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

      if ((self.delegate != nil) && ([self.delegate respondsToSelector:self.selector])) {
         dispatch_async(dispatch_get_main_queue(), ^{
            [self dispatchSelector:self.selector
                            target:self.delegate
                           objects:[NSArray arrayWithObjects:responseObject, nil]
                      onMainThread:YES];
         });
      }
   }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       NSLog(@"failed");
                                    }];
   [operation start];
   
}

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
