#import "CameraScanQrPlugin.h"
#if __has_include(<camera_scan_qr/camera_scan_qr-Swift.h>)
#import <camera_scan_qr/camera_scan_qr-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "camera_scan_qr-Swift.h"
#endif

@implementation CameraScanQrPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCameraScanQrPlugin registerWithRegistrar:registrar];
}
@end
