//
//  LSKPhrase.h
//  LSK_Prototype_iOS7
//
//  Created by Mike Cumberworth on 1/26/14.
//  Copyright (c) 2014 Mike Cumberworth. All rights reserved.
//



@interface LSKPhrase : NSObject


@property (nonatomic, readonly, strong)   NSString *phraseID;
@property (nonatomic, readonly, strong)   NSString *categoryID;
@property (nonatomic, readonly, strong)   NSString *englishPhrase;
@property (nonatomic, readonly, strong)   NSString *romanizedPhrase;
@property (nonatomic, readonly, strong)   NSString *unicodePhrase;
@property (nonatomic, readonly, strong)   NSString *audioName;
@property (nonatomic, readonly, strong)   NSNumber *phraseOrder;
@property (nonatomic, assign, getter = isPlaying)   BOOL playing;

- (LSKPhrase *) initWithDictionary:(NSDictionary *)phraseDict;


@end
