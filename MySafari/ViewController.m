//
//  ViewController.m
//  MySafari
//
//  Created by Leandro Pessini on 3/11/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *goBackButton;
@property (weak, nonatomic) IBOutlet UIButton *goForwardButton;
@property (weak, nonatomic) IBOutlet UIButton *stopLoadingButton;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;

@property (weak, nonatomic) IBOutlet UINavigationItem *addressBarNavigationItem;


@property CGPoint pointNow;

- (void)loadUrlRequestFromString:(NSString *)string;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.addressBarNavigationItem.title = @"My Safari App";

    self.goBackButton.enabled = NO;
    self.goForwardButton.enabled = NO;
    self.stopLoadingButton.enabled = NO;
    self.reloadButton.enabled = NO;

    // delegate textField programmatically instead of on storyboard like the webView
    self.urlTextField.delegate = self;

    self.webView.scrollView.delegate = self;

}

#pragma mark -UIWebView

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.spinner startAnimating];

    self.stopLoadingButton.enabled = YES;
    self.reloadButton.enabled = YES;

}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.spinner stopAnimating];

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

    self.reloadButton.enabled = YES;
    self.stopLoadingButton.enabled = NO;

    NSString* title = [self.webView stringByEvaluatingJavaScriptFromString: @"document.title"];
    self.addressBarNavigationItem.title = title;
}

#pragma mark -UIScrollView

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.pointNow = scrollView.contentOffset;

    // change the opacity of the textField
    self.urlTextField.backgroundColor = [UIColor clearColor];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    // checking if it is scrolling up or down
    // down - show textfield
    if (scrollView.contentOffset.y <= self.pointNow.y) {
        self.urlTextField.hidden = NO;
        self.urlTextField.backgroundColor = [UIColor whiteColor];
    // up - hide textField
    } else if (scrollView.contentOffset.y > self.pointNow.y) {
        self.urlTextField.hidden = YES;
    }
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
    [self.spinner stopAnimating];
}

- (IBAction)onReloadButtonPressed:(UIButton *)sender
{
    [self.webView reload];
}

- (IBAction)onPlusButtonPressed:(UIButton *)sender
{
    UIAlertView *alert = [UIAlertView new];
    alert.title = @"YAY New Feature";
    alert.message = @"Coming Soon!";
    [alert addButtonWithTitle:@"Ok"];
    [alert show];
}

#pragma mark -Helpers Methods

-(void)loadUrlRequestFromString:(NSString *)string
{
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


@end
