//
//  LSKItemCustomCell.m
//  LSK_Prototype_iOS7
//
//  Created by Mike Cumberworth on 1/25/14.
//  Copyright (c) 2014 Mike Cumberworth. All rights reserved.
//

#import "LSKItemCustomCell.h"

@interface LSKItemCustomCell ()



@end

@implementation LSKItemCustomCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.phraseAudioButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
        UIView *selectedView = [[UIView alloc] init];
        selectedView.backgroundColor = [UIColor colorWithRed:70.0/255.0f green:0.0f blue:190.0/255.0f alpha:0.8f];
        self.selectedBackgroundView = selectedView;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.phraseTextEnglish.preferredMaxLayoutWidth = CGRectGetWidth(self.phraseTextEnglish.frame);
}



@end
