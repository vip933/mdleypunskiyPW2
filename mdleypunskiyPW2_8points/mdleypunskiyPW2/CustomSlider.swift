//
//  CustomSlider.swift
//  mdleypunskiyPW2
//
//  Created by Maksim on 26.09.2021.
//

import UIKit

class CustomSlider: UIView {
    
    public let sliders = [UISlider(), UISlider(), UISlider()]
    private let labels = [UILabel(), UILabel(), UILabel()]
    
        private let colors = ["Red", "Green", "Blue"]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSliders()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSliders()
    }
    
        private func setupSliders() {
            var top  = 40
            for i in 0..<sliders.count {
                let label = UILabel()
                self.addSubview(label)
                label.text = colors[i]
                
                label.translatesAutoresizingMaskIntoConstraints = false
                label.topAnchor.constraint(equalTo: self.topAnchor, constant: CGFloat(top)).isActive = true
                label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                label.widthAnchor.constraint(equalToConstant: 50).isActive = true
                
                let slider = sliders[i]
                slider.translatesAutoresizingMaskIntoConstraints = false
                slider.minimumValue = 0
                slider.maximumValue = 1
                
                let label0 = UILabel()
                label0.translatesAutoresizingMaskIntoConstraints = false
                label0.text = "0"
                self.addSubview(label0)
                label0.topAnchor.constraint(equalTo: self.topAnchor, constant: CGFloat(top)).isActive = true
                label0.heightAnchor.constraint(equalToConstant: 20).isActive = true
                label0.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 50).isActive = true
                
                self.addSubview(slider)
                slider.topAnchor.constraint(equalTo: self.topAnchor, constant: CGFloat(top)).isActive = true
                slider.heightAnchor.constraint(equalToConstant: 20).isActive = true
                slider.leadingAnchor.constraint(equalTo: label0.trailingAnchor, constant: 10).isActive = true
                slider.widthAnchor.constraint(equalToConstant: 100).isActive = true
                
                let label1 = UILabel()
                label1.text = "1"
                label1.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(label1)
                label1.topAnchor.constraint(equalTo: self.topAnchor, constant: CGFloat(top)).isActive = true
                label1.heightAnchor.constraint(equalToConstant: 20).isActive = true
                label1.leadingAnchor.constraint(equalTo: slider.trailingAnchor, constant: 10).isActive = true
                
                top += 40
            }
    }
}
