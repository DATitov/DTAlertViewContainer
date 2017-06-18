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

typedef NS_ENUM(NSUInteger, DTAlertViewPositionBinding) {
    DTAlertViewPositionBindingCentre,
    DTAlertViewPositionBindingTop,
    DTAlertViewPositionBindingBottom,
    DTAlertViewPositionBindingLeft,
    DTAlertViewPositionBindingRight
};

@interface DTAlertViewContainerController : UIViewController

//  scrollView:
//  This scrollView contains AlertView
@property (nonatomic, strong, readonly, nonnull) UIScrollView *scrollView;
//  alertView:
//  Your ALertView. Have to conform DTAlertViewProtocol
@property (nonatomic, strong, readonly, nonnull) UIView<DTAlertViewProtocol> *alertView;
//  backgroundView:
//  Located below scrollView. You can remove blure effect by configureing this property
@property (nonatomic, strong, nonnull) UIVisualEffectView *backgroundView;

@property (nonatomic, assign) DTAlertViewContainerAppearenceType appearenceAnimation;
@property (nonatomic, assign) DTAlertViewPositionBinding positionBinding;

//  minimumVerticalOffset:
//  The spaces on top and on bottom of your AlertView will be equal or bigger when minimumVerticalOffset
@property (nonatomic, assign) CGFloat minimumVerticalOffset;
//  horisontalOffset:
//  For position bindings Top/Centre/Bottom: it is the leading and trailing spaces of your AlertView
//  For position bindings Left/Right: leading space = 0/horisontalOffset and trailing space = horisontalOffset/0
@property (nonatomic, assign) CGFloat horisontalOffset;
//  appearenceDuration:
//  Duration of presenting, dismissing and layout of AlertView
@property (nonatomic, assign) CGFloat appearenceDuration;
//  animationOptions:
//  Native animation options
@property (nonatomic, assign) UIViewAnimationOptions animationOptions;
//  alertViewContainsTableView:
//  Use it if youtr AlertView contains UITableView.
@property (nonatomic, assign) BOOL alertViewContainsTableView;
//  backgroundAlpha:
//  Alpha of backgroundView whet it is presented. Default is 0.95
@property (nonatomic, assign) CGFloat backgroundAlpha;

//  dismissAction:
//  Action called on "dismiss" method being completed. After Dismissing animation
@property (nonatomic, copy, nullable) void (^dismissAction)(void);

//  vc:
//  The UIViewController what will be on background
//  alertView:
//  Your ALertView. Have to conform DTAlertViewProtocol
//  appearenceAnimation:
//  Duration of presenting, dismissing and layout of AlertView
//  completion:
//  Param of native "presentViewController: animated: completion:] method"

- (void)presentOverVC:(nonnull UIViewController *)vc
            alertView:(nonnull UIView<DTAlertViewProtocol> *)alertView
  appearenceAnimation:(DTAlertViewContainerAppearenceType)appearenceAnimation
           completion:(void (^ __nullable)(void))completion;

@end
