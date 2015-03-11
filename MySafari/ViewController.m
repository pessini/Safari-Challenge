//
//  ViewController.m
//  MySafari
//
//  Created by Leandro Pessini on 3/11/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (void)loadUrlRequestFromString:(NSString *)string;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    // delegate textField programmatically instead of on storyboard like the webView
    self.urlTextField.delegate = self;

}

#pragma mark -UIWebView

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.spinner startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.spinner stopAnimating];
}

#pragma mark -UITextField

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loadUrlRequestFromString:textField.text];
    return true;
}

#pragma mark -Helpers Methods

-(void)loadUrlRequestFromString:(NSString *)string
{
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


@end
