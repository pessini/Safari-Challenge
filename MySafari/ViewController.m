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
@property (weak, nonatomic) IBOutlet UIButton *goBackButton;
@property (weak, nonatomic) IBOutlet UIButton *goForwardButton;

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

    if (![self.webView canGoBack])
    {
        self.goBackButton.enabled = NO;
    }
    else
    {
        self.goBackButton.enabled = YES;
    }

    if (![self.webView canGoForward])
    {
        self.goForwardButton.enabled = NO;
    }
    else
    {
        self.goForwardButton.enabled = YES;
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.spinner stopAnimating];
}

#pragma mark -UITextField

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField.text hasPrefix:@"http://"]) {
        textField.text = [NSString stringWithFormat:@"http://%@", textField.text];
    }

    [self loadUrlRequestFromString:textField.text];
    return true;
}

#pragma mark IBAction

- (IBAction)onBackButtonPressed:(UIButton *)sender
{
    [self.webView goBack];
}

- (IBAction)onForwardButtonPressed:(UIButton *)sender
{
    [self.webView goForward];
}

- (IBAction)onStopLoadingButtonPressed:(UIButton *)sender
{
    [self.webView stopLoading];
}

- (IBAction)onReloadButtonPressed:(UIButton *)sender
{
    [self.webView reload];
}

#pragma mark -Helpers Methods

-(void)loadUrlRequestFromString:(NSString *)string
{
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


@end
