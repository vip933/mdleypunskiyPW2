//
//  ViewController.swift
//  mdleypunskiyPW2
//
//  Created by Maksim on 22.09.2021.
//

import UIKit
import CoreLocation
import AVFoundation

protocol FirstViewControllerDelegate: AnyObject {
    func updateLocation(isOn: Bool)
    func updateColor(red: CGFloat, green: CGFloat, blue: CGFloat)
}

class ViewController: UIViewController {
    
    private let settingsView = UIStackView()
    private let locationTextView = UITextView()
    private let locationManager = CLLocationManager()
    private let locationToggle = UISwitch()
    private var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(
                forResource: "Magentium — Among Us Theme (Extended Mix)", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
        } catch {
            
        }

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
                audioPlayer.play()
                UIView.animate(withDuration: 0.1, animations: {
                    self.settingsView.alpha = 1 - self.settingsView.alpha
                })
                if (buttonCount == 1) {
                    audioPlayer.stop()
                }
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
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        settingsView.layer.cornerRadius = 15
        settingsView.backgroundColor = .systemGray4
        settingsView.alpha = 0
        settingsView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 10
        ).isActive = true
        settingsView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -10
        ).isActive = true
        
        settingsView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        settingsView.widthAnchor.constraint(
            equalTo: settingsView.heightAnchor,
            multiplier: 3/4
        ).isActive = true
        settingsView.axis = .vertical
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
        let locationLabel = UILabel()
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
    
    private var sliders: [UISlider] = []
        private func setupSliders() {
            let view = CustomSlider()
            sliders = view.sliders
            for i in 0..<view.sliders.count {
                let slider = view.sliders[i]
                slider.addTarget(self, action: #selector(sliderChangedValue), for: .valueChanged)
            }
            view.translatesAutoresizingMaskIntoConstraints = false
            settingsView.addArrangedSubview(view)
    }
    
    @objc public func sliderChangedValue() {
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
