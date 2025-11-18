import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

#if os(iOS) || os(visionOS) || os(tvOS)
public typealias NativeViewType = UIView
#elseif os(macOS)
public typealias NativeViewType = NSView
#endif

/// A simple abstraction of a View that is native to the platform.
/// When built for iOS this will be a UIView.
/// When built for macOS this will be a NSView.
open class NativeView: NativeViewType {
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    #if os(iOS) || os(visionOS) || os(tvOS)
    override public func layoutSubviews() {
        super.layoutSubviews()
        performLayout()
    }
    #else
    override public func layout() {
        super.layout()
        performLayout()
    }
    #endif

    #if os(macOS)
    // for compatibility with macOS
    public func setNeedsLayout() {
        needsLayout = true
    }
    #endif

    #if os(macOS)
    public func bringSubviewToFront(_ view: NSView) {
        addSubview(view)
    }

    public func insertSubview(_ view: NSView, belowSubview: NSView) {
        addSubview(view, positioned: .below, relativeTo: belowSubview)
    }
    #endif

    open func performLayout() {
        //
    }
}
