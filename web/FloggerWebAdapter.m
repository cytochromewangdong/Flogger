//
//  FloggerWebAdapter.m
//  Flogger
//
//  Created by dong wang on 12-3-29.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "FloggerWebAdapter.h"
#import "SBJson.h"
static FloggerWebAdapter *webAdapter;

@implementation FloggerWebAdapter
+(FloggerWebAdapter*) getSingleton
{ 
    if(!webAdapter)
    {
        webAdapter = [[FloggerWebAdapter alloc]init];
    }
    return webAdapter;
}

+(void)purgeSharedInstance
{
    [webAdapter release];
    webAdapter = nil;
    
}
-(void) clearMemory
{
    [_biographyView release];
    _biographyView = nil;
    //[_feedShapeView release];
    //_feedShapeView =nil;
    [_composeView release];
    _composeView = nil;
    FloggerWebView* feedShapeView = nil;
    if([_feedRows count]>0)
    {
        feedShapeView = [[[_feedRows objectAtIndex:0]retain]autorelease];
    }
    [_feedRows removeAllObjects];
    if(feedShapeView)
    {
        [_feedRows addObject:feedShapeView];
    }
}
-(void) dealloc
{
    [self clearMemory];
    [_feedRows release];
    _feedRows = nil;
    
}
-(id) init
{
    self = [super init];
    if(self)
    {
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"feed" ofType:@"html" inDirectory:@"."]];
        _feedrequest = [NSURLRequest requestWithURL:url];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        _feedRows = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)setDefaultParameter:(UIWebView*)webview
{
    if ([webview respondsToSelector:@selector(scrollView)]) {
        webview.scrollView.scrollEnabled = NO; // available starting in iOS 5
    } else {
        for (id subview in webview.subviews)
            if ([[subview class] isSubclassOfClass: [UIScrollView class]])
                ((UIScrollView *)subview).scrollEnabled = NO;        
    }
    webview.delegate = self;
    
}

-(void) refreshBiographyView
{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"biography" ofType:@"html" inDirectory:@"."]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    _biographyView.frame=CGRectMake(0, 0, 320, 416);
    _biographyView.action=@"biography";
    _biographyView.dataDetectorTypes=UIDataDetectorTypeNone;
    _biographyView.scalesPageToFit = NO;
    _biographyView.backgroundColor =[UIColor colorWithRed:238/255.0 green:238/255.0 blue:232/255.0 alpha:1.0];
    //[[_biographyView getMainScrollView]setBounces:NO];
    [[_biographyView getMainScrollView] setShowsHorizontalScrollIndicator:NO];
    [[_biographyView getMainScrollView] setShowsHorizontalScrollIndicator:NO];
    //[self setDefaultParameter:_biographyView];
    _biographyView.delegate = self;
    [_biographyView loadRequest:request];
}

/*-(void) refreshFeedView:(FloggerWebView*)feedView action:(NSString*)action
{

    feedView.frame=CGRectMake(0, 0, 320, 2);
    feedView.action=action;
    feedView.dataDetectorTypes=UIDataDetectorTypeNone;
    feedView.scalesPageToFit = NO;
    //feedView.backgroundColor =[UIColor greenColor];
    [[feedView getMainScrollView]setBounces:NO];
    [feedView  getMainScrollView].scrollEnabled =NO;
    [[feedView getMainScrollView] setShowsHorizontalScrollIndicator:NO];
    [[feedView getMainScrollView] setShowsHorizontalScrollIndicator:NO];
    [self setDefaultParameter:feedView];
    //NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"feed" ofType:@"html" inDirectory:@"."]];
    //_feedrequest = [NSURLRequest requestWithURL:url];
    //[feedView loadHTMLString:[[NSString alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"feed" ofType:@"html" inDirectory:@"."]  encoding:NSUTF8StringEncoding error:nil]   baseURL:url];
    [feedView loadRequest:_feedrequest];
}
-(void) refreshNoramlView:(FloggerWebView*)normalWebView  action:(NSString*)action url:(NSString*) urlstr
{
    normalWebView.frame=CGRectMake(0, 0, 320, 2);
    normalWebView.action = action;
    normalWebView.dataDetectorTypes=UIDataDetectorTypeNone;
    normalWebView.scalesPageToFit = NO;
    [[normalWebView getMainScrollView]setBounces:NO];
    [normalWebView  getMainScrollView].scrollEnabled =NO;
    [[normalWebView getMainScrollView] setShowsHorizontalScrollIndicator:NO];
    [[normalWebView getMainScrollView] setShowsHorizontalScrollIndicator:NO];
    [self setDefaultParameter:normalWebView];
    NSURL *url = [NSURL fileURLWithPath:urlstr];
    [normalWebView loadRequest:[NSURLRequest requestWithURL:url]];

}
-(FloggerWebView*) createNormalWebView:(NSString*)action url:(NSString*) urlstr
{
    FloggerWebView *fview = [[FloggerWebView alloc]init];
    [self refreshNoramlView:fview action:action url:urlstr];
    return fview;
}
-(FloggerWebView*) createProfileHeaderView:(NSString*)action
{
    //if(!_feedViewHeader)
    {
     return [self createNormalWebView:action url:[[NSBundle mainBundle] pathForResource:@"profile" ofType:@"html" inDirectory:@"."]];
    }
    // _feedViewHeader = 
    //_feedViewHeader.action = action;
    // return [_feedViewHeader retain];
}
-(FloggerWebView*) createViewerHeaderView:(NSString*)action
{
    return [self createNormalWebView:action url:[[NSBundle mainBundle] pathForResource:@"viewerHeader" ofType:@"html" inDirectory:@"."]];
}
-(FloggerWebView*) createComposeView:(NSString*)action
{
    return [self createNormalWebView:action url:[[NSBundle mainBundle] pathForResource:@"compose" ofType:@"html" inDirectory:@"."]];
}
-(FloggerWebView *) getComposeView
{
    if (!_composeView) {
        _composeView = [self createComposeView:kComposeWebAction];
        [_composeView  getMainScrollView].scrollEnabled =YES;
    }
    return _composeView;
}
-(FloggerWebView*) createViewerView:(NSString*)action
{
    return [self createNormalWebView:action url:[[NSBundle mainBundle] pathForResource:@"viewer" ofType:@"html" inDirectory:@"."]];
}*/
-(FloggerWebView*) getBiographyView
{
    if(!_biographyView)
    {
        _biographyView = [[FloggerWebView alloc]init];
  
        [self refreshBiographyView];
    }
    return _biographyView;
}

