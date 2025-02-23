//
//  JCustomSegmentControl.swift
//  JCustomSegmentControl
//
//  Created by Jaimini Shah on 21/02/25.
//

import Foundation
import UIKit

public class JCustomSegmentControl: UIControl {
    
    // MARK: - Properties
        
    /// Determines if the segment control should scroll when the content exceeds the width.
    @IBInspectable public var isScrollEnabled: Bool = false{
        didSet{
            scrollView.isScrollEnabled = isScrollEnabled
            if isScrollEnabled{
                stackView.distribution = .fill
            } else {
                stackView.distribution = .fillEqually
            }
            self.updateStackViewWidthConstraint()
            self.updateButtonConfiguration()
        }
    }
    /// Comma-separated titles for the segments.
    @IBInspectable public var titleSeparatedbyComma: String = "" {
        didSet {
            titles = titleSeparatedbyComma.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        }
    }
    /// Array of titles for the segments.
    private var titles: [String] = [] {
        didSet {
            setupSegmentComponents()
        }
    }
    /// Index of the currently selected segment.
    @IBInspectable public var selectedSegmentIndex: Int = 0 {
        didSet {
            updateSegmentSelection()
        }
    }
    /// Text color for the segments.
    @IBInspectable public var segmentTextColor: UIColor = .black {
        didSet {
            updateSegmentColors()
        }
    }
    /// Color for the selected segment.
    @IBInspectable public var selectedSegmentColor: UIColor = .blue {
        didSet {
            updateSegmentColors()
        }
    }
    
