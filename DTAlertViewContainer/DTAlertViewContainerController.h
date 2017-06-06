//
//  DTAlertViewContainer.h
//  DTAlertViewContainer
//
//  Created by Dmitrii Titov on 01.06.17.
//  Copyright © 2017 Dmitriy Titov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTAlertViewContainerProtocols.h"

typedef NS_ENUM(NSUInteger, DTAlertViewContainerAppearenceType) {
    DTAlertViewContainerAppearenceTypeFromTop,
    DTAlertViewContainerAppearenceTypeFromBottom,
    DTAlertViewContainerAppearenceTypeFromLeft,
    DTAlertViewContainerAppearenceTypeFromRight,
    DTAlertViewContainerAppearenceTypeFade,
};

@interface DTAlertViewContainerController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView<DTAlertViewProtocol> *alertView;
@property (nonatomic, assign) DTAlertViewContainerAppearenceType appearenceAnimation;

@property (nonatomic, assign) CGFloat minimumVerticalOffset;
@property (nonatomic, assign) CGFloat horisontalOffset;
@property (nonatomic, assign) CGFloat appearenceDuration;
@property (nonatomic, assign) UIViewAnimationOptions animationOptions;
@property (nonatomic, assign) BOOL alertViewContainsTableView;


- (void)presentOverVC:(UIViewController *)vc alertView:(UIView<DTAlertViewProtocol> *)alertView appearenceAnimation:(DTAlertViewContainerAppearenceType)appearenceAnimation completion:(void (^ __nullable)(void))completion;
//- (void)setAlertViewContainsTableView:(BOOL)alertViewContainsTableView;

@end
