//
//  com_chunyu_ViewController.m
//  TestNewSocialFramework
//
//  Created by LeiZhang on 9/28/12.
//  Copyright (c) 2012 LeiZhang. All rights reserved.
//

#import "com_chunyu_ViewController.h"
#import <Social/Social.h>


// Stackoverflow教程
// http://stackoverflow.com/questions/12503287/tutorial-for-slcomposeviewcontroller-sharing


#define CONTENT_TO_SHARE (@"测试通过iOS 6的Social Framework发布内容。")

enum {
    kComposeToFacebook = 0,
    kComposeToTwitter,
    kComposeToWeibo
};

@implementation com_chunyu_ViewController

@synthesize shareToFacebook = _shareToFacebook;
@synthesize shareToTwitter = _shareToTwitter;
@synthesize shareToWeibo = _shareToWeibo;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL isAvailableForTwitter = [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
    BOOL isAvailableForFacebook = [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook];
    BOOL isAvailableForSina = [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
    
    _shareToFacebook.tag = kComposeToFacebook;
    _shareToTwitter.tag = kComposeToTwitter;
    _shareToWeibo.tag = kComposeToWeibo;
    
    _shareToTwitter.enabled = isAvailableForTwitter;
    _shareToFacebook.enabled = isAvailableForFacebook;
    _shareToWeibo.enabled = isAvailableForSina;
	
    [_shareToWeibo addTarget:self
                      action:@selector(shareContent:)
            forControlEvents:UIControlEventTouchUpInside];

    [_shareToTwitter addTarget:self
                        action:@selector(shareContent:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [_shareToFacebook addTarget:self
                      action:@selector(shareContent:)
            forControlEvents:UIControlEventTouchUpInside];
}


- (IBAction)shareContent:(id)sender {
    // 查看点击了哪个按钮
    NSLog(@"%d", ((UIButton*)sender).tag);
    NSString* serviceType;
    switch (((UIButton*)sender).tag) {
        case 0: {
            serviceType = SLServiceTypeFacebook;
        }
            break;
        case 1: {
            serviceType = SLServiceTypeTwitter;
        }
            break;
            
        case 2: {
            serviceType = SLServiceTypeSinaWeibo;
        }
            break;
            
        default:
            break;
    }
    
    // 创建一个SLComposeViewController
    SLComposeViewController* controller =
        [SLComposeViewController composeViewControllerForServiceType:serviceType];
    
    // 添加Image
    [controller addImage:[UIImage imageNamed:@"RupertMurdoch.jpeg"]];

    // 添加URL
    [controller addURL:[NSURL URLWithString:@"www.chunyu.me"]];
    
    // 添加初始的Text
    [controller setInitialText:CONTENT_TO_SHARE];
    
    SLComposeViewControllerCompletionHandler myBlock =
        ^(SLComposeViewControllerResult result) {
        if (result == SLComposeViewControllerResultCancelled){
            NSLog(@"cancelled!");
        } else {
            NSLog(@"done!");
        }
        [controller dismissViewControllerAnimated:YES completion:Nil];
    };

    controller.completionHandler = myBlock;

    [self presentViewController:controller
                       animated:YES
                     completion:Nil];
}

@end
