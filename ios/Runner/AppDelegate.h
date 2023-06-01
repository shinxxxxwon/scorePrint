//#import "ObjcDef.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

//FlutterMethodChannel *pChannel = nil;

//FlutterMethodChannel *CHANNEL;

@interface AppDelegate : FlutterAppDelegate

- (void)handleScreenshotNotification:(NSNotification *)notification;
-(FlutterMethodChannel*)GetChannel;
- (void)screenshotTaken;


@end
