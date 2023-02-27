//
//  ViewController.swift
//  TestNSStackView
//
//  Created by Wasim Lorgat on 2023/02/25.
//

import Cocoa

class BorderedTextView: NSTextView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let path = NSBezierPath(rect: bounds)
        NSColor.red.setStroke()
        path.stroke()
    }
    
    override var intrinsicContentSize: NSSize {
        guard let textContainer = textContainer, let layoutManager = layoutManager else { return super.intrinsicContentSize }
        layoutManager.ensureLayout(for: textContainer)
        return layoutManager.usedRect(for: textContainer).size
    }

    override func didChangeText() {
        super.didChangeText()
        invalidateIntrinsicContentSize()
        enclosingScrollView?.invalidateIntrinsicContentSize()
    }
}

class TextEditor: NSScrollView {
    public var textView: BorderedTextView
    
    override public init(frame frameRect: NSRect) {
        textView = BorderedTextView()
        super.init(frame: frameRect)
        let scrollView = self
        let textView = scrollView.textView
        
        scrollView.setContentCompressionResistancePriority(.fittingSizeCompression, for: .vertical)
        
        scrollView.borderType = .noBorder
        scrollView.hasVerticalScroller = false
        scrollView.hasHorizontalScroller = false
        scrollView.horizontalScrollElasticity = .automatic
        scrollView.verticalScrollElasticity = .none
                
        textView.isRichText = false
        textView.minSize = NSSize(width: 0, height: scrollView.bounds.height)
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = true
        textView.textContainer?.widthTracksTextView = false
        textView.textContainer?.heightTracksTextView = false
        textView.textContainer?.size = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        
        scrollView.documentView = textView
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.setContentCompressionResistancePriority(.required, for: .vertical)
        textView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(greaterThanOrEqualTo: scrollView.trailingAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: NSSize {
        return NSSize(width: -1, height: textView.intrinsicContentSize.width)
    }
}

class StackView: NSStackView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        orientation = .vertical
        distribution = .gravityAreas
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let stackView = StackView()
        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        stackView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 600).isActive = true
                
        let te1 = TextEditor()
        let te2 = TextEditor()
        let te3 = TextEditor()
        te2.textView.isEditable = false
        te3.textView.isEditable = false
        te2.textView.string = "First\nSecond\nThird"
        te3.textView.string = "This is a really long line. This is a really long line. This is a really long line. This is a really long line. This is a really long line. This is a really long line."
        
        stackView.addArrangedSubview(te1)
        stackView.addArrangedSubview(te2)
        stackView.addArrangedSubview(te3)
        
        te1.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        te2.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        te3.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }
}
