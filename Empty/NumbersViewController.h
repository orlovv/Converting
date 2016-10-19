//
//  ViewController.h
//  Empty
//
//  Created by Vladimir Orlov on 27.09.16.
//  Copyright © 2016 Vladimir Orlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumbersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *inputDictionary;

- (IBAction)addNumber:(UIBarButtonItem *)sender;

@end

