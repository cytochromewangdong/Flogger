//
//  MyWebView.m
//  WdaTest
//
//  Created by dong wang on 11-11-22.
//  Copyright (c) 2011年 atoato. All rights reserved.
//

#import "FloggerWebView.h"

@implementation FloggerWebView
@synthesize action;
@synthesize isUsing;
@synthesize isLoaded;
@synthesize actionDelegate;
-(NSString*)fillData:(NSString*)jsonData
{
    if(![self isLoading])
    {
        NSString * functionCall = [NSString stringWithFormat:@"fillData(%@)",jsonData];
        NSString *ret = [self stringByEvaluatingJavaScriptFromString:functionCall];  
        /*CGSize size = [self sizeThatFits:CGSizeMake(320, 416)];
        if(size.height>416)
        {
            [self getMainScrollView].scrollEnabled =YES;
        }*/
        return ret;
    }

    return nil;
}
-(NSString*)clearData
{
    if(![self isLoading])
    {
        NSString *ret = [self stringByEvaluatingJavaScriptFromString:@"clearData()"];  
        return ret;
    }
    
    return nil;
}
- (CGFloat)getHeight
{
    NSString *ret =  [self stringByEvaluatingJavaScriptFromString:@"getHeight();"];
    //CGRect frame = [self frameOfElement:@"document.body"];
    //NSLog(@"====return height:%f",frame.size.height);
     //CGSize size = [self sizeThatFits:CGSizeMake(320, 20)];
    return [ret floatValue];//
    
}
- (CGRect)frameOfElement:(NSString*)query {
    NSString* result = [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"\
                                                                     var target = %@; \
                                                                     var x = 0, y = 0; \
                                                                     for (var n = target; n && n.nodeType == 1; n = n.offsetParent) {  \
                                                                     x += n.offsetLeft; \
                                                                     y += n.offsetTop; \
                                                                     } \
                                                                     x + ',' + y + ',' + target.offsetWidth + ',' + target.offsetHeight; \
                                                                     ", query]];
    
    NSArray* points = [result componentsSeparatedByString:@","];
    CGFloat x = [[points objectAtIndex:0] floatValue];
    CGFloat y = [[points objectAtIndex:1] floatValue];
    CGFloat width = [[points objectAtIndex:2] floatValue];
    CGFloat height = [[points objectAtIndex:3] floatValue];
    
    return CGRectMake(x, y, width, height);
}
-(NSString*)hostCallBack:(NSString*)jsonData
{
    if(![self isLoading])
    {
        NSString * functionCall = [NSString stringWithFormat:@"hostCallBack(%@)",jsonData];
        NSString *ret =  [self stringByEvaluatingJavaScriptFromString:functionCall]; 
        CGSize size = [self sizeThatFits:CGSizeMake(320, 416)];
        if(size.height>416)
        {
            [self getMainScrollView].scrollEnabled =YES;
        }
        return ret;
    }
    return nil;
    
}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)removeFromSuperview
{
    [super removeFromSuperview];
    //NSLog(@"web view:%@ removed from parent view",self.action);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    
}
- (UIScrollView*) getMainScrollView
{
    if ([self respondsToSelector:@selector(scrollView)]) {
        return [[self.scrollView retain]autorelease];
    } else {
        for (id subview in self.subviews)
            if ([[subview class] isSubclassOfClass: [UIScrollView class]])
                return [[(UIScrollView *)subview retain]autorelease];        
    }
    return nil;
}
- (void)keyboardWillHide:(NSNotification*)notification {
    // Restore dimensions to prior size
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    UIScrollView *mainScrollView = [self getMainScrollView];
    CGRect frame = mainScrollView.bounds;
    frame.origin.y=0;
    mainScrollView.bounds =frame;
    [UIView commitAnimations];
}
-(id) inputAccessoryView
{
    return nil;
}
-(oneway void)release
{
    //NSLog(@"webview count:%d",self.retainCount);
    [super release];
}
-(void)dealloc
{
    self.action = nil;
    self.delegate = nil;
    [super dealloc];
}
@end
