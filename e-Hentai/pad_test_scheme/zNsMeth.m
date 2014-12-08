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


+(NSDictionary*)zMethReturnDate:(NSDictionary*)zMuDictSendDate doWhateParam:(NSString*)zStrParam
{
	// 创建目录
    if (![[NSFileManager defaultManager] fileExistsAtPath: [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"plist"]])  {
		NSLog(@"No Found Plist Make");
        [[NSFileManager defaultManager] createDirectoryAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"plist"] withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
		NSLog(@"Have Found Plist");
	}
	
	NSMutableDictionary *zMuDictReturnData=[NSMutableDictionary dictionary];
	if([zStrParam isEqualToString:@"CheckAppUpGradeList"]) {


		///讀出使用者設定
	}else if([zStrParam isEqualToString:@"UserConfigure.plist"]
			 ///讀出書籤
			||[zStrParam isEqualToString:@"BookMark.plist"]
			 ///讀出歷史
			 ||[zStrParam isEqualToString:@"History.plist"]
			 ) {
		zMuDictReturnData=[[NSMutableDictionary alloc]initWithDictionary:[self zMethCheckPlist:zStrParam] copyItems:YES];
		
		///儲存使用者設定
    }else if([zStrParam isEqualToString:@"SaveBookMark.plist"]) {
		[zMuDictSendDate writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"plist/UserConfigure.plist"] atomically:YES];
		
		///儲存書籤
    }else if([zStrParam isEqualToString:@"SaveBookMark.plist"]) {
		[zMuDictSendDate writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"plist/BookMark.plist"] atomically:YES];
		
		///儲存歷史
    }else if([zStrParam isEqualToString:@"SaveHistory.plist"]) {
		[zMuDictSendDate writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"plist/History.plist"] atomically:YES];
	}
	return zMuDictReturnData;
	
}

+(NSDictionary*)zMethCheckPlist:(NSString*)zStrFileName{

	NSString *zStrUserOptionSetPath=
	[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"plist/%@",zStrFileName]];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSMutableDictionary *zDictUserOptionSet;
	if([fileManager fileExistsAtPath:zStrUserOptionSetPath])
	{
		zDictUserOptionSet= [[[NSMutableDictionary alloc]initWithContentsOfFile:zStrUserOptionSetPath]mutableCopy];
	}
	return zDictUserOptionSet;
}



@end
