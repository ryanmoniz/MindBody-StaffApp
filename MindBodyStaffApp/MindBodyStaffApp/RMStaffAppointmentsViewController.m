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
#import "RMStaffAppointmentObject.h"

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

   self.staffApptsArray = [[NSMutableArray alloc] init];

   self.title = [NSString stringWithFormat:@"%@ %@",self.staffFirstNameString, self.staffLastNameString];

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
      
      for (NSDictionary *dict in arg) {
         RMStaffAppointmentObject *appt = [[RMStaffAppointmentObject alloc] init];
         NSArray *dateArray = [[dict valueForKey:@"StartDateTime"] componentsSeparatedByString:@"T"];
         appt.apptDate = [dateArray objectAtIndex:0];
         appt.startTime = [dateArray objectAtIndex:1];
         dateArray = [[dict valueForKey:@"EndDateTime"] componentsSeparatedByString:@"T"];
         appt.endTime = [dateArray objectAtIndex:1];
         appt.clientName = [NSString stringWithFormat:@"%@ %@",[[dict valueForKey:@"Client"] valueForKey:@"FirstName"],[[dict valueForKey:@"Client"] valueForKey:@"LastName"]];
         appt.sessionType = [[dict valueForKey:@"SessionType"] valueForKey:@"Name"];
         [self.staffApptsArray addObject:appt];
      }
      [self.tableView reloadData];
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
   static NSString *CellIdentifier = @"ApptDetails";
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

   // Configure the cell...
   if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
   }

   UILabel *apptDateLabel = (UILabel *)[cell viewWithTag:5];
   apptDateLabel.text = [[self.staffApptsArray objectAtIndex:indexPath.row] apptDate];

   UILabel *startTimeLabel = (UILabel *)[cell viewWithTag:1];
   startTimeLabel.text = [[self.staffApptsArray objectAtIndex:indexPath.row] startTime];

   UILabel *endTimeLabel = (UILabel *)[cell viewWithTag:2];
   endTimeLabel.text = [[self.staffApptsArray objectAtIndex:indexPath.row] endTime];

   UILabel *clientNameLabel = (UILabel *)[cell viewWithTag:3];
   clientNameLabel.text = [[self.staffApptsArray objectAtIndex:indexPath.row] clientName];

   UILabel *sessionLabel = (UILabel *)[cell viewWithTag:4];
   sessionLabel.text = [[self.staffApptsArray objectAtIndex:indexPath.row] sessionType];

   cell.textLabel.text = @"";

   return cell;
}



@end
