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
    
    private let settingsView = UIView()
    private let locationTextView = UITextView()
    
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
    }
    
    func changeLocation(isOn: Bool) {
        delegate?.updateLocation(isOn: isOn)
    }
    
    private func setupSettingsView() {
        view.addSubview(settingsView)
        
        settingsView.backgroundColor = .green
        settingsView.layer.cornerRadius = 15
        
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        
        settingsView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 100
        ).isActive = true

        settingsView.centerXAnchor.constraint(
            equalTo: view.centerXAnchor).isActive = true

        settingsView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        settingsView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 20).isActive = true
        
        settingsView.alpha = 1
    }
    
    private func setupLocationToggle() {
        let locationToggle = UISwitch()
        settingsView.addSubview(locationToggle)
        
        locationToggle.isOn = isCordinatesOn
        
        locationToggle.translatesAutoresizingMaskIntoConstraints = false
        locationToggle.topAnchor.constraint(
            equalTo: settingsView.topAnchor,
        constant: 50
        ).isActive = true
        locationToggle.trailingAnchor.constraint(
            equalTo: settingsView.trailingAnchor,
        constant: -10 ).isActive = true
        locationToggle.addTarget(
            self,
            action: #selector(locationToggleSwitched),
            for: .valueChanged
        )
        
        let locationLabel = UILabel()
        settingsView.addSubview(locationLabel)
        locationLabel.text = "Location"
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.topAnchor.constraint(
            equalTo: settingsView.topAnchor,
            constant: 55
        ).isActive = true
        locationLabel.leadingAnchor.constraint(
            equalTo: settingsView.leadingAnchor,
            constant: 10
        ).isActive = true
        locationLabel.trailingAnchor.constraint(
            equalTo: locationToggle.leadingAnchor,
            constant: -10
        ).isActive = true
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
}

extension SettingsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let coord: CLLocationCoordinate2D =
                manager.location?.coordinate else { return }
        locationTextView.text = "Coordinates = \(coord.latitude) \(coord.longitude)"
    }
}
