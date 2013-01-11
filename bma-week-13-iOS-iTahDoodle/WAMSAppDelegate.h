//
//  WAMSAppDelegate.h
//  bma-week-13-iOS-iTahDoodle
//
//  Created by Wally on 1/10/13.
//  Copyright (c) 2013 WAMS. All rights reserved.
//

#import <UIKit/UIKit.h>

NSString *docPath(void);

@interface WAMSAppDelegate : UIResponder <UIApplicationDelegate, UITableViewDataSource>
{
    UITableView *taskTable;
    UITextField *taskField;
    UIButton *insertButton;
    
    NSMutableArray *tasks;
}

- (void)addTask:(id)sender;

@property (strong, nonatomic) UIWindow *window;

@end
