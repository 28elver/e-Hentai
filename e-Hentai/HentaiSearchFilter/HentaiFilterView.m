//
//  HentaiFilterView.m
//  e-Hentai
//
//  Created by OptimusKe on 2014/9/28.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "HentaiFilterView.h"
#import "HentaiSearchFilter.h"
#import "UIColor+HentaiCategory.h"

@interface HentaiFilterView ()
{
	NSMutableArray *filterEnableArray;
	NSMutableArray *zMuArraySaveUIBtn;
	NSArray *zArrayHistory;
	NSArray *zArrayBookMark;
	UIScrollView *zScrollViewMain;
	UIView *zViewOPnBtn;
	UITableView *zTableViewHistory;
	UITableView *zTableViewBookMark;
}


@end

@implementation HentaiFilterView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code
		self.backgroundColor = [UIColor blackColor];
		[self setScrollView];
	}
	return self;
}

- (void)selectAll {
	for (int i = 0; i < filterEnableArray.count; i++) {
		[filterEnableArray replaceObjectAtIndex:i withObject:@(YES)];
	}

//	for (UIButton *btn in self.subviews) {
	for (UIButton *btn in zViewOPnBtn.subviews) {
		[self setButtonEnableStyle:btn enable:YES];
	}
}

- (NSArray *)filterResult {
	NSMutableArray *resultArray = [NSMutableArray array];

	for (int i = 0; i < filterEnableArray.count; i++) {
		NSNumber *filterNum = [filterEnableArray objectAtIndex:i];
		if ([filterNum boolValue]) {
			[resultArray addObject:@(i)];
		}
	}

	return resultArray;
}

#pragma mark - private

-(void)setScrollView{
	if (!zScrollViewMain) {
		zScrollViewMain=[[UIScrollView alloc]initWithFrame:self.bounds];
		//UIScrollView設定
		[zScrollViewMain setBackgroundColor:[UIColor clearColor]];
		[zScrollViewMain setPagingEnabled:YES];//以页为单位滑动，即自动到下一页的开始边界
		[zScrollViewMain setShowsHorizontalScrollIndicator:NO];
		[zScrollViewMain setShowsVerticalScrollIndicator:NO];//隐藏垂直和水平显示条
		[zScrollViewMain setScrollsToTop:NO];
//		[zScrollViewMain setDelegate:self];
	}
	[zScrollViewMain setContentSize:CGSizeMake(self.bounds.size.width*3, self.bounds.size.height)];
	[self addSubview:zScrollViewMain];
	[zScrollViewMain scrollRectToVisible:CGRectMake(self.bounds.size.width, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height) animated:YES];
    [zScrollViewMain setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:YES];
	[self setButtons];
	[self setTableView];
}

- (void)setTableView{
	if (!zTableViewHistory) {
		zTableViewHistory=[[UITableView alloc]initWithFrame:self.bounds];
		zTableViewHistory.backgroundColor = [UIColor colorWithRed:0.622 green:0.850 blue:0.903 alpha:1.000];
		zTableViewHistory.separatorColor = [UIColor blackColor];
		UIView *footer =[[UIView alloc] initWithFrame:CGRectZero];
		zTableViewHistory.tableFooterView = footer;
		zTableViewHistory.dataSource = self;
		zTableViewHistory.delegate = self;
		zTableViewHistory.tag=1001;
	}
	[zScrollViewMain addSubview:zTableViewHistory];
	
	if (!zTableViewBookMark) {
		zTableViewBookMark=[[UITableView alloc]initWithFrame:CGRectMake(self.bounds.size.width*2, 0, self.bounds.size.width, self.bounds.size.height)];
		zTableViewBookMark.backgroundColor = [UIColor colorWithRed:0.903 green:0.821 blue:0.504 alpha:1.000];
		zTableViewBookMark.separatorColor = [UIColor blackColor];
		UIView *footer =[[UIView alloc] initWithFrame:CGRectZero];
		zTableViewBookMark.tableFooterView = footer;
		zTableViewBookMark.dataSource = self;
		zTableViewBookMark.delegate = self;
		zTableViewBookMark.tag=1003;
	}
	[zScrollViewMain addSubview:zTableViewBookMark];
}


