//
//  LSKModuleMenuTableViewController.h
//  LSK_Prototype_iOS7
//
//  Created by Mike Cumberworth on 1/26/14.
//  Copyright (c) 2014 Mike Cumberworth. All rights reserved.
//


@interface LSKModuleMenuTableViewController : UITableViewController

@property (nonatomic, copy) void (^menuSelected)(BOOL success, NSDictionary *selectedModule);



@end
