//
//  WAMSAppDelegate.m
//  bma-week-13-iOS-iTahDoodle
//
//  Created by W. Mooncai on 1/10/13.  BMA HW Week 13
//  Big Nerd Ranch Ch 27
//  Copyright (c) 2013 WAMS. All rights reserved.
//

#import "WAMSAppDelegate.h"

NSString *docPath()
{
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            YES);
    
    return [[pathList objectAtIndex:0] stringByAppendingPathComponent:@"data.td"];
}

@implementation WAMSAppDelegate

#pragma mark - Application delegate callbacks

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Attempt to load an existing to-do dataset from an array stored to disk.
    NSArray *plist= [NSArray arrayWithContentsOfFile:docPath()];
    if (plist) {
        // If there was a dataset available, copy it into your instance variable.
        tasks = [plist mutableCopy];
    } else {
        // Otherwise, just create an empty one to get us started.
        tasks = [[NSMutableArray alloc] init];
    }
    
    // Is tasks empty?
    if ([tasks count] == 0) {
        // PUt some strings in it
        [tasks addObject:@"Walk the dogs"];
        [tasks addObject:@"Feed the hogs"];
        [tasks addObject:@"Chop the logs"];
    }
    
    // Create and configure the UIWindow instance
    // A CGRect is a struct with an origin (x,y) and size (width,height)
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    UIWindow *theWindow = [[UIWindow alloc] initWithFrame:windowFrame];
    [self setWindow:theWindow];
    
    // Define the frame rectangles of the three UI elements
    // CGRectMake() creates a CGRect from (x, y, width, height)
    CGRect tableFrame = CGRectMake(0, 80, 320, 380);
    CGRect fieldFrame = CGRectMake(20, 40, 200, 31);
    CGRect buttonFrame = CGRectMake(228, 40, 72, 31);
    
    // Create and configure the table view
    taskTable = [[UITableView alloc] initWithFrame:tableFrame
                                             style:UITableViewStylePlain];
    [taskTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Make this object the table view's dataSource
    [taskTable setDataSource:self];
    
    // Create and configure the text field where new tasks will be typed
    taskField = [[UITextField alloc] initWithFrame:fieldFrame];
    [taskField setBorderStyle:UITextBorderStyleRoundedRect];
    [taskField setPlaceholder:@"Type a task, tap Insert"];
    
    // Create and configure a round rect Insert button
    insertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [insertButton setFrame:buttonFrame];
    
    // Buttons behave using a target/action callback
    // Configure the Insert button's action to call this object's -addTask: method
    [insertButton addTarget:self
                     action:@selector(addTask:)
           forControlEvents:UIControlEventTouchUpInside];
    
    // Give the button a title
    [insertButton setTitle:@"Insert"
                  forState:UIControlStateNormal];
    
    // Add our three UI elements to the window
    [[self window] addSubview:taskTable];
    [[self window] addSubview:taskField];
    [[self window] addSubview:insertButton];
    
    // Finalize the window and put it on the screen
    [[self window] setBackgroundColor:[UIColor whiteColor]];
    [[self window] makeKeyAndVisible];
    
    
/*
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
*/
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // This method is only called in iOS 4.0+
    
    // Save our tasks array to disk
    [tasks writeToFile:docPath() atomically:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // This method is only called in iOS 4.0+
    
    // Save our tasks array to disk
    [tasks writeToFile:docPath() atomically:YES];
}

#pragma mark - Table View management

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    // Because this table view only has one section,
    // the number of rows in it is equal to the number
    // of items in our tasks array
    return [tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // To improve performance, we reconfigure cells in memory
    // that have scrolled off the screen and hand them back
    // with new contents instead of always creating new cells.
    // First, we check to see if ther's a cell available for reuse.
    UITableViewCell *c = [taskTable dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!c) {
        // ... and only allocate a new cell if none are available
        c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:@"Cell"];
    }
    
    // Then we (re)configure the cell based on the model object,
    // in this case our todoItems array
    NSString *item = [tasks objectAtIndex:[indexPath row]];
    [[c textLabel] setText:item];
    
    // and hand back to the table view the properly configured cell
    return c;
}

- (void)addTask:(id)sender
{
    // Get the to-do item
    NSString *t = [taskField text];
    
    // Quit here if taskField is empty
    if ([t isEqualToString:@""]) {
        return;
    }
    
    // Add it to our working array
    [tasks addObject:t];
    // Refresh the table so that the new item shows up
    [taskTable reloadData];
    // And clear out the text field
    [taskField setText:@""];
    // Dismiss the keyboard
    [taskField resignFirstResponder];
}

@end
