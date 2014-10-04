//
//  zNsMeth.m
//  e-Hentai
//
//  Created by elver2 on 2014/9/28.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "zNsMeth.h"

@implementation zNsMeth

+ (NSString *)zMethReturnHentaiKey:(NSString *)zStrParmer ForTitle:(NSString *)zStrTitle ForHttpUrl:(NSString *)zStrUrl {
	NSArray *splitStrings = [zStrUrl componentsSeparatedByString:@"/"];
	NSUInteger splitCount = [splitStrings count];
	NSString *checkHentaiKey = [NSString stringWithFormat:@"%@-%@-%@", splitStrings[splitCount - 3], splitStrings[splitCount - 2], zStrTitle];
	return [checkHentaiKey stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
}

+(NSString*)zMethReturnTrueFileNameOnAddLastPathComponent:(NSString*)zStr{
	NSArray *zArry=[zStr componentsSeparatedByString:@"/"];
//	NSLog(@"[%d],zArry=[%@]",zArry.count,zArry);
	return [NSString stringWithFormat:@"%@%@",[zArry objectAtIndex:zArry.count-2],[zArry objectAtIndex:zArry.count-1]];
}
@end
