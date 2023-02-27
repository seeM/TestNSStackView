//
//  ViewController.swift
//  TestNSStackView
//
//  Created by Wasim Lorgat on 2023/02/25.
//

import Cocoa

class BorderedTextView: NSTextView, NSTextViewDelegate {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer: container)
        delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let path = NSBezierPath(rect: bounds)
        NSColor.white.setStroke()
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
        
//        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.setContentCompressionResistancePriority(.fittingSizeCompression, for: .vertical)
//        textView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        textView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        scrollView.drawsBackground = true
        scrollView.backgroundColor = NSColor(red: 1, green: 0, blue: 0, alpha: 1)
        textView.drawsBackground = true
        textView.backgroundColor = NSColor(red: 0, green: 1, blue: 0, alpha: 1)
        textView.textStorage?.foregroundColor = .white

    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: NSSize {
        return NSSize(width: -1, height: textView.intrinsicContentSize.width)
    }
}

//class StackView: NSStackView {
//    override init(frame frameRect: NSRect) {
//        super.init(frame: frameRect)
//        orientation = .vertical
//        distribution = .gravityAreas
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        let stackView = StackView()
////        view.addSubview(stackView)
//
//        stackView.wantsLayer = true
//        stackView.layer?.backgroundColor = .init(red: 1, green: 0, blue: 0, alpha: 0.2)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
////        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//
//        stackView.heightAnchor.constraint(equalToConstant: 400).isActive = true
//        stackView.widthAnchor.constraint(equalToConstant: 600).isActive = true
                
        let scrollView = TextEditor()
        scrollView.textView.string = "        textView.setContentCompressionResistancePriority(.required, for: .vertical)        textView.setContentCompressionResistancePriority(.required, for: .vertical)"

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.setContentCompressionResistancePriority(.fittingSizeCompression, for: .vertical)
        
        let tv2 = NSTextField(labelWithString: "Hello world 2")
        let tv3 = NSTextField(labelWithString: "Hello world 3")
        
        tv2.drawsBackground = true
        tv3.drawsBackground = true
        

        tv2.backgroundColor = .green
        tv3.backgroundColor = .red
        
//        view.addSubview(tv2)
//        view.addSubview(tv3)
        
//        stackView.addArrangedSubview(scrollView)
//        stackView.addArrangedSubview(tv2)
//        stackView.addArrangedSubview(tv3)
        
//        scrollView.autoresizingMask = [.width]
        
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
//        tv3.translatesAutoresizingMaskIntoConstraints = false
//        tv3.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
//        tv3.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
//
//        tv2.translatesAutoresizingMaskIntoConstraints = false
//        tv2.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
//        tv2.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

