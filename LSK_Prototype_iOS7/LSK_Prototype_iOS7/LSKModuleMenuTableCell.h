//
//  LSKModuleMenuTableCell.h
//  LSK_Prototype_iOS7
//
//  Created by Mike Cumberworth on 1/26/14.
//  Copyright (c) 2014 Mike Cumberworth. All rights reserved.
//


@interface LSKModuleMenuTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *moduleMenuIcon;
@property (weak, nonatomic) IBOutlet UILabel *targetLanguageName;
@property (weak, nonatomic) IBOutlet UILabel *moduleName;

@end
