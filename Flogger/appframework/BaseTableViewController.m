//
//  BaseTableViewController.m
//  Flogger
//
//  Created by jwchen on 12-3-14.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseTableViewController.h"
#import "GlobalData.h"

@interface BaseTableViewController ()
{
    BOOL _loading;
}
@property(nonatomic, retain) UIActivityIndicatorView *indicationView;
@end

@implementation BaseTableViewController
@synthesize dataArray, dataDictionary, hideSectionHeader, tableStyle, indicationView, loading, serverProxy;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([self.navigationController viewControllers].count > 1)
    {
        [self setBackNavigation];
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    self.dataArray = nil;
    self.dataDictionary = nil;
    self.indicationView = nil;
    self.serverProxy.delegate = nil;
    self.serverProxy = nil;
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataDictionary) {
        return dataDictionary.allKeys.count;
    }
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.dataDictionary) {
        NSString *key = [[self.dataDictionary allKeys] objectAtIndex:section];
        
        NSArray *valueArr = (NSArray *)[self.dataDictionary objectForKey:key];
        return valueArr.count;
    }
    else
    {
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

-(void)leftAction:(id)sender;
{
//    NSLog(@"leftAction");
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [[GlobalData sharedInstance].menuView show];
    }
}

-(void)backAction:(id)sender;
{
//    NSLog(@"backAction");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightAction:(id)sender
{
//    NSLog(@"rightAction");
}


-(UIBarButtonItem *) barButtonItemWithImage:(NSString *)str image:(NSString *)imageName pressimage:(NSString*)pressimageName withAciton:(SEL)action
{
    UIBarButtonItem *item = nil;
    if (imageName) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:imageName];
        btn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        
        if(pressimageName)
            [btn setBackgroundImage:[UIImage imageNamed:pressimageName] forState:UIControlStateHighlighted];
        
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        if(str){
            [btn setTitle:str forState:UIControlStateNormal];
            UIFont *famFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
              [btn setTitleColor: [[[UIColor alloc] initWithRed:64/255.0 green:64/255.0 blue:62/255.0 alpha:1.0] autorelease]forState:UIControlStateNormal];
             [btn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.shadowOffset = CGSizeMake(0, 1);
            btn.titleLabel.font = famFont;
            
            if ([str isEqualToString:NSLocalizedString(@"Back", @"Back")]) {
                UIEdgeInsets titleInset = UIEdgeInsetsMake(0, 5, 0, 0);
                btn.titleEdgeInsets = titleInset;
            }
        }
        item = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
        
        
    }
    else if(str)
    {
        item = [[[UIBarButtonItem alloc] initWithTitle:str style:UIBarButtonItemStylePlain target:self action:action] autorelease];
    }
    
    return item;
    
}

-(UIBarButtonItem *) barButtonItem:(NSString *)str image:(NSString *)imageName withAciton:(SEL)action
{
    
    if (!imageName && str) {
        imageName = SNS_BUTTON;//@"Button";
    }
    
    return [self barButtonItemWithImage:str image:imageName pressimage:nil withAciton:action];
}

-(void)setRightNavigationBarWithTitleAndImage:(NSString *)text image:(NSString *)imageName pressimage:(NSString*)pressimgname
{
    self.navigationItem.rightBarButtonItem = [self barButtonItemWithImage:text image:imageName pressimage:pressimgname withAciton:@selector(rightAction:)];
}

-(void)setRightNavigationBarWithTitle:(NSString *)text image:(NSString *)imageName
{
    self.navigationItem.rightBarButtonItem = [self barButtonItem:text image:imageName withAciton:@selector(rightAction:)];
}

-(void)setLeftNavigationBarWithTitle:(NSString *)text image:(NSString *)imageName
{
    self.navigationItem.leftBarButtonItem = [self barButtonItem:text image:imageName withAciton:@selector(leftAction:)];
}


-(void)setBackNavigation
{
    self.navigationItem.leftBarButtonItem = [self barButtonItem:NSLocalizedString(@"Back", @"Back") image:SNS_BACK_BUTTON withAciton:@selector(backAction:)];
}

-(void)reloading
{
    self.loading = YES;
}

-(void)setLoading:(BOOL)isLoading
{
    _loading = isLoading;
    if (isLoading) {
        if (!self.indicationView) {
            self.indicationView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
            self.indicationView.center = self.view.center;
            [self.view addSubview:self.indicationView];
        }
        
        [self.view bringSubviewToFront:self.indicationView];
        [self.indicationView startAnimating];
    }
    else
    {
        [self.indicationView stopAnimating];
    }
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)networkFinished:(BaseServerProxy *)serverproxy
{
    self.loading = NO;
    
    if (serverproxy.errorMessage) {
        [GlobalUtils showAlert:nil message:serverproxy.errorMessage];
    }
}

-(void)transactionFinished:(BaseServerProxy *)sp
{
//    NSLog(@"transactionFinished");
    //[self networkFinished:sp];
}

-(void)transactionFailed:(BaseServerProxy *)sp
{
//    NSLog(@"transactionFailed");     
    //[self networkFinished:sp];
}

-(void)networkError:(BaseServerProxy *)sp
{
//    NSLog(@"networkError");
    //[self networkFinished:sp]; 
}


@end
