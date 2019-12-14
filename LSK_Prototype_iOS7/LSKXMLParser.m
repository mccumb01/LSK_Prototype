//
//  LSKXMLParser.m
//  LSK_Prototype_iOS7
//
//  Created by Mike Cumberworth on 2/23/14.
//  Copyright (c) 2014 Mike Cumberworth. All rights reserved.
//

#import "LSKXMLParser.h"

@interface LSKXMLParser () <NSXMLParserDelegate>

{
    int categoryID;
}

@property (nonatomic, strong) NSMutableArray *categoriesFromXML;
@property (nonatomic, strong) NSMutableString *categoryTitleString;


@property (nonatomic, strong) NSString *moduleToParse;
@property (nonatomic, strong) NSURL *URLtoParse;

@property (nonatomic, strong) NSString *currentElement;
@property (nonatomic, strong) NSMutableDictionary *tempPhraseDict;
@property (nonatomic, strong) NSMutableString *tempString;
@property (nonatomic, strong) NSMutableArray *tempPhraseArray;

@end

@implementation LSKXMLParser


-(NSArray *)parseCategoryXML:(NSString*)folderName{
    
    self.categoriesFromXML = [[NSMutableArray alloc] init];
    self.moduleToParse = folderName;
    self.URLtoParse = [[NSBundle mainBundle] URLForResource:@"dbo_catID" withExtension:@"xml" subdirectory:folderName];
    
    
    NSData *moduleXML = [[NSData alloc] initWithContentsOfURL:self.URLtoParse];
   
    NSLog(@"The raw XML NSData object is: %@", moduleXML);
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:moduleXML];
    if (parser !=nil)
    {
        [parser setDelegate:self];
        [parser parse];
    }
    
    
    NSArray *categoryList = [[NSArray alloc] initWithArray:self.categoriesFromXML];

    return categoryList;
    
}

-(NSArray *)parseLangKitXMLforModule:(NSString *)moduleName
{
    //NSDictionary *tempDict = @{@"phraseID":@505, @"catID":@2, @"phraseOrder":@20, @"englishPhrase":@"We are bound for __.", @"romanized":@"waarey waarey waa ___ nee mookaatey maasu", @"unicode":@"我々は ___ に向かっています。"};
    
    //Will add items to this
    //NSMutableArray *mutablePhraseList = [[NSMutableArray alloc] initWithObjects:tempDict, nil];
   
    
   self.URLtoParse = [[NSBundle mainBundle] URLForResource:@"dbo_langKit" withExtension:@"xml" subdirectory:moduleName];
    NSData *moduleXML = [[NSData alloc] initWithContentsOfURL:self.URLtoParse];

    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:moduleXML];
    if (parser !=nil)
    {
        [parser setDelegate:self];
        [parser parse];
    }
    
    //Return this once complete - not sure how yet.
    NSArray *phraseList = [[NSArray alloc] initWithArray:self.tempPhraseArray];
    return phraseList;
}


// sent when the parser begins parsing of the document.
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    
    NSLog(@"Started parsing %@ XML", self.moduleToParse);
    self.tempPhraseArray = [[NSMutableArray alloc] init];
    
}

// sent when the parser has completed parsing. If this is encountered, the parse was successful.
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"Finished parsing %@ XML", self.moduleToParse);
    
}

// sent when the parser finds an element start tag.

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement = elementName;
    self.tempString = [[NSMutableString alloc] init];
    

    if ([elementName isEqualToString:@"categoryDesc"])
    {
       
    }
    else if ([elementName isEqualToString:@"dbo_langKit"])
    {
        
        self.tempPhraseDict = [[NSMutableDictionary alloc]init];
        
    }
    
    else if ([elementName isEqualToString:@"phraseID"])
    {
        [self.tempPhraseDict setValue:@"" forKey:@"phraseID"];
    }
        
    else if ([elementName isEqualToString:@"catID"]){
        [self.tempPhraseDict setValue:@"" forKey:@"catID"];
    }
    
    else if ([elementName isEqualToString:@"phraseOrder"]){
        [self.tempPhraseDict setValue:@"" forKey:@"phraseOrder"];
    }
    
    else if ([elementName isEqualToString:@"englishPhrase"]){
        [self.tempPhraseDict setValue:@"" forKey:@"englishPhrase"];
    }
   
    else if ([elementName isEqualToString:@"romanized"]){
        [self.tempPhraseDict setValue:@"" forKey:@"romanized"];
    }
    
    else if ([elementName isEqualToString:@"unicode"]){
        [self.tempPhraseDict setValue:@"" forKey:@"unicode"];
    }
    
    
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{

    [self.tempString appendString:string];
    
}


// sent when an end tag is encountered. The various parameters are supplied as above.
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"categoryDesc"])
    {
        [self.categoriesFromXML addObject:self.tempString];
        
    }
    
    else if ([elementName isEqualToString:@"phraseID"])
    {
        [self.tempPhraseDict setObject:self.tempString forKey:@"phraseID"];
    }
    
    else if ([elementName isEqualToString:@"catID"]){
        [self.tempPhraseDict setObject:self.tempString forKey:@"catID"];
    }
    
    else if ([elementName isEqualToString:@"phraseOrder"]){
        [self.tempPhraseDict setObject:self.tempString forKey:@"phraseOrder"];
    }
    
    else if ([elementName isEqualToString:@"englishPhrase"]){
        [self.tempPhraseDict setObject:self.tempString forKey:@"englishPhrase"];
    }
    
    else if ([elementName isEqualToString:@"romanized"]){
        [self.tempPhraseDict setObject:self.tempString forKey:@"romanized"];
    }
    
    else if ([elementName isEqualToString:@"unicode"]){
        [self.tempPhraseDict setObject:self.tempString forKey:@"unicode"];
    }
    
    else if ([elementName isEqualToString:@"dbo_langKit"])
    
    {
        [self.tempPhraseArray addObject:self.tempPhraseDict];
        self.tempPhraseDict = nil;
    }
    self.tempString = nil;
}


@end
