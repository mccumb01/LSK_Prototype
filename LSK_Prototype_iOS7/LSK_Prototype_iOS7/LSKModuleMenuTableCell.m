//
//  LSKModuleMenuTableCell.m
//  LSK_Prototype_iOS7
//
//  Created by Mike Cumberworth on 1/26/14.
//  Copyright (c) 2014 Mike Cumberworth. All rights reserved.
//

#import "LSKModuleMenuTableCell.h"

@implementation LSKModuleMenuTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
