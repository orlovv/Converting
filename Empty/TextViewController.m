//
//  TextViewController.m
//  Empty
//
//  Created by Vladimir Orlov on 28.09.16.
//  Copyright © 2016 Vladimir Orlov. All rights reserved.
//

#import "TextViewController.h"

@interface TextViewController ()

@end

@implementation TextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.detailLabel.text = self.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
