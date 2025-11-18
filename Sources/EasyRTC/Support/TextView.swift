import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

class TextView: NativeView {
    #if os(iOS) || os(visionOS) || os(tvOS)
    private class DebugUILabel: UILabel {
        override func drawText(in _: CGRect) {
            let textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
            super.drawText(in: textRect)
        }
    }

    private let _textView: DebugUILabel
    #elseif os(macOS)
    private let _textView: NSTextField
    #endif

    var text: String? {
        get {
            #if os(iOS) || os(visionOS) || os(tvOS)
            _textView.text
            #elseif os(macOS)
            _textView.stringValue
            #endif
        }
        set {
            #if os(iOS) || os(visionOS) || os(tvOS)
            _textView.text = newValue
            #elseif os(macOS)
            _textView.stringValue = newValue ?? ""
            #endif
        }
    }

    override init(frame: CGRect) {
        #if os(iOS) || os(visionOS) || os(tvOS)
        _textView = DebugUILabel(frame: .zero)
        _textView.numberOfLines = 0
        _textView.adjustsFontSizeToFitWidth = false
        _textView.lineBreakMode = .byWordWrapping
        _textView.textColor = .white
        _textView.font = .systemFont(ofSize: 11)
        _textView.backgroundColor = .clear
        _textView.textAlignment = .right
        #elseif os(macOS)
        _textView = NSTextField()
        _textView.drawsBackground = false
        _textView.isBordered = false
        _textView.isEditable = false
        _textView.isSelectable = false
        _textView.font = .systemFont(ofSize: 11)
        _textView.alignment = .right
        #endif

        super.init(frame: frame)
        addSubview(_textView)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func performLayout() {
        super.performLayout()
        _textView.frame = bounds
    }
}
