//
//  LSKModuleMenuTableViewController.m
//  LSK_Prototype_iOS7
//
//  Created by Mike Cumberworth on 1/26/14.
//  Copyright (c) 2014 Mike Cumberworth. All rights reserved.
//

#import "LSKAppDelegate.h"
#import "LSKModuleMenuTableViewController.h"
#import "LSKModuleMenuTableCell.h"
#import "LSKModules.h"

@interface LSKModuleMenuTableViewController ()

@property (nonatomic, strong) NSArray *moduleList;
@property (nonatomic, strong) LSKAppDelegate *appDelegate;

@end

@implementation LSKModuleMenuTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];

    self.moduleList = self.appDelegate.moduleList;
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    
    [self.tableView setSeparatorColor:[UIColor colorWithRed:90.0/255.0f green:0.0/255.0f blue:205.0/255.0 alpha:1.0]];
 
}



//Hide status bar which currently obstructs part of the 1st tableview cell. Easier than messing w/tableview
- (BOOL) prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    NSString *menuHeader = @"Select Module";
    
    return menuHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"menuCell";
    LSKModuleMenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.targetLanguageName.text = @"Japanese";
    cell.moduleName.text = [self.moduleList[indexPath.row] objectForKey:@"name"];
    [cell.moduleMenuIcon setImage:[UIImage imageNamed:[self.moduleList[indexPath.row] objectForKey:@"image"]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.menuSelected != nil)
    {
        [self.appDelegate setCurrentModuleIndex:(int)indexPath.row];
        NSDictionary *selectedModule = [self.appDelegate getCurrentModule];
        self.menuSelected(YES, selectedModule);
        
    }
    
    
}



#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
