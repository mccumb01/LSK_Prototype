//
//  LSKAppDelegate.h
//  LSK_Prototype_iOS7
//
//  Created by Mike Cumberworth on 1/25/14.
//  Copyright (c) 2014 Mike Cumberworth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class LSKCategoryList, LSKModules;

@interface LSKAppDelegate : UIResponder <UIApplicationDelegate>

{
    int currentModuleIndexPath;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSArray *moduleList;
@property (nonatomic, strong) NSString *langID;
@property (nonatomic, strong) NSString *currentModuleID;
@property (nonatomic, strong) NSString *currentModuleAudioPath;
@property (nonatomic, strong) NSArray *bgImages;

-(void) setCurrentModuleIndex:(int)index;
-(NSDictionary *) getCurrentModule;

@end
