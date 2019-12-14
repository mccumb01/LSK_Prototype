//
//  LSKModule.m
//  LSK_Prototype_iOS7
//
//  Created by Mike Cumberworth on 2/17/14.
//  Copyright (c) 2014 Mike Cumberworth. All rights reserved.
//

#import "LSKModules.h"


@implementation LSKModules

//Need to convert this to singleton w/class methods - there can be only one list & I don't want to create it repeatedly.

- (LSKModules *) init{

    if (self = [super init]){
        
        return self;
    }
    return nil;
}


+(NSArray *) getModules
{
    NSDictionary *mod1 = @{@"name": @"Air Crew", @"path":@"airCrew", @"audio_id":@"ac", @"image":@"airCrew"};
    NSDictionary *mod2 = @{@"name": @"Basic Guide", @"path":@"basicGuide", @"audio_id":@"bc", @"image":@"basic"};
    NSDictionary *mod3 = @{@"name": @"Civil Affairs", @"path":@"civilAffairs", @"audio_id":@"ca", @"image":@"civilAffairs"};
    NSDictionary *mod4 = @{@"name": @"Medical Guide", @"path":@"medicalGuide", @"audio_id":@"md", @"image":@"medical"};
    NSDictionary *mod5 = @{@"name": @"Naval Guide", @"path":@"navalGuide", @"audio_id":@"nv", @"image":@"naval"};
    NSDictionary *mod6 = @{@"name": @"Public Affairs", @"path":@"publicAffairs", @"audio_id":@"pa", @"image":@"publicAffairs"};
    
    NSArray *modules = @[mod1, mod2, mod3, mod4, mod5, mod6];
    return modules;
}


@end
