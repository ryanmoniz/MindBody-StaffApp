//
//  RMStaffAppointmentsViewController.h
//  MindBodyStaffApp
//
//  Created by macmoniz on 2014-04-27.
//  Copyright (c) 2014 ryanmoniz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMStaffAppointmentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,weak)IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *staffApptsArray;

@property(nonatomic,strong)NSString *staffFirstNameString;
@property(nonatomic,strong)NSString *staffLastNameString;
@property(nonatomic,strong)NSString *staffIDString;
@property(nonatomic,strong)NSString *siteIDString;
@property(nonatomic,strong)NSString *startDateString;
@property(nonatomic,strong)NSString *endDateString;


@end
