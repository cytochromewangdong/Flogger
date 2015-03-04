#import "AlbuminfoCom.h"
@implementation AlbuminfoCom
	@dynamic type;
	-(NSNumber*) type
	{
		return [self.dataDict valueForKey:@"type"];
	}
	-(void) setType:(NSNumber*) paramType
	{
		[self.dataDict setValue: paramType forKey:@"type"];
	}
	@dynamic albuminfoList;
	-(NSMutableArray*) albuminfoList
	{
		NSMutableArray* ret=[[[NSMutableArray alloc]init]autorelease];
		NSMutableArray* rawData = [self.dataDict valueForKey:@"albuminfoList"];
			if(rawData) {
				for(NSMutableDictionary *row in rawData) {
					Albuminfo* objAlbuminfo=[[[Albuminfo alloc]init]autorelease];
					objAlbuminfo.dataDict=row;
					[ret addObject:objAlbuminfo];
				}
			}
		return ret;
	}
	-(void) setAlbuminfoList:(NSMutableArray*) paramAlbuminfoList
	{
		if(paramAlbuminfoList){
			NSMutableArray* rawDataRows=[[[NSMutableArray alloc]init]autorelease];
			for(Albuminfo *row in paramAlbuminfoList) {
				[rawDataRows addObject:row.dataDict];
			}
			[self.dataDict setValue: rawDataRows forKey:@"albuminfoList"];
		} else
			[self.dataDict setValue: nil forKey:@"albuminfoList"];
	}
	@dynamic description;
	-(NSString*) description
	{
		return [self.dataDict valueForKey:@"description"];
	}
	-(void) setDescription:(NSString*) paramDescription
	{
		[self.dataDict setValue: paramDescription forKey:@"description"];
	}
	@dynamic srcGroupID;
	-(NSNumber*) srcGroupID
	{
		return [self.dataDict valueForKey:@"srcGroupID"];
	}
	-(void) setSrcGroupID:(NSNumber*) paramSrcGroupID
	{
		[self.dataDict setValue: paramSrcGroupID forKey:@"srcGroupID"];
	}
	@dynamic destGroupID;
	-(NSNumber*) destGroupID
	{
		return [self.dataDict valueForKey:@"destGroupID"];
	}
	-(void) setDestGroupID:(NSNumber*) paramDestGroupID
	{
		[self.dataDict setValue: paramDestGroupID forKey:@"destGroupID"];
	}
	@dynamic mediaType;
	-(NSNumber*) mediaType
	{
		return [self.dataDict valueForKey:@"mediaType"];
	}
	-(void) setMediaType:(NSNumber*) paramMediaType
	{
		[self.dataDict setValue: paramMediaType forKey:@"mediaType"];
	}
	@dynamic uploadFileSize;
	-(NSNumber*) uploadFileSize
	{
		return [self.dataDict valueForKey:@"uploadFileSize"];
	}
	-(void) setUploadFileSize:(NSNumber*) paramUploadFileSize
	{
		[self.dataDict setValue: paramUploadFileSize forKey:@"uploadFileSize"];
	}
	@dynamic uploadFileID;
	-(NSString*) uploadFileID
	{
		return [self.dataDict valueForKey:@"uploadFileID"];
	}
	-(void) setUploadFileID:(NSString*) paramUploadFileID
	{
		[self.dataDict setValue: paramUploadFileID forKey:@"uploadFileID"];
	}
	@dynamic startSize;
	-(NSNumber*) startSize
	{
		return [self.dataDict valueForKey:@"startSize"];
	}
	-(void) setStartSize:(NSNumber*) paramStartSize
	{
		[self.dataDict setValue: paramStartSize forKey:@"startSize"];
	}
@end
