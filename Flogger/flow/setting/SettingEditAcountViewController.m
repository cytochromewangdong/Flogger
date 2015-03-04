//
//  SettingEditAcountViewController.m
//  Flogger
//
//  Created by jwchen on 12-2-4.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "SettingEditAcountViewController.h"

#import "GlobalUtils.h"

@interface SettingEditAcountViewController()
@property (retain)NSMutableArray *data;
@end

@implementation SettingEditAcountViewController
@synthesize data;

-(void)dealloc
{
    self.data = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.title = @"";
    
    self.data =[[[NSMutableArray alloc]init]autorelease];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject: NSLocalizedString(@"First Name",@"First Name")];
    [array addObject: NSLocalizedString(@"Last Name",@"Last Name")];
    NSMutableArray *array1 = [[NSMutableArray alloc] init];
    [array addObject: NSLocalizedString(@"New Passport",@"New Passport")];
    [array addObject: NSLocalizedString(@"Confirm Password",@"Confirm Password")];
    
    [self.data addObject:array];
    [self.data addObject:array1];
    
    RELEASE_SAFELY(array);
    RELEASE_SAFELY(array1);

    
    [super viewDidLoad];

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSArray* array = [data objectAtIndex:section];
    return array.count;
}

-(void)createCell:(UITableViewCell*)cell
{
    UILabel* label = [[[UILabel alloc]initWithFrame:CGRectMake(15, 5, 120, 40)]autorelease];
    label.tag = 1;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [GlobalUtils getBoldFontByStyle:FONT_MIDDLE];
    
    UITextView* textview = [[[UITextView alloc]initWithFrame:CGRectMake(130, 5, 180, 40)]autorelease];
    
    textview.tag = 2;
    textview.font = [GlobalUtils getBoldFontByStyle:FONT_MIDDLE];
    textview.delegate = self; 
    textview.backgroundColor = [UIColor clearColor];
    
    
    [cell addSubview:label];
    [cell addSubview:textview];
    //[label release];
    //[textview release];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        
        [self createCell:cell];
    }
    
    // Configure the cell...
    NSArray* array = [data objectAtIndex:indexPath.section];
    
    NSUInteger row = [indexPath row];
    
    UILabel* label = (UILabel*)[cell viewWithTag:1]; 
//    UITextView* textview = (UITextView*)[cell viewWithTag:2]; 
    
    label.text = [array objectAtIndex:row];

    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 50;
}

@end
