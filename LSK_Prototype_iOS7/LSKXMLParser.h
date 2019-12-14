//
//  LSKXMLParser.h
//  LSK_Prototype_iOS7
//
//  Created by Mike Cumberworth on 2/23/14.
//  Copyright (c) 2014 Mike Cumberworth. All rights reserved.
//



@interface LSKXMLParser : NSObject

-(NSArray *)parseCategoryXML:(NSString*)folderName;

-(NSArray *)parseLangKitXMLforModule:(NSString *)moduleName;

@end
