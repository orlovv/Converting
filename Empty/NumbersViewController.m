//
//  ViewController.m
//  Empty
//
//  Created by Vladimir Orlov on 27.09.16.
//  Copyright © 2016 Vladimir Orlov. All rights reserved.
//

#import "NumbersViewController.h"
#import "TextViewController.h"
#import "NumberConverter.h"

@interface NumbersViewController ()

@property (strong, nonatomic) NSArray *stringKeys;
@property (strong, nonatomic) NSMutableArray *numberKeys;

@end

@implementation NumbersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"input" ofType:@"plist"];
    self.inputDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    self.stringKeys = [self.inputDictionary allKeys];
    self.numberKeys = [NSMutableArray arrayWithCapacity:[self.stringKeys count]];
    [self convertStringArray:self.stringKeys];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)convertStringArray:(NSArray *)stringArray {
    self.numberKeys = [NSMutableArray array];
    for (NSString *string in self.stringKeys) {
        NSNumber *number = [NSNumber numberWithLongLong:[string longLongValue]];
        [self.numberKeys addObject:number];
    }
    return self.numberKeys;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.stringKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self.stringKeys objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showText"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TextViewController *destViewController = segue.destinationViewController;
        destViewController.text = [NumberConverter convert:[[self.numberKeys objectAtIndex:indexPath.row] longLongValue]];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Actions

- (IBAction)addNumber:(UIBarButtonItem *)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Enter new number"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.delegate = self;
        textField.placeholder = @"Number";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.borderStyle = UITextBorderStyleNone;
    }];
    
    UIAlertAction *okAction = [UIAlertAction
                            actionWithTitle:@"OK"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * _Nonnull action) {
                                NSMutableArray *tempArray = nil;
                                if (self.stringKeys) {
                                    tempArray = [NSMutableArray arrayWithArray:self.stringKeys];
                                }
                                
                                NSInteger newIndex = [self.stringKeys count];
                                NSString *newString = [[alertController.textFields firstObject] text];
                                [tempArray insertObject:newString atIndex:newIndex];
                                self.stringKeys = tempArray;
                                self.numberKeys = nil;
                                [self convertStringArray:self.stringKeys];
                                
                                [self.tableView beginUpdates];
                                NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:newIndex inSection:0];
                                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                                [self.tableView endUpdates];
                                [self.tableView reloadData];
                            }];
    UIAlertAction *cancelAction = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * _Nonnull action) {
                               }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return [resultString length] <= 18;
}

@end
