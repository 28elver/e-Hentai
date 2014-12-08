//
//  HentaiFilterView.h
//  e-Hentai
//
//  Created by OptimusKe on 2014/9/28.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HentaiFilterView;
@protocol HentaiFilterViewDelegate
-(void)zHentaiFilterReturnString:(NSString*)zStrString;
@end
@interface HentaiFilterView : UIView
<UITableViewDataSource
,UITableViewDelegate
>

- (void)selectAll;
- (NSArray *)filterResult;
- (void)zMethSetHistoryTableViewDataSource:(NSDictionary*)zDictHistoryTableViewSource;
- (void)zMethSetBokMarkTableViewDataSource:(NSDictionary*)zDictBokMarkTableViewSource;
- (void)setScrollView;
- (void)setTableView;
- (void)zMethReloadTableVie;
@property (nonatomic, retain) id <HentaiFilterViewDelegate> delegate;
@end
