//
//  DTAlertViewContainer.m
//  DTAlertViewContainer
//
//  Created by Dmitrii Titov on 01.06.17.
//  Copyright © 2017 Dmitriy Titov. All rights reserved.
//

#import "DTAlertViewContainerController.h"

@interface DTAlertViewContainerController() <DTAlertViewContainerProtocol>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGR;
@property (nonatomic, assign) CGRect keyboardFrame;
@property (nonatomic, assign) BOOL reactObKeyboardAppearence;

@end

@implementation DTAlertViewContainerController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeProperties];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeProperties];
    }
    return self;
}

- (void)initializeProperties {
    self.scrollView = [[UIScrollView alloc]init];
    self.backgroundView = [[UIView alloc]init];
    self.tapGR = [[UITapGestureRecognizer alloc]init];
    self.reactObKeyboardAppearence = YES;
    self.positionBinding = DTAlertViewPositionBindingCentre;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupDefaults];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.backgroundView.alpha = 0;
    self.alertView.alpha = self.appearenceAnimation == DTAlertViewContainerAppearenceTypeFade ? 0 : 0.5;
    [self layoutBeforeAppear];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:self.appearenceDuration
                          delay:0
                        options:self.animationOptions
                     animations:^{
                         self.backgroundView.alpha = 0.5;
                         self.alertView.alpha = 1;
                         [self layoutViews];
                     }
                     completion:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
    self.backgroundView.frame = self.view.bounds;
}

- (void)setupDefaults {
    self.minimumVerticalOffset = 15;
    self.horisontalOffset = 15;
    self.appearenceDuration = 0.4;
    self.animationOptions = UIViewAnimationOptionCurveEaseInOut;
    self.backgroundView.backgroundColor = [UIColor blueColor];
}

- (void)setAlertViewContainsTableView:(BOOL)alertViewContainsTableView {
    _alertViewContainsTableView = alertViewContainsTableView;
    if (alertViewContainsTableView && [self.scrollView.subviews containsObject:self.alertView]) {
        [self.alertView removeFromSuperview];
        [self.view addSubview:self.alertView];
    }else if (!alertViewContainsTableView && [self.view.subviews containsObject:self.alertView]) {
        [self.alertView removeFromSuperview];
        [self.scrollView addSubview:self.alertView];
    }
}

#pragma mark - Present

- (void)presentOverVC:(UIViewController *)vc alertView:(UIView<DTAlertViewProtocol> *)alertView appearenceAnimation:(DTAlertViewContainerAppearenceType)appearenceAnimation completion:(void (^ __nullable)(void))completion {
    if (!vc || !alertView) {
        return;
    }
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    alertView.delegate = self;
    self.alertView = alertView;
    if (self.alertViewContainsTableView) {
        [self.view addSubview:alertView];
    }else{
        [self.scrollView addSubview:alertView];
    }
    self.appearenceAnimation = appearenceAnimation;
    [vc presentViewController:self animated:false completion:completion];
}

#pragma mark - Setup UI

- (void)setupUI {
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.alertView];
    [self.scrollView addGestureRecognizer:self.tapGR];
    [self.tapGR addTarget:self action:@selector(backgroundPressed)];
}

#pragma mark - Layout

- (void)layoutViews {
    CGRect selfFrame = ^CGRect(void) {/*
        if (CGSizeEqualToSize(destinationSize, CGSizeZero)) {*/
            return self.view.frame;
        /*}else{
            return CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,
                              destinationSize.width, destinationSize.height);
        }*/
    }();
    self.scrollView.frame = CGRectMake(0, 0, selfFrame.size.width, selfFrame.size.height);
    self.backgroundView.frame = CGRectMake(0, 0, selfFrame.size.width, selfFrame.size.height);
    CGFloat keyboardHeightInScreen = [self keyboardHeightInScreen];
    CGFloat viewHeight = self.alertView.requiredHeight;
    CGFloat contentHeight = ^CGFloat(void) {
        if (self.view.frame.size.height - self.minimumVerticalOffset * 2 - viewHeight - keyboardHeightInScreen < 0) {
            return self.minimumVerticalOffset * 2 + viewHeight + keyboardHeightInScreen;
        }else{
            return selfFrame.size.height + 1;
        }
    }();
    CGFloat contentWidth = selfFrame.size.width;
    CGFloat alertYOrigin = ^CGFloat(void) {
        switch (self.positionBinding) {
            case DTAlertViewPositionBindingTop:
                return 0;
            case DTAlertViewPositionBindingBottom:
                if (keyboardHeightInScreen > 0) {
                    return self.keyboardFrame.origin.y - viewHeight;
                }else{
                    return contentHeight - viewHeight;
                }
            default:
                if (keyboardHeightInScreen > 0) {
                    return (contentHeight - viewHeight - keyboardHeightInScreen) / 2;
                }else{
                    return (contentHeight - viewHeight) / 2;
                }
        }
    }();
    CGFloat alertXOrigin = ^CGFloat(void) {
        switch (self.positionBinding) {
            case DTAlertViewPositionBindingLeft:
                return 0;
            default:
                return self.horisontalOffset;
        }
    }();
    CGFloat alertWidth = ^CGFloat(void) {
        switch (self.positionBinding) {
            case DTAlertViewPositionBindingLeft:
            case DTAlertViewPositionBindingRight:
                return contentWidth - self.horisontalOffset;
            default:
                return contentWidth - self.horisontalOffset * 2;
        }
    }();
    self.scrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
    self.alertView.frame = CGRectMake(alertXOrigin, alertYOrigin, alertWidth, viewHeight);
    [self focus];
}

