//
//  LSKMasterViewController.m
//  LSK_Prototype_iOS7
//
//  Created by Mike Cumberworth on 1/25/14.
//  Copyright (c) 2014 Mike Cumberworth. All rights reserved.
//

#import "LSKAppDelegate.h"
#import "LSKModules.h"
#include "LSKXMLParser.h"
#import "LSKCategoryViewController.h"
#import "LSKDetailViewController.h"
#import "LSKPhraseTableViewController.h"
#import "LSKModuleMenuTableViewController.h"


@interface LSKCategoryViewController ()

@property (nonatomic, strong) LSKAppDelegate *appDelegate;
@property (nonatomic, strong) NSArray *moduleCategoryList;
@property (nonatomic, strong) NSArray *modulePhraseArray;
@property (nonatomic, strong) NSArray *selectedCategoryPhrases;
@property (nonatomic, strong) NSDictionary *selectedModule;
@property (nonatomic, strong) NSString *selectedModulePath;
@property (nonatomic, assign, getter=isMenuOpen)   BOOL menuOpen;
@property (nonatomic, strong) LSKXMLParser *parser;

- (IBAction)toggleModuleMenu:(id)sender;

- (void)loadModuleXML;

@end

@implementation LSKCategoryViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.selectedModule = [self.appDelegate getCurrentModule];
    self.selectedModulePath = [self.selectedModule objectForKey:@"path"];
    self.navigationItem.title = [self.selectedModule objectForKey:@"name"];
    
    self.parser = [[LSKXMLParser alloc] init];
   
    self.selectedCategoryPhrases = [[NSArray alloc] init];
    
    [self changeTableViewAppearance];
    
    [self loadModuleXML];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self changeBackgroundImage];
}

- (void)changeBackgroundImage
{
    NSArray *bgOptions = self.appDelegate.bgImages;
    int random = arc4random_uniform((int)bgOptions.count);
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:(UIImage *)bgOptions[random]];
    [bgImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.tableView setBackgroundView:bgImageView];
}

- (void)changeTableViewAppearance
{
    [self changeBackgroundImage];

    [self.tableView setSeparatorColor:[UIColor colorWithRed:90.0/255.0f green:0.0f blue:205.0/255.0f alpha:1.0f]];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.selectedCategoryPhrases = nil;
    self.parser = nil;
    
}


- (IBAction)toggleModuleMenu:(id)sender{
    
    //once I implement left-column "drawer" view for modal menu, will check here to shift view position, and check if it's currently open/closed.
}

- (void)loadModuleXML {

    //Load module categories from LSKCategoryList object
    
    LSKXMLParser *parser = [[LSKXMLParser alloc] init];
    self.moduleCategoryList = [parser parseCategoryXML:_selectedModulePath];
    self.modulePhraseArray = [parser parseLangKitXMLforModule:_selectedModulePath];
   
    //NSLog(@"Category List for the Category View Controller is: %@", self.moduleCategoryList);

    
    //NSLog(@"Will load categories from Module: %@", self.selectedModule[@"name"]);
    
    //NSLog(@"Entire module phrase list is: %@", self.modulePhraseArray);
    
    
    [self.tableView reloadData];

}

- (void) filterXMLByCategoryAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rowString = [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
    NSPredicate *categoryFilter = [NSPredicate predicateWithFormat: @"catID = %@", rowString];
    self.selectedCategoryPhrases = [self.modulePhraseArray filteredArrayUsingPredicate:categoryFilter];
    //NSLog(@"%@", self.selectedCategoryPhrases);
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _moduleCategoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = [self.moduleCategoryList objectAtIndex:indexPath.row];
    cell.tag = indexPath.row;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = [UIColor colorWithRed:70.0/255.0f green:0.0f blue:190.0/255.0f alpha:0.5f];
    cell.selectedBackgroundView = selectedView;
    return cell;
    
   
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self filterXMLByCategoryAtIndexPath:indexPath];
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
      
        /* Figure out iPad detailView issues later
        NSDictionary *categoryPhrases = _categoryList[indexPath.row];
        self.phraseTableViewController.phraseList = categoryPhrases;
         */
    }
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.textLabel.textColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.textLabel.textColor = [UIColor blackColor];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"toggleMenu"])
    {

        __weak LSKModuleMenuTableViewController *menuController = segue.destinationViewController;
        
        menuController.menuSelected = ^(BOOL success, NSDictionary *selectedModule){
            
            if (success)
            {
                NSLog(@"Menu Row %@ selected", selectedModule[@"name"]);
                
                self.selectedModule = [self.appDelegate getCurrentModule];
                self.selectedModulePath = [self.selectedModule objectForKey:@"path"];
                self.navigationItem.title = [self.selectedModule objectForKey:@"name"];

                [self loadModuleXML]; //- RELOAD categories & table contents after selecting new Module takes place in viewWillAppear
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else {
            
                NSString *errorMsg = @"There was an error loading this module";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Loading" message:errorMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
       
        
        };
        
       
        
    }
    
    else if ([[segue identifier] isEqualToString:@"showPhrases"]) {
        
        LSKPhraseTableViewController *targetVC =  (LSKPhraseTableViewController *)[segue destinationViewController];

        UIButton *senderCell = (UIButton *)sender;
        
        NSIndexPath *selectedCategoryIndexPath = [NSIndexPath indexPathForRow:senderCell.tag inSection:0];
        NSString *categoryIDString = [NSString stringWithFormat:@"%ld", selectedCategoryIndexPath.row+1];
        
        if ([targetVC respondsToSelector:@selector(setPhraseList:)])
        {
            [targetVC setPhraseList:self.selectedCategoryPhrases];
            NSLog(@"%@", targetVC.phraseList);

        }
        if ([targetVC respondsToSelector:@selector(setCategoryID:)])
        {
            [targetVC setCategoryID: categoryIDString];
            NSLog(@"%@", targetVC.phraseList);
            
        }
        
    
    }
}

@end
