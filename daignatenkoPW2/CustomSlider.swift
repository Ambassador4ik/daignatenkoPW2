//
//  CustomSlider.swift
//  daignatenkoPW2
//
//  Created by Dmitriy Ignatenko on 10/31/23.
//

import UIKit

private enum Constants {
    static let titleViewTop: CGFloat = 10
    static let leading: CGFloat = 20
    static let valueFieldTop: CGFloat = 10
    static let valueFieldBottom: CGFloat = -10
}

final class CustomSlider: UIView, UITextFieldDelegate {
    var valueChanged: ((Double) -> Void)?

    var slider = UISlider()
    var titleView = UILabel()
    var valueField = UITextField()

    init(title: String, min: Double, max: Double, initial: Float) {
        super.init(frame: .zero)
        titleView.text = title
        slider.minimumValue = Float(min)
        slider.maximumValue = Float(max)
        slider.value = initial  // Set slider's initial value
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        valueField.addTarget(self, action: #selector(textFieldValueChanged), for: .editingDidEnd)

        valueField.keyboardType = .numberPad  // Show number pad when editing
        valueField.textAlignment = .center  // Align text to center
        valueField.delegate = self

        configureUI()
        sliderValueChanged()  // Initial UI setup
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false

        for view in [slider, titleView, valueField] {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.titleViewTop),
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leading),

            slider.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            slider.centerXAnchor.constraint(equalTo: centerXAnchor),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leading),

            valueField.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: Constants.valueFieldTop),
            valueField.centerXAnchor.constraint(equalTo: centerXAnchor),
            valueField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.valueFieldBottom),
            valueField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leading)
        ])
    }

    @objc
    private func sliderValueChanged() {
        // Update valueField's text with slider's current value (integer)
        valueField.text = String(format: "%d", Int(slider.value))
        valueChanged?(Double(slider.value))
    }

    @objc
    private func textFieldValueChanged() {
        if var text = valueField.text {
            // Remove leading zeros
            text = text.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
            valueField.text = text.isEmpty ? "0" : text  // If all characters are zeroes, keep one zero to prevent empty string
            
            if let value = Int(text), value >= Int(slider.minimumValue), value <= Int(slider.maximumValue) {
                slider.value = Float(value)
            } else {
                // Value out of range or not a number, reset text field to slider's current value
                valueField.text = String(format: "%d", Int(slider.value))
            }
        }
        valueChanged?(Double(slider.value))
    }

    // UITextFieldDelegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if let newValue = Int(newText) {
            return newValue >= Int(slider.minimumValue) && newValue <= Int(slider.maximumValue)
        }
        // Allow backspace
        return string.isEmpty
    }
    
    func getValue() -> CGFloat {
        // Adjust the slider's value to the range 0...1
        return CGFloat(slider.value / slider.maximumValue)
    }
}
