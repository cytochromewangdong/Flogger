#import "MyIssueInfo.h"
@implementation MyIssueInfo
	@dynamic count;
	-(NSNumber*) count
	{
		return [self.dataDict valueForKey:@"count"];
	}
	-(void) setCount:(NSNumber*) paramCount
	{
		[self.dataDict setValue: paramCount forKey:@"count"];
	}
	@dynamic shareMediaUrl;
	-(NSString*) shareMediaUrl
	{
		return [self.dataDict valueForKey:@"shareMediaUrl"];
	}
	-(void) setShareMediaUrl:(NSString*) paramShareMediaUrl
	{
		[self.dataDict setValue: paramShareMediaUrl forKey:@"shareMediaUrl"];
	}
	@dynamic liked;
	-(NSNumber*) liked
	{
		return [self.dataDict valueForKey:@"liked"];
	}
	-(void) setLiked:(NSNumber*) paramLiked
	{
		[self.dataDict setValue: paramLiked forKey:@"liked"];
	}
	@dynamic likeid;
	-(NSNumber*) likeid
	{
		return [self.dataDict valueForKey:@"likeid"];
	}
	-(void) setLikeid:(NSNumber*) paramLikeid
	{
		[self.dataDict setValue: paramLikeid forKey:@"likeid"];
	}
	@dynamic middleWidth;
	-(NSNumber*) middleWidth
	{
		return [self.dataDict valueForKey:@"middleWidth"];
	}
	-(void) setMiddleWidth:(NSNumber*) paramMiddleWidth
	{
		[self.dataDict setValue: paramMiddleWidth forKey:@"middleWidth"];
	}
	@dynamic middleHeight;
	-(NSNumber*) middleHeight
	{
		return [self.dataDict valueForKey:@"middleHeight"];
	}
	-(void) setMiddleHeight:(NSNumber*) paramMiddleHeight
	{
		[self.dataDict setValue: paramMiddleHeight forKey:@"middleHeight"];
	}
	@dynamic thumbnailWidth;
	-(NSNumber*) thumbnailWidth
	{
		return [self.dataDict valueForKey:@"thumbnailWidth"];
	}
	-(void) setThumbnailWidth:(NSNumber*) paramThumbnailWidth
	{
		[self.dataDict setValue: paramThumbnailWidth forKey:@"thumbnailWidth"];
	}
	@dynamic thumbnailHeight;
	-(NSNumber*) thumbnailHeight
	{
		return [self.dataDict valueForKey:@"thumbnailHeight"];
	}
	-(void) setThumbnailHeight:(NSNumber*) paramThumbnailHeight
	{
		[self.dataDict setValue: paramThumbnailHeight forKey:@"thumbnailHeight"];
	}
	@dynamic scalethumbnailurl;
	-(NSString*) scalethumbnailurl
	{
		return [self.dataDict valueForKey:@"scalethumbnailurl"];
	}
	-(void) setScalethumbnailurl:(NSString*) paramScalethumbnailurl
	{
		[self.dataDict setValue: paramScalethumbnailurl forKey:@"scalethumbnailurl"];
	}
	@dynamic commentList;
	-(NSMutableArray*) commentList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"commentList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					MyIssueInfo* objMyIssueInfo=[[[MyIssueInfo alloc]init]autorelease];
					objMyIssueInfo.dataDict=row;
					[ret addObject:objMyIssueInfo];
				}
			}
		return ret;
	}
	-(void) setCommentList:(NSMutableArray*) paramCommentList
	{
		if(paramCommentList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(MyIssueInfo *row in paramCommentList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"commentList"];
		} else
			[self.dataDict setValue: nil forKey:@"commentList"];
	}
	@dynamic likers;
	-(NSString*) likers
	{
		return [self.dataDict valueForKey:@"likers"];
	}
	-(void) setLikers:(NSString*) paramLikers
	{
		[self.dataDict setValue: paramLikers forKey:@"likers"];
	}
	@dynamic likerList;
	-(NSMutableArray*) likerList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"likerList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					Likeinfo* objLikeinfo=[[[Likeinfo alloc]init]autorelease];
					objLikeinfo.dataDict=row;
					[ret addObject:objLikeinfo];
				}
			}
		return ret;
	}
	-(void) setLikerList:(NSMutableArray*) paramLikerList
	{
		if(paramLikerList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(Likeinfo *row in paramLikerList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"likerList"];
		} else
			[self.dataDict setValue: nil forKey:@"likerList"];
	}
@end
