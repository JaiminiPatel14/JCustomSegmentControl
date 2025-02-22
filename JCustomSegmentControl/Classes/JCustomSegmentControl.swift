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
    @IBInspectable public var isScrollEnabled: Bool = false
    @IBInspectable public var titleSeparatedbyComma: String = "" {
        didSet {
            titles = titleSeparatedbyComma.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        }
    }
    private var titles: [String] = [] {
        didSet {
            updateSegmentTexts()
        }
    }
    @IBInspectable public var selectedSegmentIndex: Int = 0 {
        didSet {
            updateSegmentSelection()
        }
    }
    
    @IBInspectable public var segmentTextColor: UIColor = .black {
        didSet {
            updateSegmentColors()
        }
    }
    
    @IBInspectable public var selectedSegmentColor: UIColor = .blue {
        didSet {
            updateSegmentColors()
        }
    }
    
    private var selectorLeadingConstraint: NSLayoutConstraint?
    private var selectorWidthConstraint: NSLayoutConstraint?
    private var buttons: [UIButton] = []
    private var selectorView: UIView!
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
 
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupSegmentComponents() // Perform any final setup after storyboard loading
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
}
// MARK: - Setup Methods
extension JCustomSegmentControl {
    private func setupSegmentComponents() {
        subviews.forEach { $0.removeFromSuperview() }
        
        selectorView = UIView()
        selectorView.backgroundColor = selectedSegmentColor
        selectorView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(selectorView)
        
        configureScrollView()
        configureStackView()
        setupButtons()
        setupConstraints()
        updateSegmentTexts()
        updateSegmentColors()
    }
    private func configureScrollView() {
        scrollView.isScrollEnabled = isScrollEnabled
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
    }
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
    private func setupButtons() {
        buttons.removeAll()
        for (index, title) in titles.enumerated() {
            let button = createSegmentButton(title: title, index: index, isFlexible: isScrollEnabled)
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
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
                // Ensure the button resizes to fit its intrinsic content size
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
    private func setupConstraints() {
        guard !buttons.isEmpty else { return }
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
        if !isScrollEnabled{
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        }
        //SELECTORVIEW
        selectorLeadingConstraint = selectorView.leadingAnchor.constraint(equalTo: buttons[selectedSegmentIndex].leadingAnchor)
        selectorWidthConstraint = selectorView.widthAnchor.constraint(equalTo: buttons[selectedSegmentIndex].widthAnchor)
        NSLayoutConstraint.activate([
            selectorLeadingConstraint!,
            selectorWidthConstraint!,
            selectorView.heightAnchor.constraint(equalToConstant: 4),
            selectorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
//MARK: - SEGMENT ACTION
extension JCustomSegmentControl {
    @objc private func segmentTapped(_ sender: UIButton) {
        selectedSegmentIndex = sender.tag
        sendActions(for: .valueChanged)
    }
}

//MARK: - UPDATE SEGMENT COLORS AND CONSTRAINTS WHEN CHANGED
extension JCustomSegmentControl {
    private func updateSegmentColors() {
        buttons.forEach { $0.setTitleColor(segmentTextColor, for: .normal) }
        if buttons.isEmpty { return }
        buttons[selectedSegmentIndex].setTitleColor(selectedSegmentColor, for: .normal)
        selectorView.backgroundColor = selectedSegmentColor
    }
    private func updateSegmentTexts() {
        for (index, button) in buttons.enumerated() {
            button.setTitle((titles[index] == "" ? "Segment \(index)" : titles[index]), for: .normal)
        }
    }
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
