//
//  LSKPhraseTableViewController.m
//  LSK_Prototype_iOS7
//
//  Created by Mike Cumberworth on 1/25/14.
//  Copyright (c) 2014 Mike Cumberworth. All rights reserved.
//

#import "LSKAppDelegate.h"
#import "LSKPhraseTableViewController.h"
#import "LSKCategoryViewController.h"
#import "LSKDetailViewController.h"
#import "LSKItemCustomCell.h"
#import "LSKPhrase.h"

@interface LSKPhraseTableViewController () <AVAudioPlayerDelegate>
{
    int catID;
}

@property (nonatomic, strong) LSKAppDelegate *appDelegate;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSString *audioPath;

@property (nonatomic, strong) NSArray *phraseObjArray;
- (IBAction)playTLPhraseAudio:(id)sender;
@property (nonatomic, strong) LSKPhrase *playingPhrase;

@property (nonatomic, strong) UIImage *playImg;
@property (nonatomic, strong) UIImage *pauseImg;

@property (nonatomic, weak) LSKItemCustomCell *prototypeCell;

@end

@implementation LSKPhraseTableViewController

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
    self.audioPath = self.appDelegate.currentModuleAudioPath;
    self.playingPhrase = nil;
    self.playImg = [UIImage imageNamed:@"PlayAudioButton"];
    self.pauseImg = [UIImage imageNamed:@"PauseAudioButton"];
    
      //NSLog(@"There are %lu phrases in this category, which are: \n%@",[self.phraseList count], self.phraseList);
    
    [self changeTableViewAppearance];
   
    NSMutableArray *phraseObjTempArray = [NSMutableArray arrayWithCapacity:[self.phraseList count]];

    //creating phrase objects here
    [self.phraseList enumerateObjectsUsingBlock:^(id phrase, NSUInteger index, BOOL *stop){
        
        LSKPhrase *phraseObj = [[LSKPhrase alloc] initWithDictionary:phrase];
        if (phraseObj !=nil)
        {
            [phraseObjTempArray addObject:phraseObj];
        
        }
        self.phraseObjArray = [phraseObjTempArray copy];
        
        //NSLog(@"%@", phraseObj.englishPhrase);
    }];
    
        
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


- (LSKItemCustomCell *)prototypeCell
{
    if (!_prototypeCell)
    {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"phraseCell"];
        
    }

    return _prototypeCell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.phraseList = nil;
    self.playingPhrase = nil;
    self.playImg = nil;
    self.pauseImg = nil;
    self.audioPlayer = nil;
   
}


#pragma mark  - IBActions

- (IBAction)playTLPhraseAudio:(id)sender {
   
    
    long tag = [(UIButton *)sender tag]; //tapped audio button used for tag to identify phrase row
    
    LSKPhrase *tappedPhrase = self.phraseObjArray[tag]; //Corresponding LSKPhrase from array
    
    NSLog(@"Phrase Table Row %ld Audio Button was tapped", tag + 1);
    
    //Does an audio player already exist?
    if (self.audioPlayer !=nil)
    {
       
                //If the current phrase was tapped again, either pause or resume it
                if ([tappedPhrase isEqual:self.playingPhrase])
                {
                    if ([self.audioPlayer isPlaying]){
                        //pause
                        [self.audioPlayer pause];
                        [self.playingPhrase setPlaying:NO];
                        [self togglePlaying];
                        
                    }
                    else
                    {   //resume playing
                        [self.playingPhrase setPlaying:YES];
                        [self togglePlaying];
                        [self.audioPlayer play];
                    }

                }
        
                else //if a different phrase was tapped,
                {
                    //stop previous phrase,
                    [self.audioPlayer stop];
                    self.audioPlayer = nil;
                    [self.playingPhrase setPlaying:NO];
                    

                    //toggle play buttons for previous phrase
                    [self togglePlaying];
                    
                    //create new player
                    self.audioPlayer = [self createAudioPlayerWithPhrase:tappedPhrase];
                    [self.audioPlayer setDelegate:self];
                    
                    //if the player was created properly, play new phrase
                    if (self.audioPlayer !=nil)
                    {
                        [tappedPhrase setPlaying:YES];
                        self.playingPhrase = tappedPhrase;
                        [self togglePlaying];
                        [self.audioPlayer prepareToPlay];
                        [self.audioPlayer play];
                        
                    }
                    
                }//end if different phrase tapped
        
    }//end if player already exists
    
    else //if a player doesn't exist
    {
        self.audioPlayer = [self createAudioPlayerWithPhrase:tappedPhrase];
        [self.audioPlayer setDelegate:self];
        
        //if the player was created properly, play new phrase
        if (self.audioPlayer !=nil)
        {
            [tappedPhrase setPlaying:YES];
            self.playingPhrase = tappedPhrase;
            [self togglePlaying];
            [self.audioPlayer prepareToPlay];
            [self.audioPlayer play];
            
        }

    }
    
}//end playTLPhraseAudio