/*-(FloggerWebView*)getFeedView:(NSString*)action
{
    for (int i=1;i<[_feedRows count];i++) {
        FloggerWebView *fview = [_feedRows objectAtIndex:i];
        if(!fview.isUsing)
        {
            fview.isUsing = YES;
            fview.action = action;
            return [[fview retain]autorelease];
        }
    }
    FloggerWebView *fview = [[[FloggerWebView alloc]init]autorelease];
    fview.isUsing = YES;
    [self refreshFeedView:fview action:action];
    [_feedRows addObject:fview];
    
    return fview;
    //return [_feedRows objectAtIndex:0];
}
-(FloggerWebView*)getShapeReference
{
    if([_feedRows count]>0)
        return [_feedRows objectAtIndex:0];
    
    return [self getFeedView:kShapeWeb];
}
-(void)initFeedShapeView
{
    for(int i=0;i<1;i++) {
        FloggerWebView *fview = [[[FloggerWebView alloc]init]autorelease];
        [self refreshFeedView:fview action:kShapeWeb];
        [_feedRows addObject:fview];
    }
}*/
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //NSString *hostStr = [[request URL]host];
    //NSString *urlStr = [[request URL]absoluteString];
    NSString* scheme = [[request URL]scheme];
    if([scheme isEqualToString:kMyapp] || [scheme isEqualToString:kTagTag] || [scheme isEqualToString:kAtTag])
    {
        FloggerWebView *currentWeb = (FloggerWebView*)webView;
        NSDictionary *data = nil;
        NSURL *url = [request URL];
        if(url.query)
        {
            NSString *myQuery = [url.query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            data =[[[myQuery JSONValue]retain]autorelease];
            if(!data)
            {
                data = [[[NSMutableDictionary alloc]init]autorelease];
//                NSLog(@"query %@", myQuery);
                [data setValue:myQuery forKey:kKeyword];
                [data setValue:scheme forKey:kScheme];
            }
        }
        if(currentWeb.actionDelegate && [currentWeb.actionDelegate respondsToSelector:@selector(handleAction:)])
        {
            NSNotification* notifcate = [NSNotification notificationWithName:currentWeb.action object:data];
            [currentWeb.actionDelegate handleAction:notifcate];
            return NO;
        }
        if(data)
        {
           [[NSNotificationCenter defaultCenter] postNotificationName:currentWeb.action object:data];
        }
        return NO;
    }  else {
        return YES;
    }
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    FloggerWebView *currentWeb = (FloggerWebView*)webView;
    currentWeb.isLoaded = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:currentWeb.action object:nil];
    //NSLog(@"bii%@",[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].innerHTML"]);
    //NSLog(@"height%@",[webView stringByEvaluatingJavaScriptFromString:@"$('body').height()"]);
}

/*-(NSString *) getValue: (NSString*)key
{
    NSString * functionCall = [NSString stringWithFormat:@"getValue('%@')",key];
    return [webview stringByEvaluatingJavaScriptFromString:functionCall];
}*/
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}
@end
