//
//  LSKPhrase.m
//  LSK_Prototype_iOS7
//
//  Created by Mike Cumberworth on 1/26/14.
//  Copyright (c) 2014 Mike Cumberworth. All rights reserved.
//

#import "LSKPhrase.h"
#import "LSKAppDelegate.h"

@interface LSKPhrase()

@property (nonatomic, readwrite, strong)   NSString *phraseID;
@property (nonatomic, readwrite, strong)   NSString *categoryID;
@property (nonatomic, readwrite, strong)   NSString *englishPhrase;
@property (nonatomic, readwrite, strong)   NSString *romanizedPhrase;
@property (nonatomic, readwrite, strong)   NSString *unicodePhrase;
@property (nonatomic, readwrite, strong)   NSString *audioName;
@property (nonatomic, readwrite, strong)   NSNumber *phraseOrder;

@end


@implementation LSKPhrase

- (LSKPhrase *) initWithDictionary:(NSDictionary *)phraseDict
{
    if (self = [super init]){

               
        if (phraseDict != nil)
        {
            self.phraseID = phraseDict[@"phraseID"];
            self.categoryID = phraseDict[@"catID"];
            self.phraseOrder = phraseDict[@"phraseOrder"];
            self.englishPhrase = phraseDict[@"englishPhrase"];
            self.romanizedPhrase = phraseDict[@"romanized"];
            self.unicodePhrase = phraseDict[@"unicode"];
            self.audioName = [NSString stringWithFormat:@"%02d_%02d", [self.categoryID intValue], [self.phraseOrder intValue]];
            self.playing = NO;
        }
        
        return self;
    }
    return nil;
}



@end
