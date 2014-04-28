//
//  RMViewController.m
//  MindBodyStaffApp
//
//  Created by macmoniz on 2014-04-27.
//  Copyright (c) 2014 ryanmoniz. All rights reserved.
//

#import "RMViewController.h"
#import "RMMBOManager.h"
#import "RMStaffService.h"
#import "SVProgressHUD.h"

#import "RMStaffAppointmentsViewController.h"

@interface RMViewController ()

@end

@implementation RMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

   self.finalStaffArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
   [super viewDidAppear:animated];

   if ([self.finalStaffArray count] == 0) {
      [RMMBOManager sharedInstance].sourceNameString = @"MBO.Ryan.Moniz";
      [RMMBOManager sharedInstance].sourcePasswordString = @"d0gBou6OdzOXpLIYQG8x0OvBfgU=";
      [RMMBOManager sharedInstance].xmlnsURLString = @"http://clients.mindbodyonline.com/api/0_5";

      RMStaffService *getStaffRequest = [[RMStaffService alloc] init];

      if (nil != getStaffRequest) {
         getStaffRequest.delegate = self;
         getStaffRequest.selector = @selector(getStaffResponse:);
         getStaffRequest.xmlDetail = @"Full"; //enum
         getStaffRequest.siteIDString = @"-31100";

         //display hud
         [SVProgressHUD show];

         [getStaffRequest getStaff];
      }
      else {
         NSLog(@"getStaffRequest was nil");
         dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
         });
      }
   }
}

- (void)getStaffResponse:(id)arg {
   dispatch_async(dispatch_get_main_queue(), ^{
      [SVProgressHUD dismiss];
   });

   if ([arg isKindOfClass:[NSArray class]]) {
      //filter on ID>0
      if([self.finalStaffArray count] > 0) {
         [self.finalStaffArray removeAllObjects];
      }

      for (NSDictionary *staff in arg) {
         if ([[staff valueForKey:@"ID"] intValue] > 0) {
            [self.finalStaffArray addObject:staff];
         }
      }

      NSLog(@"finalStaffArray = %@",[self.finalStaffArray description]);
      [self.tableView reloadData];
   }
}


#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self.finalStaffArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *simpleTableIdentifier = @"StaffCell";

   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

   if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
   }

   cell.textLabel.text = [[self.finalStaffArray objectAtIndex:indexPath.row] valueForKey:@"Name"];
   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   if ([segue.identifier isEqualToString:@"ShowStaffAppointment"]) {
      NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
      RMStaffAppointmentsViewController *destViewController = segue.destinationViewController;
      //destViewController.recipeName = [recipes objectAtIndex:indexPath.row];
   }
}

@end
