//
//  LSKDetailViewController.m
//  LSK_Prototype_iOS7
//
//  Created by Mike Cumberworth on 1/25/14.
//  Copyright (c) 2014 Mike Cumberworth. All rights reserved.
//

#import "LSKAppDelegate.h"
#import "LSKDetailViewController.h"
#import "LSKPhrase.h"

@interface LSKDetailViewController () <AVAudioPlayerDelegate, UIGestureRecognizerDelegate>
{
    BOOL translitShowing;
    int currentPhrasenum;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;

//App Delegate
@property (nonatomic, strong) LSKAppDelegate *appDelegate;
@property (nonatomic, strong) NSString *currentModuleID;

//Detail View Properties for Current Phrase
@property (weak, nonatomic) IBOutlet UILabel *targetLanguageName;
@property (weak, nonatomic) NSString *tlText;
@property (weak, nonatomic) NSString *translitText;
@property (weak, nonatomic) NSString *enText;
@property (weak, nonatomic) LSKPhrase *currentPhrase;
@property (weak, nonatomic) NSArray *allPhrases;

//Properties for Audio playback
@property (nonatomic, strong) AVAudioPlayer *tlPlayer;
@property (nonatomic, strong) AVAudioPlayer *enPlayer;
@property (weak, nonatomic) NSURL *enAudio;
@property (weak, nonatomic) NSURL *tlAudio;

//Detail View Text Area IBOutlets
@property (weak, nonatomic) IBOutlet UITextView *phraseTLTextArea;
@property (weak, nonatomic) IBOutlet UITextView *phraseEnglishTextArea;
@property (weak, nonatomic) IBOutlet UIButton *translitButton;
@property (weak, nonatomic) IBOutlet UIButton *tlPlayButton;
@property (weak, nonatomic) IBOutlet UIButton *enPlayButton;

//Gesture recognizers
@property (nonatomic, strong) UISwipeGestureRecognizer *upRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *downRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *prevViewSwiper;

//Detail View IBActions
- (IBAction)toggleTranslit:(id)sender;
- (IBAction)playTLAudio:(id)sender;
- (IBAction)playEnglishAudio:(id)sender;
- (IBAction)prevPhrase:(id)sender;
- (IBAction)nextPhrase:(id)sender;
- (IBAction)prevView:(id)sender;

@end

@implementation LSKDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    self.navigationItem.title = [NSString stringWithFormat:@"%@/%ld",self.currentPhrase.phraseOrder,(long)[self.allPhrases count]];
    self.tlText = self.currentPhrase.unicodePhrase;
    self.enText = self.currentPhrase.englishPhrase;
    self.translitText = self.currentPhrase.romanizedPhrase;
    self.phraseTLTextArea.text = _tlText;
    self.phraseEnglishTextArea.text = _enText;
    translitShowing = NO;
    [self.tlPlayButton setImage:[UIImage imageNamed:@"PlayAudioButton"] forState:UIControlStateNormal];
    [self.enPlayButton setImage:[UIImage imageNamed:@"PlayAudioButton"] forState:UIControlStateNormal];
    
    //This seems to get reset every time there's a new phrase. The correct audio plays, but "didFinishPlaying" no longer gets called
    if (self.tlPlayer !=nil)
    {
        [self.tlPlayer setDelegate:self];
    }
    if (self.enPlayer !=nil)
    {
        [self.enPlayer setDelegate:self];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.currentModuleID = self.appDelegate.currentModuleID;
    
    if ([self.phrases isKindOfClass:[NSArray class]])
    {
        self.allPhrases = (NSArray *)self.phrases;
        self.phrases = nil;
    }
    
    if ([self.detailItem isKindOfClass:[LSKPhrase class]])
    {
        self.currentPhrase = (LSKPhrase *)self.detailItem;
        currentPhrasenum = [self.currentPhrase.phraseOrder intValue] -1;
        self.detailItem = nil;
        
        self.tlPlayer = [self createAudioPlayerForLanguage:@"ja"];
        

        self.enPlayer = [self createAudioPlayerForLanguage:@"en"];
        
    }
    else {
        
         [self errorLoadingPhrase];
    
    }

    
    UIBarButtonItem *downBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UIBarButtonArrowDown.png"] landscapeImagePhone:[UIImage imageNamed:@"UIBarButtonArrowDown.png"] style:UIBarButtonItemStylePlain target:self action:@selector(nextPhrase:)];
    
    UIBarButtonItem *upBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UIBarButtonArrowUp.png"] landscapeImagePhone:[UIImage imageNamed:@"UIBarButtonArrowUp.png"] style:UIBarButtonItemStylePlain target:self action:@selector(prevPhrase:)];
    
    [self.navigationItem setRightBarButtonItems:@[downBtn, upBtn]];
    
    //Up swipe to go to previous phrase
    self.upRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(prevPhrase:)];
    [self.upRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.upRecognizer setDelegate:self];
    [self.view  addGestureRecognizer:_upRecognizer];

