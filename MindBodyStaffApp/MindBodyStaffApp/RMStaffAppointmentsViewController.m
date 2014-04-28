//
//  RMStaffAppointmentsViewController.m
//  MindBodyStaffApp
//
//  Created by macmoniz on 2014-04-27.
//  Copyright (c) 2014 ryanmoniz. All rights reserved.
//

#import "RMStaffAppointmentsViewController.h"
#import "RMMBOManager.h"
#import "SVProgressHUD.h"
#import "RMAppointmentService.h"

@interface RMStaffAppointmentsViewController ()

@end

@implementation RMStaffAppointmentsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
   [super viewDidAppear:animated];

   self.staffApptsArray = [[NSArray alloc] init];

   RMAppointmentService *getStaffApptRequest = [[RMAppointmentService alloc] init];

   if (nil != getStaffApptRequest) {
      getStaffApptRequest.delegate = self;
      getStaffApptRequest.selector = @selector(getStaffApptResponse:);
      getStaffApptRequest.xmlDetail = @"Full"; //enum
      getStaffApptRequest.siteIDString = [RMMBOManager sharedInstance].siteIDString;

      //display hud
      [SVProgressHUD show];

      [getStaffApptRequest getAppointmentForStaffWithFirstName:self.staffFirstNameString
                                                      lastName:self.staffLastNameString
                                                       staffID:self.staffIDString
                                                 withStartDate:self.startDateString
                                                     toEndDate:self.endDateString];
   }
   else {
      NSLog(@"getStaffApptRequest was nil");
      dispatch_async(dispatch_get_main_queue(), ^{
         [SVProgressHUD dismiss];
      });
   }
}

- (void)getStaffApptResponse:(id)arg {
   dispatch_async(dispatch_get_main_queue(), ^{
      [SVProgressHUD dismiss];
   });

   if ([arg isKindOfClass:[NSArray class]]) {
      //displaying the appointment date, start and end time, client name, and type of appointment (session).
      
   }
   else if ([arg isKindOfClass:[NSError class]]) {
      NSLog(@"Error=%@",[arg description]);
      UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:@"An Error has occurred, check logs and please try again." delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil, nil];
      [error show];
   }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self.staffApptsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *simpleTableIdentifier = @"Cell";

   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

   if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
   }

   cell.textLabel.text = @"";
   return cell;
}



@end
