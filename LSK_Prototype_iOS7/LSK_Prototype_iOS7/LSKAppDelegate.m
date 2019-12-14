//
//  LSKAppDelegate.m
//  LSK_Prototype_iOS7
//
//  Created by Mike Cumberworth on 1/25/14.
//  Copyright (c) 2014 Mike Cumberworth. All rights reserved.
//

#import "LSKAppDelegate.h"
#import "LSKModules.h"
#import "LSKPhrase.h"

@interface LSKAppDelegate ()


@property (nonatomic, strong) NSMutableArray *currentChapterList;
@property (nonatomic, strong) NSString *currentModuleName;
@property (nonatomic, strong) NSString *currentModulePath;
@property (nonatomic, strong) NSDictionary *currentModule;

@property (nonatomic, strong) AVAudioSession *audioSession;

@end

@implementation LSKAppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    
    
    //Set Language ID here, since it isn't anywhere IN the XML...
    self.langID = @"ja";

    //Init creation of object containing all the modules available, and get array of modules.
    self.moduleList = [LSKModules getModules]; //NSArray of all available modules
    currentModuleIndexPath = 0;
    
    //Set the current module at app launch - this will be adjusted for other app states after choosing other modules
    [self setCurrentModuleIndex:0];
    
    [self colorNavBar];
    
    
    [self createAudioSession];
    
    self.bgImages = [self createArrayofBackgrounds];
    
    return YES;
}

- (void)colorNavBar
{
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:90.0/255.0f green:0.0f blue:205.0/255.0f alpha:1.0f]];
    
 
}

//Note this approach is only necessary because of the existing messy XML format that fails to include basic info in a single file
-(void) setCurrentModuleIndex:(int)index{
    currentModuleIndexPath = index;
    self.currentModule = self.moduleList[index];
    self.currentModuleID = [self.currentModule objectForKey:@"audio_id"]; //2-letter module code for audio
    self.currentModuleAudioPath = [NSString stringWithFormat:@"%@_%@_",self.langID, self.currentModuleID]; //4-letter code for audio files
}

- (NSArray *)createArrayofBackgrounds
{
    return @[[UIImage imageNamed:@"fushimiinari_torii_ruthHartnup_blurred.jpg"],
             [UIImage imageNamed:@"kiyomizu_steps_djjewell_blurred.jpg"],
             [UIImage imageNamed:@"kumamoto_jo_tanakaJuuyoh_blurred.jpg"],
             [UIImage imageNamed:@"ryoanji_rock_garden_guilhemVellut_blurred.jpg"],
             [UIImage imageNamed:@"sakura_bg_zaimoku_woodpile_blurred.jpg"],
             [UIImage imageNamed:@"shibuya_night_guwashi999_blurred.jpg"]];
}

- (NSDictionary *)getCurrentModule{
    return self.currentModule;
}

- (void)createAudioSession
{
    NSError *avSessionError;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&avSessionError];
    
    [audioSession setActive:YES error:&avSessionError];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
