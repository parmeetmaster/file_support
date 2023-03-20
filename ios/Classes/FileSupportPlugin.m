#import "FileSupportPlugin.h"
#if __has_include(<file_support/file_support-Swift.h>)
#import <file_support/file_support-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "file_support-Swift.h"
#endif

@implementation FileSupportPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFileSupportPlugin registerWithRegistrar:registrar];
}
@end
