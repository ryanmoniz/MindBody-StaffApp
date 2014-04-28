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

@end
