//
//  GridPageView.m
//  Flogger
//
//  Created by jwchen on 12-1-3.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "GridPageView.h"
#import "ImageGridViewCell.h"
#import "VideoGridViewCell.h"
#import "UIImageView+WebCache.h"
#import "GlobalUtils.h"
#import "Issueinfo.h"

#define kPhotoGridTag 1000
#define kVideoGridTag 1001


@interface GridPageView(){
@private
//    NSMutableArray *photoArray;
//    NSMutableArray *videoArray;
    
//    Issueinfo *_issueInfo;
}
@end

@implementation GridPageView
@synthesize photoGridView,videoGridView, photoArray = _photoArray, videoArray = _videoArray, delegate;

//-(void)mockData
//{
//    photoArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"test3.png"], nil];
//    videoArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"test4.png"], nil];
//}

-(void)reloadData
{
    [photoGridView reloadData];
    [videoGridView reloadData];
}

-(void) setupGridView
{
    photoGridView = [[[AQGridView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] autorelease];
    photoGridView.tag = kPhotoGridTag;
    photoGridView.delegate = self;
    photoGridView.dataSource = self;
    [self.scrollview addSubview:photoGridView];
    [photoGridView reloadData];
    
    videoGridView = [[[AQGridView alloc] initWithFrame:CGRectMake(photoGridView.frame.size.width, 0, self.frame.size.width, self.frame.size.height)] autorelease];
    videoGridView.tag = kVideoGridTag;
    videoGridView.delegate = self;
    videoGridView.dataSource = self;
    [self.scrollview addSubview:videoGridView];
    [videoGridView reloadData];
    
    self.pagecontrol.numberOfPages = 2;
    [scrollview setContentSize:CGSizeMake(scrollview.frame.size.width * 2, scrollview.frame.size.height)];
}


-(void)initData
{
    _videoArray = [[NSMutableArray alloc] init];
    _photoArray = [[NSMutableArray alloc] init];
//    _issueInfo = [[Issueinfo alloc] init];
    [self setupGridView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self mockData];
        [self initData];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:(NSCoder *)aDecoder];
    if (self) {
//        [self setupGridView];
        [self initData];
    }
    return self;
}

#pragma mark - data source
- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    if (gridView.tag == kPhotoGridTag) {
        NSInteger count = _photoArray? _photoArray.count : 0;
        NSLog(@"photo count: %d", count);
        return _photoArray? _photoArray.count : 0;
    }
    else
    {
        return _videoArray? _videoArray.count : 0;
    }
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString *PhotoCellIdentifier = @"PhotoCellIdentifier";
    static NSString *VideoCellIdentifier = @"VideoCellIdentifier";
    
    NSString *identifier = nil;
//    UIImage *image = nil;
    NSArray *dataArray = nil;
    if (aGridView.tag == kPhotoGridTag) {
        identifier = PhotoCellIdentifier;
        dataArray = _photoArray;
//        image = [photoArray objectAtIndex:index];
    }
    else
    {
        identifier = VideoCellIdentifier;
        dataArray = _videoArray;
//        image = [videoArray objectAtIndex:index];
    }
    
    ImageGridViewCell *cell = (ImageGridViewCell *)[aGridView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSInteger width = 100;
        NSInteger height = 100;
        if (aGridView.tag == kPhotoGridTag) {
            cell = [[[ImageGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, width, height) reuseIdentifier:identifier] autorelease];
        }
        else
        {
            cell = [[[VideoGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, width, height) reuseIdentifier:identifier] autorelease];
        }
        
        cell.selectionGlowColor = [UIColor blueColor];
    }
    
    Issueinfo* issueInfo = [dataArray objectAtIndex:index];
//    cell.image = image;
    [cell.imageView setImageWithURL:[NSURL URLWithString:[GlobalUtils imageServerUrl:issueInfo.thumbnailurl]]];
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(aGridView.frame.size.width/3, aGridView.frame.size.width/3) );
}

#pragma mark - data delegate
- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
    NSLog(@"didSelectItemAtIndex: %d", index);
    [gridView deselectItemAtIndex:index animated:YES];
    
    NSInteger pageIndex = gridView.tag == kPhotoGridTag? 0 : 1;
    if (delegate) {
        [delegate gridPageView:self atPageIndex:pageIndex index:index];
    }
}

-(void)dealloc
{
    RELEASE_SAFELY(_photoArray);
    RELEASE_SAFELY(_videoArray);
    RELEASE_SAFELY(photoGridView);
    RELEASE_SAFELY(videoGridView);
//    RELEASE_SAFELY(_issueInfo);
    [super dealloc];
}

@end
