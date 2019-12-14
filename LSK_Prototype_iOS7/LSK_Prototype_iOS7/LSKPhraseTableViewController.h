//
//  LSKPhraseTableViewController.h
//  LSK_Prototype_iOS7
//
//  Created by Mike Cumberworth on 1/25/14.
//  Copyright (c) 2014 Mike Cumberworth. All rights reserved.
//

@class LSKDetailViewController, LSKCategoryViewController, LSKCategoryList, LSKPhrase;

@interface LSKPhraseTableViewController : UITableViewController

@property (strong, nonatomic) LSKDetailViewController *detailViewController;
@property (nonatomic, strong) NSString *categoryID;
@property (strong, nonatomic) NSArray *phraseList;

@end
