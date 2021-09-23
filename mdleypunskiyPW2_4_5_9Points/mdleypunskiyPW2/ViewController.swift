//
//  ViewController.swift
//  mdleypunskiyPW2
//
//  Created by Maksim on 22.09.2021.
//

import UIKit
import CoreLocation

protocol FirstViewControllerDelegate: AnyObject {
    func updateLocation(isOn: Bool)
}

class ViewController: UIViewController {
    
    private let settingsView = UIView()
    private let locationTextView = UITextView()
    private let locationManager = CLLocationManager()
    private let locationToggle = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .darkGray
        locationManager.requestWhenInUseAuthorization()
        setupLocationTextView()
        setupSettingsView()
        setupSettingsButton()
        setupLocationToggle()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupSettingsButton() {
        let settingsButton = UIButton(type: .system)
        view.addSubview(settingsButton)
        
        settingsButton.setImage(UIImage(named: "settingsButtonIcon")?.withRenderingMode(
                                    .alwaysOriginal), for: .normal)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        settingsButton.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 15
        ).isActive = true
        
        settingsButton.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -15
        ).isActive = true
        
        settingsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        settingsButton.widthAnchor.constraint(equalTo: settingsButton.heightAnchor).isActive = true
        
        settingsButton.addTarget(self, action: #selector(settingsButtonPressed),
                                 for: .touchUpInside)
    }
    
    private var buttonCount = 0
        @objc private func settingsButtonPressed() {
            
            switch buttonCount {
            case 0, 1:
                UIView.animate(withDuration: 0.1, animations: {
                    self.settingsView.alpha = 1 - self.settingsView.alpha
                })
            case 2:
                let settingsVC = SettingsViewController()
                settingsVC.isCordinatesOn = locationToggle.isOn
                settingsVC.locToggl = locationManager
                settingsVC.delegate = self
                navigationController?.pushViewController(
                settingsVC,
                animated: true
                )
            case 3:
                let settingsVC = SettingsViewController()
                settingsVC.isCordinatesOn = locationToggle.isOn
                settingsVC.locToggl = locationManager
                settingsVC.delegate = self
                present(settingsVC, animated: true, completion: nil)
            default:
            buttonCount = -1
        }
        buttonCount += 1
    }
    
    private func setupSettingsView() {
        view.addSubview(settingsView)
        
        // Makes us enable to see settingsView.
        // As a debug feature.
        settingsView.backgroundColor = .lightGray
        settingsView.layer.cornerRadius = 15
        
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        
        settingsView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 10
        ).isActive = true

        settingsView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -10
        ).isActive = true

        settingsView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        settingsView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        settingsView.alpha = 0
    }
    
    private func setupLocationTextView() {
        view.addSubview(locationTextView)
        
        locationTextView.backgroundColor = .white
        locationTextView.layer.cornerRadius = 20
        locationTextView.translatesAutoresizingMaskIntoConstraints = false
        
        locationTextView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 60
        ).isActive = true
        
        locationTextView.centerXAnchor.constraint(
            equalTo: view.centerXAnchor
        ).isActive = true
        
        locationTextView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        locationTextView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 15
        ).isActive = true
        
        locationTextView.isUserInteractionEnabled = false
    }
    
    private func setupLocationToggle() {
        settingsView.addSubview(locationToggle)
        
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
        if sender.isOn {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            } else {
                sender.setOn(false, animated: true)
            }
        } else {
            locationTextView.text = ""
            locationManager.stopUpdatingLocation()
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let coord: CLLocationCoordinate2D =
                manager.location?.coordinate else { return }
        locationTextView.text = "Coordinates = \(coord.latitude) \(coord.longitude)"
    }
}

extension ViewController: FirstViewControllerDelegate {
    func updateLocation(isOn: Bool) {
        locationToggle.isOn = isOn
        locationToggleSwitched(locationToggle)
    }
}