    //Down swipe to go to next phrase
    self.downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextPhrase:)];
    [self.downRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.downRecognizer setDelegate:self];
    [self.view addGestureRecognizer:_downRecognizer];

    //Left swipe to go back to previous view
    self.prevViewSwiper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(prevView:)];
    [self.prevViewSwiper setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.prevViewSwiper setDelegate:self];
    [self.view addGestureRecognizer:_prevViewSwiper];

    
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void) errorLoadingPhrase
{
    self.tlText = @"Error Loading Phrase";
    self.enText = @"Error Loading Phrase";
    self.translitText = @"Error Loading Phrase";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Loading Phrase" message:@"The phrase failed to load properly" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    self.currentPhrase = nil;
    
}


- (IBAction)playTLAudio:(id)sender
{

    //Does an audio player already exist?
    if (self.tlPlayer !=nil)
    {
        
        if ([self.tlPlayer isPlaying]){
            //pause
            [self.tlPlayButton setImage:[UIImage imageNamed:@"PlayAudioButton"] forState:UIControlStateNormal];
            [self.tlPlayer pause];
        }
        
        else
            //Handle if enPlayer was playing
        {   [self.enPlayer stop]; //in case it was playing
            [self.enPlayButton setImage:[UIImage imageNamed:@"PlayAudioButton"] forState:UIControlStateNormal];
            
            //update & play tlPlayer
            [self.tlPlayButton setImage:[UIImage imageNamed:@"PauseAudioButton"] forState:UIControlStateNormal];
            [self.tlPlayer play];
            
        }
            
    }
    

    
}

- (IBAction)playEnglishAudio:(id)sender
{

    
    //Does an audio player already exist?
    if (self.enPlayer !=nil)
    {
        
        if ([self.enPlayer isPlaying]){
            //pause
            [self.enPlayButton setImage:[UIImage imageNamed:@"PlayAudioButton"] forState:UIControlStateNormal];
            [self.enPlayer pause];
            
        }
        else
        {
            //Handle if enPlayer was playing
            [self.tlPlayer stop];//in case it is playing
            [self.tlPlayButton setImage:[UIImage imageNamed:@"PlayAudioButton"] forState:UIControlStateNormal];
            
            //update & play tlPlayer
            [self.enPlayButton setImage:[UIImage imageNamed:@"PauseAudioButton"] forState:UIControlStateNormal];
            [self.enPlayer play];
        }
        
    }
    
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if ([player isEqual:self.enPlayer])
    {
        [self.enPlayButton setImage:[UIImage imageNamed:@"PlayAudioButton"] forState:UIControlStateNormal];
        
    }
    else if ([player isEqual:self.tlPlayer])
    {
        [self.tlPlayButton setImage:[UIImage imageNamed:@"PlayAudioButton"] forState:UIControlStateNormal];
        
    }
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    //Hit on switching between landscape/portrait?
}
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    
}

- (AVAudioPlayer *)createAudioPlayerForLanguage:(NSString *)lang
{
    
    
    NSString *audioName = [NSString stringWithFormat:@"%@_%@_%02d_%02d",lang, self.currentModuleID, [self.currentPhrase.categoryID intValue], [self.currentPhrase.phraseOrder intValue]];
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




- (IBAction)prevPhrase:(id)sender {
    
    if(currentPhrasenum > 0){
        currentPhrasenum --;
        self.currentPhrase = (LSKPhrase *)self.allPhrases[currentPhrasenum];
        self.tlPlayer = [self createAudioPlayerForLanguage:@"ja"];
        self.enPlayer = [self createAudioPlayerForLanguage:@"en"];
        [self configureView];
        
    }

    NSLog(@"Previous Phrase button tapped");
}

- (IBAction)nextPhrase:(id)sender {
    if (currentPhrasenum < [self.allPhrases count]-1)
    {
        currentPhrasenum ++;
        self.currentPhrase = (LSKPhrase *)self.allPhrases[currentPhrasenum];
        self.tlPlayer = [self createAudioPlayerForLanguage:@"ja"];
        self.enPlayer = [self createAudioPlayerForLanguage:@"en"];
        [self configureView];
    }

    NSLog(@"Next Phrase button tapped");
}

- (IBAction)prevView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)toggleTranslit:(id)sender {
    
    if (translitShowing !=YES)
    {
        translitShowing = YES;
        self.phraseTLTextArea.text = self.translitText;
        [self.translitButton setTitle:@"Target Language" forState:UIControlStateNormal];
        
    }
    else{
        translitShowing = NO;
        self.phraseTLTextArea.text = self.tlText;
        [self.translitButton setTitle:@"Transliteration" forState:UIControlStateNormal];
        
    }

    
    
}
@end