- (void)layoutBeforeAppear {
    self.backgroundView.frame = self.view.bounds;
    self.scrollView.frame = self.view.bounds;
    CGFloat viewHeight = self.alertView.requiredHeight;
    CGFloat viewWidth = self.view.frame.size.width - self.horisontalOffset * 2;
    CGFloat contentHeight = ^CGFloat(void) {
        if ([UIScreen mainScreen].bounds.size.height - self.minimumVerticalOffset * 2 - viewHeight < 0) {
            return self.minimumVerticalOffset * 2 + viewHeight;
        }else{
            return [UIScreen mainScreen].bounds.size.height + 1;
        }
    }();
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, contentHeight);
    CGPoint alertViewOrigin = ^CGPoint(void) {
        CGPoint defaultOrigin = CGPointMake(self.horisontalOffset, (self.scrollView.contentSize.height - viewHeight) / 2);
        switch (self.appearenceAnimation) {
            case DTAlertViewContainerAppearenceTypeFromTop:
                return CGPointMake(defaultOrigin.x, -viewHeight);
            case DTAlertViewContainerAppearenceTypeFromBottom:
                return CGPointMake(defaultOrigin.x, self.scrollView.contentSize.height);
            case DTAlertViewContainerAppearenceTypeFromLeft:
                return CGPointMake(- viewWidth, defaultOrigin.y);
            case DTAlertViewContainerAppearenceTypeFromRight:
                return CGPointMake(self.scrollView.contentSize.width, defaultOrigin.y);
            case DTAlertViewContainerAppearenceTypeFade:
                return defaultOrigin;
        }
        return CGPointZero;
    }();
    
    self.alertView.frame = CGRectMake(alertViewOrigin.x, alertViewOrigin.y,
                                      viewWidth, viewHeight);
}

- (float)keyboardHeightInScreen {
    return fminf(self.keyboardFrame.size.height, [UIScreen mainScreen].bounds.size.height - self.keyboardFrame.origin.y);
}

#pragma mark - Actions

- (void)backgroundPressed {
    CGPoint locationInScrollView = [self.tapGR locationInView:self.scrollView];
    if (locationInScrollView.x > self.alertView.frame.origin.x &&
        locationInScrollView.x < CGRectGetMaxX(self.alertView.frame) &&
        locationInScrollView.y > self.alertView.frame.origin.y &&
        locationInScrollView.y < CGRectGetMaxY(self.alertView.frame))
        return;
    [self.alertView backgroundPressed];
}

#pragma mark - DTAlertViewDelegate

- (void)dismiss {
    [UIView animateWithDuration:self.appearenceDuration
                          delay:0
                        options:self.animationOptions
                     animations:^{
                         self.alertView.alpha = self.appearenceAnimation == DTAlertViewContainerAppearenceTypeFade ? 0 : 0.5;
                         self.backgroundView.alpha = 0;
                         [self layoutBeforeAppear];
                     }
                     completion:^(BOOL finished) {
                         if (self.dismissAction)
                             self.dismissAction();
                         [self dismissViewControllerAnimated:NO completion:nil];
                     }];
}

- (void)layoutAlertViewAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:self.appearenceDuration
                              delay:0
                            options:self.animationOptions
                         animations:^{
                             [self layoutViews];
                             [self.alertView layoutIfNeeded];
                         }
                         completion:nil];
    }else{
        [self layoutViews];
    }
}

- (void)focus {
    if (!self.alertView.needToFocus) { return; }
    CGFloat bottomSpace = 5;
    CGFloat maxYCoordToFocus = self.alertView.frame.origin.y + CGRectGetMaxY(self.alertView.frameToFocus) + bottomSpace;
    CGFloat spaceWithNoKeyboard = self.view.frame.size.height - [self keyboardHeightInScreen];
    if (maxYCoordToFocus > self.scrollView.contentOffset.y + spaceWithNoKeyboard)
        [self.scrollView setContentOffset:CGPointMake(0, maxYCoordToFocus - spaceWithNoKeyboard) animated:NO];
}

- (void)performTextInputSwitch:(void (^)(void))switchAction {
    self.reactObKeyboardAppearence = NO;
    if (switchAction)
        switchAction();
    self.reactObKeyboardAppearence = YES;
    [self layoutViews];
}

#pragma mark - Observe Notifications

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    if (!self.reactObKeyboardAppearence || !notification.userInfo[UIKeyboardFrameEndUserInfoKey]) {
        return;
    }
    CGRect destinationFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = ^NSTimeInterval(void) {
        if (notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]) {
            return [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        }else{
            return 0.2;
        }
    }();
    
    UIViewAnimationOptions animationOptions = ^NSTimeInterval(void) {
        if (notification.userInfo[UIKeyboardAnimationCurveUserInfoKey]) {
            return [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        }else{
            return UIViewAnimationOptionCurveLinear;
        }
    }();
    self.keyboardFrame = destinationFrame;
    [UIView animateWithDuration:duration
                          delay:0
                        options:animationOptions
                     animations:^{
                         [self layoutViews];
                     }
                     completion:nil];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self layoutViews];
    }
                                 completion:nil
];
}

@end