- (void)zMethSetHistoryTableViewDataSource:(NSDictionary*)zDictHistoryTableViewSource{
	zArrayHistory=[[zDictHistoryTableViewSource objectForKey:@"History"]copy];
}
- (void)zMethSetBokMarkTableViewDataSource:(NSDictionary*)zDictBokMarkTableViewSource{
	zArrayBookMark=[[zDictBokMarkTableViewSource objectForKey:@"BookMark"] copy];
}
- (void)zMethReloadTableVie{
	[zTableViewBookMark reloadData];
	[zTableViewHistory reloadData];
}
- (void)setButtons {
	filterEnableArray = [NSMutableArray arrayWithCapacity:10];
	if (!zViewOPnBtn) {
		zViewOPnBtn=[[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
		zViewOPnBtn.backgroundColor=[UIColor clearColor];
	}
	[zScrollViewMain addSubview:zViewOPnBtn];
	for (int i = 0; i < 10; i++) {
		CGFloat x = (i % 2 == 0) ? 0  :CGRectGetWidth(self.frame)/2;
		CGFloat y = (i / 2) * 40;

		//init all Tag YES
		NSNumber *tapTag = @(YES);
		[filterEnableArray insertObject:tapTag atIndex:i];

		UIButton *filterBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, CGRectGetWidth(self.frame) / 2, 30)];
		filterBtn.tag = i;
		filterBtn.titleLabel.textColor = [UIColor whiteColor];
		NSNumber *filterTag = @(i);
		filterBtn.backgroundColor = [self colorMapping:filterTag];
		[filterBtn setTitle:[self titleMapping:filterTag] forState:UIControlStateNormal];
		[filterBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
		[filterBtn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
		[zViewOPnBtn addSubview:filterBtn];
	}
}

-(void)zMethRetarySetBtnViewFrame:(NSDictionary*)zDictParmer{

}

- (UIColor *)colorMapping:(NSNumber *)filterTag {
	NSDictionary *mapping = @{ @(HentaiFilterTypeDoujinshi) : colorDoujinshi,
		                       @(HentaiFilterTypeManga)     : colorManga,
		                       @(HentaiFilterTypeArtistcg)  : colorArtistcg,
		                       @(HentaiFilterTypeGamecg)    : colorGamecg,
		                       @(HentaiFilterTypeWestern)   : colorWestern,
		                       @(HentaiFilterTypeNonh)      : colorNonh,
		                       @(HentaiFilterTypeImagesets) : colorImageset,
		                       @(HentaiFilterTypeCosplay)   : colorCosplay,
		                       @(HentaiFilterTypeAsianporn) : colorAsianporn,
		                       @(HentaiFilterTypeMisc)      : colorMisc };
	return mapping[filterTag] ? mapping[filterTag] : colorAll;
}

- (NSString *)titleMapping:(NSNumber *)filterTag {
	NSDictionary *mapping = @{ @(HentaiFilterTypeDoujinshi) : @"Doujinshi",
		                       @(HentaiFilterTypeManga)     : @"Manga",
		                       @(HentaiFilterTypeArtistcg)  : @"Artistcg",
		                       @(HentaiFilterTypeGamecg)    : @"Gamecg",
		                       @(HentaiFilterTypeWestern)   : @"Western",
		                       @(HentaiFilterTypeNonh)      : @"Nonh",
		                       @(HentaiFilterTypeImagesets) : @"Imageset",
		                       @(HentaiFilterTypeCosplay)   : @"Cosplay",
		                       @(HentaiFilterTypeAsianporn) : @"Asianporn",
		                       @(HentaiFilterTypeMisc)      : @"Misc" };
	return mapping[filterTag] ? mapping[filterTag] : @"All";
}

- (void)setButtonEnableStyle:(UIButton *)btn enable:(BOOL)enable {
	NSNumber *filterTag = @(btn.tag);
	if (enable) {
		btn.backgroundColor = [self colorMapping:filterTag];
		[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	else {
		btn.backgroundColor = [UIColor blackColor];
		[btn setTitleColor:[self colorMapping:filterTag] forState:UIControlStateNormal];
	}
}

- (void)buttonPress:(UIButton *)btn {
	BOOL enable = [[filterEnableArray objectAtIndex:btn.tag] boolValue];
	enable = !enable;
	[filterEnableArray replaceObjectAtIndex:btn.tag withObject:@(enable)];
	[self setButtonEnableStyle:btn enable:enable];
}


#pragma mark - TableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray *zArray;
 	if (tableView.tag==1001) {
		zArray=zArrayHistory;
	}else if (tableView.tag==1002) {
		
	}else if (tableView.tag==1003) {
		zArray=zArrayBookMark;
	}
	return zArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifierHistory = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierHistory];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierHistory];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
        // 删除cell中的子对象,刷新覆盖问题。
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.opaque=YES;
	
	NSArray *zArray;
 	if (tableView.tag==1001) {
		zArray=zArrayHistory;
	}else if (tableView.tag==1002) {
		
	}else if (tableView.tag==1003) {
		zArray=zArrayBookMark;
	}
	
	NSDictionary *zDict=[zArray objectAtIndex:indexPath.row];
	NSDictionary *zDictInfo=[zDict objectForKey:@"hentaiInfo"];
	cell.textLabel.text=[zDictInfo objectForKey:@"title"];
	cell.detailTextLabel.text=[zDict objectForKey:@"ReadTime"];
	
	
	
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	UIView *bgSeColorView = [[UIView alloc] init];
	//    bgSeColorView.backgroundColor = [[[zNbAllSet alloc]init]zMethReturnBaseColorSetByVP:@"xVpWordCardMainMenuTableCellHaSGroundColorDef"];
	bgSeColorView.backgroundColor = [UIColor clearColor];
    bgSeColorView.layer.masksToBounds = YES;
    cell.selectedBackgroundView = bgSeColorView;
	
	UIView *bgColorView = [[UIView alloc] init];
	//	bgColorView.backgroundColor = [[[zNbAllSet alloc]init]zMethReturnBaseColorSetByVP:@"xVpWordCardMainMenuTableCellNoSGroundColorDef"];
	bgColorView.backgroundColor = [UIColor clearColor];
	bgColorView.layer.masksToBounds = YES;
	cell.backgroundView=bgColorView;
	
	
	//	[cell.detailTextLabel setHighlightedTextColor:[[[zNbAllSet alloc]init]zMethReturnBaseColorSetByVP:@"xVpWordCardMainMenuTableCellTextColorDef"]];
	//	[cell.textLabel setHighlightedTextColor:[[[zNbAllSet alloc]init]zMethReturnBaseColorSetByVP:@"xVpWordCardMainMenuTableCellTextColorDef"]];
	
	[cell.detailTextLabel setHighlightedTextColor:[UIColor clearColor]];
	[cell.textLabel setHighlightedTextColor:[UIColor clearColor]];
	
	//    } else {
	//		cell.textLabel.text = [NSString stringWithFormat:@"s[%d]-r[%d]",indexPath.section,indexPath.row];
	//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *zArray;
 	if (tableView.tag==1001) {
		zArray=zArrayHistory;
	}else if (tableView.tag==1002) {
		
	}else if (tableView.tag==1003) {
		zArray=zArrayBookMark;
	}
	NSDictionary *zDict=[zArray objectAtIndex:indexPath.row];
	NSDictionary *zDictInfo=[zDict objectForKey:@"hentaiInfo"];
	[self.delegate zHentaiFilterReturnString:[zDictInfo objectForKey:@"title"]];
}
@end
