//
//  ViewController.swift
//  TestNSStackView
//
//  Created by Wasim Lorgat on 2023/02/25.
//

import Cocoa

class TextView: NSTextView {
    override var intrinsicContentSize: NSSize {
        guard let textContainer = textContainer, let layoutManager = layoutManager else { return super.intrinsicContentSize }
        layoutManager.ensureLayout(for: textContainer)
        return layoutManager.usedRect(for: textContainer).size
    }

    override func didChangeText() {
        super.didChangeText()
        invalidateIntrinsicContentSize()
    }
}

class Scroller: NSScroller {
    override class var isCompatibleWithOverlayScrollers: Bool { true }
}

class TextEditor: NSView {
    public var scrollView: NSScrollView
    public var textView: NSTextView
    
    override init(frame frameRect: NSRect) {
        scrollView = NSScrollView()
        textView = TextView()
        super.init(frame: frameRect)
        addSubview(scrollView)
        
        scrollView.autohidesScrollers = true
        scrollView.hasVerticalScroller = false
        scrollView.hasHorizontalScroller = true
        scrollView.horizontalScrollElasticity = .automatic
        scrollView.verticalScrollElasticity = .none
        
        let scroller = Scroller()
        scrollView.horizontalScroller = scroller
        scroller.scrollerStyle = .overlay
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

        scrollView.borderType = .lineBorder
        scrollView.drawsBackground = true
        scrollView.wantsLayer = true
        scrollView.layer?.cornerRadius = 3
        scrollView.backgroundColor = .clear
        textView.drawsBackground = false
        
        textView.isRichText = false
        textView.minSize = NSSize(width: 0, height: scrollView.bounds.height)
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = true
        textView.textContainer?.widthTracksTextView = false
        textView.textContainer?.heightTracksTextView = false
        textView.textContainer?.size = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        
        // Wrap the text view in a container so that we can pad the top and bottom of the text view. I couldn't get textContainerInset to work for this.
        let textViewContainer = NSView()
        textViewContainer.addSubview(textView)

        scrollView.documentView = textViewContainer

        textViewContainer.translatesAutoresizingMaskIntoConstraints = false
        textViewContainer.translatesAutoresizingMaskIntoConstraints = false
        textViewContainer.leadingAnchor.constraint(equalTo: scrollView.contentView.leadingAnchor).isActive = true
        textViewContainer.trailingAnchor.constraint(greaterThanOrEqualTo: scrollView.contentView.trailingAnchor).isActive = true
        textViewContainer.topAnchor.constraint(equalTo: scrollView.contentView.topAnchor).isActive = true
        textViewContainer.bottomAnchor.constraint(equalTo: scrollView.contentView.bottomAnchor).isActive = true

        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leadingAnchor.constraint(equalTo: textViewContainer.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: textViewContainer.trailingAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: textViewContainer.topAnchor, constant: 5).isActive = true
        textView.bottomAnchor.constraint(equalTo: textViewContainer.bottomAnchor, constant: -5).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: NSSize {
        return NSSize(width: -1, height: scrollView.intrinsicContentSize.width)
    }
}

class StackView: NSStackView {
    override func addArrangedSubview(_ view: NSView) {
        super.addArrangedSubview(view)
        view.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
}

class ViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let stackView = StackView()
        stackView.orientation = .vertical
        stackView.distribution = .gravityAreas
        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
                
        let te1 = TextEditor()
        let te2 = TextEditor()
        let te3 = TextEditor()
        te2.textView.string = "First\nSecond\nThird"
        te3.textView.string = "This is a really long line. This is a really long line. This is a really long line. This is a really long line. This is a really long line. This is a really long line.\nThis is a really long line. This is a really long line. This is a really long line. This is a really long line. This is a really long line. This is a really long line."
        
        stackView.addArrangedSubview(te1)
        stackView.addArrangedSubview(te2)
        stackView.addArrangedSubview(te3)
        
        stackView.needsLayout = true
        stackView.needsUpdateConstraints = true
    }
}