    // MARK: - Private Properties
    private var selectorLeadingConstraint: NSLayoutConstraint?
    private var selectorWidthConstraint: NSLayoutConstraint?
    private var stackViewWidthConstraint: NSLayoutConstraint?
    private var buttons: [UIButton] = []
    private var selectorView: UIView!
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    // MARK: - Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSetup()
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
}
// MARK: - Setup Methods
extension JCustomSegmentControl {
    /// Initial setup for the segment control.
    private func initSetup(){
        selectorView = UIView()
        selectorView.backgroundColor = selectedSegmentColor
        selectorView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(selectorView)
        configureScrollView()
        configureStackView()
        setupConstraints()
    }
    /// Configures the scroll view.
    private func configureScrollView() {
        scrollView.isScrollEnabled = isScrollEnabled
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
    }
    /// Configures the stack view.
    private func configureStackView() {
        if isScrollEnabled{
            stackView.distribution = .fill
        } else {
            stackView.distribution = .fillEqually
        }
        stackView.spacing = 1
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
    }
    /// Sets up the constraints for the scroll view and stack view.
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        self.updateStackViewWidthConstraint()
    }
    
    // MARK: - Button Setup
        
    /// Sets up the segment components (buttons, selector).
    private func setupSegmentComponents() {
        setupButtons()
        updateSegmentTexts()
        updateSegmentColors()
    }
    /// Creates and sets up the buttons for each segment.
    private func setupButtons() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        for (index, title) in titles.enumerated() {
            let button = createSegmentButton(title: title, index: index, isFlexible: isScrollEnabled)
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
        guard !buttons.isEmpty else { return }
        // Selector View Constraints
        selectorLeadingConstraint = selectorView.leadingAnchor.constraint(equalTo: buttons[selectedSegmentIndex].leadingAnchor)
        selectorWidthConstraint = selectorView.widthAnchor.constraint(equalTo: buttons[selectedSegmentIndex].widthAnchor)
        NSLayoutConstraint.activate([
            selectorLeadingConstraint!,
            selectorWidthConstraint!,
            selectorView.heightAnchor.constraint(equalToConstant: 4),
            selectorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    /// Creates a segment button with the given title and index.
    private func createSegmentButton(title: String, index: Int, isFlexible: Bool) -> UIButton {
        if isFlexible{
            if #available(iOS 15.0, *) {
                var config = UIButton.Configuration.plain()
                config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16) // Padding
                config.title = title
                let button = UIButton(configuration: config)
                button.tag = index
                button.setTitle(title, for: .normal)
                button.setTitleColor(segmentTextColor, for: .normal)
                button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.setContentHuggingPriority(.required, for: .horizontal)
                button.setContentCompressionResistancePriority(.required, for: .horizontal)
                return button
            } else {
                let button = UIButton(type: .system)
                button.tag = index
                button.setTitle(title, for: .normal)
                button.setTitleColor(segmentTextColor, for: .normal)
                button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
                button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.setContentHuggingPriority(.required, for: .horizontal)
                button.setContentCompressionResistancePriority(.required, for: .horizontal)
                return button
            }
        }
        let button = UIButton(type: .system)
        button.tag = index
        button.setTitle(title.isEmpty ? "Segment \(index)" : title, for: .normal)
        button.setTitleColor(segmentTextColor, for: .normal)
        button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
// MARK: - Update Methods
extension JCustomSegmentControl {
    /// Updates the stack view width constraint based on the scrollability.
    private func updateStackViewWidthConstraint() {
        if let stackViewWidthConstraint = stackViewWidthConstraint {
            stackViewWidthConstraint.isActive = false
            self.stackViewWidthConstraint = nil
        }
        if !isScrollEnabled {
            stackViewWidthConstraint = stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            stackViewWidthConstraint?.isActive = true
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    /// Updates the button configuration based on the scrollability.
    private func updateButtonConfiguration() {
        for (index, button) in buttons.enumerated() {
            if #available(iOS 15.0, *) {
                if isScrollEnabled {
                    var config = UIButton.Configuration.plain()
                    config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16) // Padding
                    config.title = button.title(for: .normal)
                    button.configuration = config
                } else {
                    button.configuration = nil
                }
            } else {
                if isScrollEnabled {
                    button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
                } else {
                    button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                }
            }
            if isScrollEnabled {
                button.setContentHuggingPriority(.required, for: .horizontal)
                button.setContentCompressionResistancePriority(.required, for: .horizontal)
            } else {
                button.setContentHuggingPriority(.defaultLow, for: .horizontal)
                button.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            }
        }
    }
    /// Updates the colors of the segments and the selector.
    private func updateSegmentColors() {
        buttons.forEach { $0.setTitleColor(segmentTextColor, for: .normal) }
        if buttons.isEmpty { return }
        buttons[selectedSegmentIndex].setTitleColor(selectedSegmentColor, for: .normal)
        selectorView.backgroundColor = selectedSegmentColor
    }
    /// Updates the text of the segments.
    private func updateSegmentTexts() {
        for (index, button) in buttons.enumerated() {
            button.setTitle((titles[index] == "" ? "Segment \(index)" : titles[index]), for: .normal)
        }
    }
    /// Updates the selected segment and moves the selector to the correct position.
    private func updateSegmentSelection() {
        guard !buttons.isEmpty else { return }
        selectorLeadingConstraint?.isActive = false
        selectorWidthConstraint?.isActive = false
        selectorLeadingConstraint = selectorView.leadingAnchor.constraint(equalTo: buttons[selectedSegmentIndex].leadingAnchor)
        selectorWidthConstraint = selectorView.widthAnchor.constraint(equalTo: buttons[selectedSegmentIndex].widthAnchor)
        NSLayoutConstraint.activate([
            selectorLeadingConstraint!,
            selectorWidthConstraint!
        ])
        updateSegmentColors()
        scrollView.scrollRectToVisible(CGRect(x: buttons[selectedSegmentIndex].frame.minX, y: 0, width: buttons[selectedSegmentIndex].frame.width, height: scrollView.frame.height), animated: true)
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
}
// MARK: - Segment Action
extension JCustomSegmentControl {
    /// Handles the segment tap event.
    @objc private func segmentTapped(_ sender: UIButton) {
        selectedSegmentIndex = sender.tag
        sendActions(for: .valueChanged)
    }
}
