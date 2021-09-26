//
//  SettingsViewController.swift
//  mdleypunskiyPW2
//
//  Created by Maksim on 23.09.2021.
//

import UIKit
import CoreLocation

final class SettingsViewController: UIViewController {
    
    var delegate: FirstViewControllerDelegate?
    
    private let settingsView = UIStackView()
    
    var isCordinatesOn: Bool = false
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var locToggl = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupSettingsView()
        setupLocationToggle()
        setupCloseButton()
        setupSliders()
    }
    
    func changeLocation(isOn: Bool) {
        delegate?.updateLocation(isOn: isOn)
    }
    
    func changeColor(red: CGFloat, green: CGFloat, blue: CGFloat) {
        delegate?.updateColor(red: red, green: green, blue: blue)
    }
    
    private func setupSettingsView() {
        view.addSubview(settingsView)
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        settingsView.layer.cornerRadius = 15
        settingsView.backgroundColor = .systemGray4
        settingsView.alpha = 0
        settingsView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 100
        ).isActive = true
        settingsView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 10
        ).isActive = true
        settingsView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -10
        ).isActive = true
        
        settingsView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        settingsView.axis = .vertical
        settingsView.alpha = 1
    }
    
    private func setupLocationToggle() {
        let locationToggle = UISwitch()
        let locationLabel = UILabel()
        locationToggle.isOn = isCordinatesOn
        settingsView.addArrangedSubview(locationLabel)
        locationLabel.text = "Location"
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        settingsView.addArrangedSubview(locationToggle)
        
        locationToggle.translatesAutoresizingMaskIntoConstraints = false
        locationToggle.addTarget(
            self,
            action: #selector(locationToggleSwitched),
            for: .valueChanged
        )
    }
    
    @objc
    func locationToggleSwitched(_ sender: UISwitch) {
        changeLocation(isOn: sender.isOn)
    }
    
    private func setupCloseButton() {
    let button = UIButton(type: .close)
    view.addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
        
    button.trailingAnchor.constraint(
        equalTo: view.trailingAnchor,
        constant: -10 ).isActive = true
        
    button.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: 10
    ).isActive = true
        
    button.heightAnchor.constraint(equalToConstant: 30).isActive = true
    button.widthAnchor.constraint(
        equalTo: button.heightAnchor).isActive = true
        
    button.addTarget(self, action: #selector(closeScreen),
                     for: .touchUpInside)
    }

    @objc
    private func closeScreen () {
        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    private let sliders = [UISlider(), UISlider(), UISlider()]
        private let colors = ["Red", "Green", "Blue"]
        private func setupSliders() {
            sliders[0].value = Float(red)
            sliders[1].value = Float(green)
            sliders[2].value = Float(blue)

            var top = 80
            for i in 0..<sliders.count {
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                settingsView.addArrangedSubview(view)
                
                view.topAnchor.constraint(
                equalTo: settingsView.topAnchor,
                constant: CGFloat(top)
                ).isActive = true
                
                top += 40
                
                let label = UILabel()
                view.addSubview(label)
                label.text = colors[i]
                label.translatesAutoresizingMaskIntoConstraints = false
                label.topAnchor.constraint(
                    equalTo: view.topAnchor,
                    constant: 5
                ).isActive = true
                label.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor
                ).isActive = true
                label.widthAnchor.constraint(
                    equalToConstant: 50
                ).isActive = true
                
                let slider = sliders[i]
                slider.translatesAutoresizingMaskIntoConstraints = false
                slider.minimumValue = 0
                slider.maximumValue = 1
                slider.addTarget(self, action: #selector(sliderChangedValue), for: .valueChanged)
                view.addSubview(slider)
                slider.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
                slider.heightAnchor.constraint(equalToConstant: 20).isActive = true
                
                slider.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10).isActive = true
                slider.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            }
    }
    
    @objc private func sliderChangedValue() {
        let red: CGFloat = CGFloat(sliders[0].value)
        let green: CGFloat = CGFloat(sliders[1].value)
        let blue: CGFloat = CGFloat(sliders[2].value)
        changeColor(red: red, green: green, blue: blue)
    }
}
