#import "Statisticinfo.h"
@implementation Statisticinfo
	@dynamic useruid;
	-(NSNumber*) useruid
	{
		return [self.dataDict valueForKey:@"useruid"];
	}
	-(void) setUseruid:(NSNumber*) paramUseruid
	{
		[self.dataDict setValue: paramUseruid forKey:@"useruid"];
	}
	@dynamic delflg;
	-(NSNumber*) delflg
	{
		return [self.dataDict valueForKey:@"delflg"];
	}
	-(void) setDelflg:(NSNumber*) paramDelflg
	{
		[self.dataDict setValue: paramDelflg forKey:@"delflg"];
	}
	@dynamic platform;
	-(NSString*) platform
	{
		return [self.dataDict valueForKey:@"platform"];
	}
	-(void) setPlatform:(NSString*) paramPlatform
	{
		[self.dataDict setValue: paramPlatform forKey:@"platform"];
	}
	@dynamic followerscount;
	-(NSNumber*) followerscount
	{
		return [self.dataDict valueForKey:@"followerscount"];
	}
	-(void) setFollowerscount:(NSNumber*) paramFollowerscount
	{
		[self.dataDict setValue: paramFollowerscount forKey:@"followerscount"];
	}
	@dynamic friendscount;
	-(NSNumber*) friendscount
	{
		return [self.dataDict valueForKey:@"friendscount"];
	}
	-(void) setFriendscount:(NSNumber*) paramFriendscount
	{
		[self.dataDict setValue: paramFriendscount forKey:@"friendscount"];
	}
	@dynamic favouritescount;
	-(NSNumber*) favouritescount
	{
		return [self.dataDict valueForKey:@"favouritescount"];
	}
	-(void) setFavouritescount:(NSNumber*) paramFavouritescount
	{
		[self.dataDict setValue: paramFavouritescount forKey:@"favouritescount"];
	}
	@dynamic issuecount;
	-(NSNumber*) issuecount
	{
		return [self.dataDict valueForKey:@"issuecount"];
	}
	-(void) setIssuecount:(NSNumber*) paramIssuecount
	{
		[self.dataDict setValue: paramIssuecount forKey:@"issuecount"];
	}
	@dynamic photocount;
	-(NSNumber*) photocount
	{
		return [self.dataDict valueForKey:@"photocount"];
	}
	-(void) setPhotocount:(NSNumber*) paramPhotocount
	{
		[self.dataDict setValue: paramPhotocount forKey:@"photocount"];
	}
	@dynamic videocount;
	-(NSNumber*) videocount
	{
		return [self.dataDict valueForKey:@"videocount"];
	}
	-(void) setVideocount:(NSNumber*) paramVideocount
	{
		[self.dataDict setValue: paramVideocount forKey:@"videocount"];
	}
	@dynamic likecount;
	-(NSNumber*) likecount
	{
		return [self.dataDict valueForKey:@"likecount"];
	}
	-(void) setLikecount:(NSNumber*) paramLikecount
	{
		[self.dataDict setValue: paramLikecount forKey:@"likecount"];
	}
	@dynamic commentcount;
	-(NSNumber*) commentcount
	{
		return [self.dataDict valueForKey:@"commentcount"];
	}
	-(void) setCommentcount:(NSNumber*) paramCommentcount
	{
		[self.dataDict setValue: paramCommentcount forKey:@"commentcount"];
	}
	@dynamic resphotocount;
	-(NSNumber*) resphotocount
	{
		return [self.dataDict valueForKey:@"resphotocount"];
	}
	-(void) setResphotocount:(NSNumber*) paramResphotocount
	{
		[self.dataDict setValue: paramResphotocount forKey:@"resphotocount"];
	}
	@dynamic resvideocount;
	-(NSNumber*) resvideocount
	{
		return [self.dataDict valueForKey:@"resvideocount"];
	}
	-(void) setResvideocount:(NSNumber*) paramResvideocount
	{
		[self.dataDict setValue: paramResvideocount forKey:@"resvideocount"];
	}
	@dynamic receivedcomcnt;
	-(NSNumber*) receivedcomcnt
	{
		return [self.dataDict valueForKey:@"receivedcomcnt"];
	}
	-(void) setReceivedcomcnt:(NSNumber*) paramReceivedcomcnt
	{
		[self.dataDict setValue: paramReceivedcomcnt forKey:@"receivedcomcnt"];
	}
	@dynamic receivedphotocnt;
	-(NSNumber*) receivedphotocnt
	{
		return [self.dataDict valueForKey:@"receivedphotocnt"];
	}
	-(void) setReceivedphotocnt:(NSNumber*) paramReceivedphotocnt
	{
		[self.dataDict setValue: paramReceivedphotocnt forKey:@"receivedphotocnt"];
	}
	@dynamic receivedvideocnt;
	-(NSNumber*) receivedvideocnt
	{
		return [self.dataDict valueForKey:@"receivedvideocnt"];
	}
	-(void) setReceivedvideocnt:(NSNumber*) paramReceivedvideocnt
	{
		[self.dataDict setValue: paramReceivedvideocnt forKey:@"receivedvideocnt"];
	}
	@dynamic likedtotalcnt;
	-(NSNumber*) likedtotalcnt
	{
		return [self.dataDict valueForKey:@"likedtotalcnt"];
	}
	-(void) setLikedtotalcnt:(NSNumber*) paramLikedtotalcnt
	{
		[self.dataDict setValue: paramLikedtotalcnt forKey:@"likedtotalcnt"];
	}
	@dynamic bifollowerscnt;
	-(NSNumber*) bifollowerscnt
	{
		return [self.dataDict valueForKey:@"bifollowerscnt"];
	}
	-(void) setBifollowerscnt:(NSNumber*) paramBifollowerscnt
	{
		[self.dataDict setValue: paramBifollowerscnt forKey:@"bifollowerscnt"];
	}
	@dynamic latestweiboid;
	-(NSNumber*) latestweiboid
	{
		return [self.dataDict valueForKey:@"latestweiboid"];
	}
	-(void) setLatestweiboid:(NSNumber*) paramLatestweiboid
	{
		[self.dataDict setValue: paramLatestweiboid forKey:@"latestweiboid"];
	}
	@dynamic oldweiboid;
	-(NSNumber*) oldweiboid
	{
		return [self.dataDict valueForKey:@"oldweiboid"];
	}
	-(void) setOldweiboid:(NSNumber*) paramOldweiboid
	{
		[self.dataDict setValue: paramOldweiboid forKey:@"oldweiboid"];
	}
	@dynamic latestphotoid;
	-(NSNumber*) latestphotoid
	{
		return [self.dataDict valueForKey:@"latestphotoid"];
	}
	-(void) setLatestphotoid:(NSNumber*) paramLatestphotoid
	{
		[self.dataDict setValue: paramLatestphotoid forKey:@"latestphotoid"];
	}
	@dynamic oldphotoid;
	-(NSNumber*) oldphotoid
	{
		return [self.dataDict valueForKey:@"oldphotoid"];
	}
	-(void) setOldphotoid:(NSNumber*) paramOldphotoid
	{
		[self.dataDict setValue: paramOldphotoid forKey:@"oldphotoid"];
	}
	@dynamic latestvideoid;
	-(NSNumber*) latestvideoid
	{
		return [self.dataDict valueForKey:@"latestvideoid"];
	}
	-(void) setLatestvideoid:(NSNumber*) paramLatestvideoid
	{
		[self.dataDict setValue: paramLatestvideoid forKey:@"latestvideoid"];
	}
	@dynamic oldvideoid;
	-(NSNumber*) oldvideoid
	{
		return [self.dataDict valueForKey:@"oldvideoid"];
	}
	-(void) setOldvideoid:(NSNumber*) paramOldvideoid
	{
		[self.dataDict setValue: paramOldvideoid forKey:@"oldvideoid"];
	}
	@dynamic latestlikeid;
	-(NSNumber*) latestlikeid
	{
		return [self.dataDict valueForKey:@"latestlikeid"];
	}
	-(void) setLatestlikeid:(NSNumber*) paramLatestlikeid
	{
		[self.dataDict setValue: paramLatestlikeid forKey:@"latestlikeid"];
	}
	@dynamic oldlikeid;
	-(NSNumber*) oldlikeid
	{
		return [self.dataDict valueForKey:@"oldlikeid"];
	}
	-(void) setOldlikeid:(NSNumber*) paramOldlikeid
	{
		[self.dataDict setValue: paramOldlikeid forKey:@"oldlikeid"];
	}
	@dynamic latestcommentid;
	-(NSNumber*) latestcommentid
	{
		return [self.dataDict valueForKey:@"latestcommentid"];
	}
	-(void) setLatestcommentid:(NSNumber*) paramLatestcommentid
	{
		[self.dataDict setValue: paramLatestcommentid forKey:@"latestcommentid"];
	}
	@dynamic oldcommentid;
	-(NSNumber*) oldcommentid
	{
		return [self.dataDict valueForKey:@"oldcommentid"];
	}
	-(void) setOldcommentid:(NSNumber*) paramOldcommentid
	{
		[self.dataDict setValue: paramOldcommentid forKey:@"oldcommentid"];
	}
	@dynamic latestresphotoid;
	-(NSNumber*) latestresphotoid
	{
		return [self.dataDict valueForKey:@"latestresphotoid"];
	}
	-(void) setLatestresphotoid:(NSNumber*) paramLatestresphotoid
	{
		[self.dataDict setValue: paramLatestresphotoid forKey:@"latestresphotoid"];
	}
	@dynamic oldresphotoid;
	-(NSNumber*) oldresphotoid
	{
		return [self.dataDict valueForKey:@"oldresphotoid"];
	}
	-(void) setOldresphotoid:(NSNumber*) paramOldresphotoid
	{
		[self.dataDict setValue: paramOldresphotoid forKey:@"oldresphotoid"];
	}
	@dynamic latestresvideoid;
	-(NSNumber*) latestresvideoid
	{
		return [self.dataDict valueForKey:@"latestresvideoid"];
	}
	-(void) setLatestresvideoid:(NSNumber*) paramLatestresvideoid
	{
		[self.dataDict setValue: paramLatestresvideoid forKey:@"latestresvideoid"];
	}
	@dynamic oldresvideoid;
	-(NSNumber*) oldresvideoid
	{
		return [self.dataDict valueForKey:@"oldresvideoid"];
	}
	-(void) setOldresvideoid:(NSNumber*) paramOldresvideoid
	{
		[self.dataDict setValue: paramOldresvideoid forKey:@"oldresvideoid"];
	}
	@dynamic gallerycount;
	-(NSNumber*) gallerycount
	{
		return [self.dataDict valueForKey:@"gallerycount"];
	}
	-(void) setGallerycount:(NSNumber*) paramGallerycount
	{
		[self.dataDict setValue: paramGallerycount forKey:@"gallerycount"];
	}
@end
