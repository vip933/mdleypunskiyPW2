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
    func updateColor(red: CGFloat, green: CGFloat, blue: CGFloat)
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
        setupSliders()
        
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
                settingsVC.red = CGFloat(sliders[0].value)
                settingsVC.green = CGFloat(sliders[1].value)
                settingsVC.blue = CGFloat(sliders[2].value)
                
                navigationController?.pushViewController(
                settingsVC,
                animated: true
                )
            case 3:
                let settingsVC = SettingsViewController()
                settingsVC.isCordinatesOn = locationToggle.isOn
                settingsVC.locToggl = locationManager
                settingsVC.delegate = self
                settingsVC.red = CGFloat(sliders[0].value)
                settingsVC.green = CGFloat(sliders[1].value)
                settingsVC.blue = CGFloat(sliders[2].value)
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
    
    private let sliders = [UISlider(), UISlider(), UISlider()]
        private let colors = ["Red", "Green", "Blue"]
        private func setupSliders() {
            var top = 80
            for i in 0..<sliders.count {
                let view = UIView()
                settingsView.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
                view.leadingAnchor.constraint(
                    equalTo: settingsView.leadingAnchor,
                    constant: 10
                ).isActive = true
                view.trailingAnchor.constraint(
                    equalTo: settingsView.trailingAnchor,
                    constant: -10 ).isActive = true
                view.topAnchor.constraint(
                    equalTo: settingsView.topAnchor,
                    constant: CGFloat(top)
                ).isActive = true
                view.heightAnchor.constraint(equalToConstant: 30).isActive = true
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
        view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
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
    
    func updateColor(red: CGFloat, green: CGFloat, blue: CGFloat) {
        sliders[0].value = Float(red)
        sliders[1].value = Float(green)
        sliders[2].value = Float(blue)
        sliderChangedValue()
    }
}
