import SwiftUI
import WaveKitExampleUI
import Foundation
import ObjectiveC

#if targetEnvironment(simulator)
extension Bundle {
    private static let swizzleBundleIdentifier: Void = {
        let cls = Bundle.self
        let originalSelector = #selector(getter: cls.bundleIdentifier)
        let swizzledSelector = #selector(getter: cls.swizzled_bundleIdentifier)
        
        guard let originalMethod = class_getInstanceMethod(cls, originalSelector),
              let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector) else {
            return
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()
    
    @objc private var swizzled_bundleIdentifier: String? {
        // Since we exchanged implementations, this calls the original method
        if let original = self.swizzled_bundleIdentifier {
            return original
        }
        if self == Bundle.main {
            return "com.example.WaveKitExample"
        }
        return nil
    }
    
    static func enableSimulatorBundleIdWorkaround() {
        _ = swizzleBundleIdentifier
    }
}
#endif

@main
struct WaveKitExampleApp: App {
    init() {
        #if targetEnvironment(simulator)
        Bundle.enableSimulatorBundleIdWorkaround()
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
