//
//  ViewController.swift
//  daignatenkoPW2
//
//  Created by Dmitriy Ignatenko on 10/31/23.
//

import UIKit

enum Colors {
    static let backgroundColor: UIColor = UIColor(red: 252/255.0, green: 245/255.0, blue: 237/255.0, alpha: 1)
    static let fontColor: UIColor = UIColor(red: 31/255.0, green: 23/255.0, blue: 23/255.0, alpha: 1)
    static let accentOne: UIColor = UIColor(red: 206/255.0, green: 90/255.0, blue: 103/255.0, alpha: 1)
    static let accentTwo: UIColor = UIColor(red: 244/255.0, green: 191/255.0, blue: 150/255.0, alpha: 1)
}

private struct Constants {
    static let appTitle: String = "WishMaker"
    static let appDescription: String = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo."
    
    static let appTitleFontSize: CGFloat = 32
    static let appDescriptionFontSize: CGFloat = 20
    
    static let appTitleAlignTop: CGFloat = 30
    static let appDescriptionAlignTop: CGFloat = 20
    static let appDesctiptionAlignLR: CGFloat = 15
    
    static let sliderMin: Double = 0
    static let sliderMax: Double = 255
    
    static let red: String = "Red"
    static let green: String = "Green"
    static let blue: String = "Blue"
    
    static let stackRadius: CGFloat = 10
    static let stackBottom: CGFloat = -90
    static let stackLeading: CGFloat = 20
    
    static let fallbackColorValue: CGFloat = 0
    static let alphaConst: CGFloat = 1
    
    static let buttonHeight: CGFloat = 50
    static let buttonBottom: CGFloat = 30
    static let buttonSide: CGFloat = 20
    static let buttonRadius: CGFloat = 10
    static let buttonText: String = "Add Wish"
}

final class WishMakerViewController: UIViewController {
    
    // Views
    
    private let titleView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.appTitle
        label.font = UIFont.boldSystemFont(ofSize: Constants.appTitleFontSize)
        return label
    }()
    
    private let descriptionView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.appDescription
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: Constants.appDescriptionFontSize)
        label.numberOfLines = 0
        return label
    }()

    private lazy var colorPickerToggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Hide Color Picker", for: .normal)
        button.addTarget(self, action: #selector(toggleColorPickerVisibility), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stack = UIStackView()
    
    private var colorPickerVisible: Bool = true
    
    // Configuration
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = Colors.backgroundColor

        configureTitle()
        configureDescription()
        configureAddWishButton()
        configureSliders()
        configureToggleColorPickerButton()

    }

    // Configuration funcs
    
    private func configureTitle() {
        titleView.textColor = Colors.fontColor
        
        view.addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.appTitleAlignTop)
        ])
    }
    
    private func configureDescription(){
        descriptionView.textColor = Colors.accentOne
        
        view.addSubview(descriptionView)
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: Constants.appDescriptionAlignTop),
            descriptionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.appDesctiptionAlignLR),
            descriptionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.appDesctiptionAlignLR),
        ])
    }
    
    private func configureSliders() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        view.addSubview(stack)
        stack.layer.cornerRadius = Constants.stackRadius
        stack.clipsToBounds = true
        
        let sliderRed = CustomSlider(title: Constants.red, min: Constants.sliderMin, max: Constants.sliderMax, initial: Float(view.backgroundColor?.redValue255 ?? Int(Constants.fallbackColorValue)))
        let sliderGreen = CustomSlider(title: Constants.green, min: Constants.sliderMin, max: Constants.sliderMax, initial: Float(view.backgroundColor?.greenValue255 ?? Int(Constants.fallbackColorValue)))
        let sliderBlue = CustomSlider(title: Constants.blue, min: Constants.sliderMin, max: Constants.sliderMax, initial: Float(view.backgroundColor?.blueValue255 ?? Int(Constants.fallbackColorValue)))
        
        for slider in [sliderRed, sliderGreen, sliderBlue] {
            stack.addArrangedSubview(slider)
        }
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.stackLeading),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.stackBottom)
        ])
        
        sliderRed.valueChanged = { [weak self] value in
            self?.view.backgroundColor = UIColor(
                red: sliderRed.getValue(),
                green: self?.view.backgroundColor?.greenValue ?? Constants.fallbackColorValue,
                blue: self?.view.backgroundColor?.blueValue ?? Constants.fallbackColorValue,
                alpha: Constants.alphaConst)
        }
        
        sliderGreen.valueChanged = { [weak self] value in
            self?.view.backgroundColor = UIColor(
                red: self?.view.backgroundColor?.redValue ?? Constants.fallbackColorValue,
                green: sliderGreen.getValue(),
                blue: self?.view.backgroundColor?.blueValue ?? Constants.fallbackColorValue,
                alpha: Constants.alphaConst)
        }
        
        sliderBlue.valueChanged = { [weak self] value in
            self?.view.backgroundColor = UIColor(
                red: self?.view.backgroundColor?.redValue ?? Constants.fallbackColorValue,
                green: self?.view.backgroundColor?.greenValue ?? Constants.fallbackColorValue,
                blue: sliderBlue.getValue(),
                alpha: Constants.alphaConst)
        }
    }
    
    private func configureToggleColorPickerButton() {
        view.addSubview(colorPickerToggleButton)
        NSLayoutConstraint.activate([
            colorPickerToggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorPickerToggleButton.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 20)
        ])
    }
    
    @objc 
    private func toggleColorPickerVisibility() {
        colorPickerVisible.toggle()
        
        UIView.animate(withDuration: 0.3, animations: {
               self.stack.alpha = self.colorPickerVisible ? 1 : 0
           }) { _ in
               self.stack.isHidden = !self.colorPickerVisible
           }
        stack.isHidden = !colorPickerVisible
        colorPickerToggleButton.setTitle(colorPickerVisible ? "Hide Color Picker" : "Show Color Picker", for: .normal)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private let addWishButton: UIButton = UIButton(type: .system)

    private func configureAddWishButton() {
        view.addSubview(addWishButton)
            
        // Set the button's layout constraints manually
        addWishButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addWishButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            addWishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonSide),
            addWishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.buttonSide),
            addWishButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.buttonBottom)
        ])
            
        // Style the button
        addWishButton.backgroundColor = .white
        addWishButton.setTitleColor(.systemPink, for: .normal)
        addWishButton.setTitle(Constants.buttonText, for: .normal)
        addWishButton.layer.cornerRadius = Constants.buttonRadius
            
        // Attach an action to the button's touchUpInside event
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchUpInside)
    }
    
    @objc private func addWishButtonPressed() {
            // Logic to be executed when the button is pressed
        present(WishStoringViewController(), animated: true)
    }
}
