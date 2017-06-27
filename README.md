# DTAlertViewContainer

This is a flexible, animated container for any View you want to present as a Alert View.
Every time you need a custom AlertView you need to create custom ViewController ad present it modally. 
It takes time to configure all layout, animations, perfomance. 
Let DTAlertViewContainer do it for you
Just create your view and call DTAlertViewContainer to present it

---
## Abilities
DTAlertViewContainer do the most routine work related to presenting Alerts
- Present any `UIView`. 
- Present big alerts. DTAlertViewContainer adding AlertView on a `UIScrollView` so does not metter what height your AlerView has
- Input text with yout AlertView. Sometimes if user taps on text field keyboard covers it. This situation causes discomfort. DTAlertViewContainer observes keyboard appearence so where is no need to worry about yout text field being visible
- Focus on space area. Even if you have implemented keyboard observation where is a need to focus on text field. DTAlertViewContainer will scroll to the frame you've pointed to focus
- Bind AlerView to Top, Bottom or Centre. This gives you ability to present AlertView as a Notification, Action Shit or an native Alert
- Configure bckground. Make blur light or dark. Or even remove it

###### It is easy to present alerts like ActionSheet or Notification

![](https://dl.dropboxusercontent.com/content_link/RNHiLOO8qm9erfScxFA0p2Y6SVoOYOCJXSIirnvRo7MBnl7rNTFYXUrdbYLDUyIP/file?dl=0&duc_id=q16kgmVNRrjazGi17N699zpTa6UGSWskqH1SMj5L2AfLoMvfGyJ85cXepE7mq7Fh&raw=1&size=2048x1536&size_mode=3)  ![](https://dl.dropboxusercontent.com/content_link/crLNvokJtDRhYYiZDEF5eBev40VdqLS31LzsoBh8GYidfmCs9pnwTZGyyop6isia/file?dl=0&duc_id=68eQDV3KFtYJwUbJM1cXQ2KG5j1GqDIh2rXexUjZvRMWBVCbmiIEyYnftDMY90JM&raw=1&size=2048x1536&size_mode=3) ![](https://dl.dropboxusercontent.com/content_link/t3Sj0b8MFSrF8vzhTGZeT11tw9NT8OLLPC3RL7tKfwMFR5nRifXp2U7I4eiE8b1Y/file?dl=0&duc_id=zAkIVNpXlfT9xihfxxubWWkUe6q5Qvz4gRGzxpa9mHobQFb5rcBI9QsUKJjj0hnY&raw=1&size=2048x1536&size_mode=3)

---
## Installation
Using CocoaPods:
```ruby
pod 'DTAlertViewContainer'
```

---
## Usage
> Note: your AlertView must conform to DTAlertViewProtocol!
### Appearence
#### Objective-C
```objective-c
DTAlertViewContainerController *container = [[DTAlertViewContainerController alloc] init];
MyAlertView *alertView = [[MyAlertView alloc] init];
// Some configurations
[container presentOverVC:currentViewController alertView:alertView appearenceAnimation:DTAlertViewContainerAppearenceTypeFromTop completion:nil];
```
#### Swift
```swift
let container = DTAlertViewContainerController()
let alertView = MyAlertView()
// Some configurations
container.presentOverVC(mainNavigationController.topViewController, alert: alertView, appearenceAnimation: .fromTop, completion: nil)
```
Also you can configure:
- animationOptions. This is how alertView will appear: from top, bottom ... , from centre 0 alpha
- appearenceDuration
- dismissAction. Callback called on container being dismissed
### If your AlertView have several Text input sources
If you have, for example, two `UITextField` to switch firstResponce from first to second on Return button pressed you need to execute it's code as param of `DTAlertViewContainerController` method `performTextInputSwitch:`
```objective-c
[container performTextInputSwitch:^{
    [destinationTextField becomeFirstResponder];
}];
```
When input source switches keyboard hides and immediately appears again. It forces Container to layout twice with different kayboard frames.
Using this method you will avoid text fields "jumping" on switching. Be
### Delegate
Interact with Container via `DTAlertViewContainerProtocol`:
- dismiss it
- force Container's layout
- force it to focus
- execute text input source switch
### Dismissing
Just call `dismiss` method of Container to dismiss it. 
It will also call `dismissAction`

---
## Requirements
iOS 10
Older versions support are coming soon