-(void)togglePlaying
{
    
   
    int playedIndex = (int)[self.phraseObjArray indexOfObject:self.playingPhrase];
    NSIndexPath *playedPath = [NSIndexPath indexPathForItem:playedIndex inSection:0];
    LSKItemCustomCell *playedCell = (LSKItemCustomCell*)[self.tableView cellForRowAtIndexPath:playedPath];
    
    if ([self.playingPhrase isPlaying])
        {
           
            [playedCell.phraseAudioButton setImage:self.pauseImg forState:UIControlStateNormal];
        }
    
        else
        {
            
            [playedCell.phraseAudioButton setImage:self.playImg forState:UIControlStateNormal];
            
        }
}

- (AVAudioPlayer *)createAudioPlayerWithPhrase:(LSKPhrase *)tappedPhrase
{
    NSString *audioName = [NSString stringWithFormat:@"%@%@",self.audioPath, tappedPhrase.audioName];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:audioName ofType:@"mp3"];
    NSURL *audioURL = [NSURL fileURLWithPath:filePath];
    NSError *error = nil;
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&error];
    
    if (audioPlayer !=nil)
    {
        return audioPlayer;
    }
    
    else
    {
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to Load Audio" message:@"Sorry, this audio file failed to load. Please contact us to fix the issue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    return nil;
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.playingPhrase setPlaying:NO];
    int playedIndex = (int)[self.phraseObjArray indexOfObject:self.playingPhrase];
    NSIndexPath *playedPath = [NSIndexPath indexPathForItem:playedIndex inSection:0];
    LSKItemCustomCell *playedCell = (LSKItemCustomCell*)[self.tableView cellForRowAtIndexPath:playedPath];
    [playedCell.phraseAudioButton setImage:self.playImg forState:UIControlStateNormal];
    self.audioPlayer = nil;
    self.playingPhrase = nil;
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.phraseObjArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    
    self.prototypeCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
    
    [self.prototypeCell layoutIfNeeded];
    
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];

    NSLog(@"%f", size.height);
    return size.height+1;

}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (LSKItemCustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"phraseCell";
    LSKItemCustomCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void) configureCell:(LSKItemCustomCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    LSKPhrase *cellPhrase = self.phraseObjArray[indexPath.row];
    // Configure the cell...
    
    if (!cell){
        
        [cell.phraseAudioButton addTarget:self action:@selector(playTLPhraseAudio:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    cell.phraseNumber.text = [NSString stringWithFormat:@"%@",cellPhrase.phraseOrder];
    cell.phraseTextEnglish.text = cellPhrase.englishPhrase;
    cell.phraseTextEnglish.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cell.phraseAudioButton.tag = indexPath.row;
    [cell.phraseAudioButton setImage:self.playImg forState:UIControlStateNormal];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"Phrase Table Row %ld (not the button) was tapped", (long)indexPath.row + 1);
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.textLabel.textColor = [UIColor whiteColor];
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (self.audioPlayer !=nil)
    {
        [self.playingPhrase setPlaying:NO];
        [self togglePlaying];
        [self.audioPlayer stop];
        self.audioPlayer = nil;
        
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    LSKDetailViewController *detailVC = (LSKDetailViewController *)[segue destinationViewController];
    if ([detailVC respondsToSelector:@selector(setDetailItem:)])
    {
        LSKPhrase *selectedPhrase = self.phraseObjArray[[self.tableView indexPathForCell:sender].row];
        [detailVC setDetailItem:selectedPhrase];
    }
    if ([detailVC respondsToSelector:@selector(setPhrases:)])
    {
        [detailVC setPhrases:self.phraseObjArray];
    }
    

}



@end
