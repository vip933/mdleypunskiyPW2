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
        settingsView.backgroundColor = .clear
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
    
    private var sliders: [UISlider] = []
        private func setupSliders() {
            let view = CustomSlider()
            sliders = view.sliders
            sliders[0].value = Float(red)
            sliders[1].value = Float(green)
            sliders[2].value = Float(blue)
            for i in 0..<view.sliders.count {
                let slider = view.sliders[i]
                slider.addTarget(self, action: #selector(sliderChangedValue), for: .valueChanged)
            }
            view.translatesAutoresizingMaskIntoConstraints = false
            settingsView.addArrangedSubview(view)
    }
    
    @objc private func sliderChangedValue() {
        let red: CGFloat = CGFloat(sliders[0].value)
        let green: CGFloat = CGFloat(sliders[1].value)
        let blue: CGFloat = CGFloat(sliders[2].value)
        changeColor(red: red, green: green, blue: blue)
    }
}
