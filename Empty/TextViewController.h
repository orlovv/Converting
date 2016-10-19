//
//  TextViewController.h
//  Empty
//
//  Created by Vladimir Orlov on 28.09.16.
//  Copyright © 2016 Vladimir Orlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) NSString *text;

@end
