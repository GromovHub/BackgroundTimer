//
//  ViewController.swift
//  BackgroundTimer
//
//  Created by Vitaly Gromov on 2/10/23.
//

import UIKit

protocol VCProtocolDelegate: AnyObject {
    func didTapStart()
    func didTapStop()
    func updateTimeLabel(newValue: Int)
}

class ViewController: UIViewController {
    
    
    //create views
    private var timeLabel: UILabel = {
        var label = UILabel()
        label.text = "00.00.00"
        label.font = .systemFont(ofSize: 50)
        return label
    }()
    
    private var startStopButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("START", for: .normal)
        button.setTitleColor(.green, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 40)
        return button
    }()
    
    private var resetButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("RESET", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 40)
        
        return button
    }()
    
    //values
    private var timer: TimerController?

    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        timer = TimerController()
        timer?.delegate = self
        
    }
    
    //other func
    
    @objc func startStopIntent() {
        guard let timer = timer else {
            print("timer error")
            return
        }
        
        if !timer.timeCounting {
            timer.startStopAction()
        } else {
            timer.startStopAction()
            
            print("VC timeCounting \(timer.timeCounting)")
        }
    }
    
    @objc func resetIntent() {
        timer?.resetTimer()
//        if let timer = timer {
//            timer.timeCounting = false
//            startStopButton.setTitle("START", for: .normal)
//            startStopButton.setTitleColor(.green, for: .normal)
//        }
    }
    
    private func setupViews() {
        addViews()
        setupConstraints()
        
        startStopButton.addTarget(self, action: #selector(startStopIntent), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetIntent), for: .touchUpInside)
    }
    
    private func addViews() {
        view.addSubview(timeLabel)
        view.addSubview(startStopButton)
        view.addSubview(resetButton)
    }
    
    private func setupConstraints() {
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        startStopButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -70),
            startStopButton.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor, constant: 100),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 70),
            resetButton.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor, constant: 100)
        ])
    }
}

extension ViewController: VCProtocolDelegate {
    func didTapStart() {
        print("did tap start")
        startStopButton.setTitle("STOP", for: .normal)
        startStopButton.setTitleColor(.red, for: .normal)
    }
    
    func didTapStop() {
        print("did tap stop")
        startStopButton.setTitle("START", for: .normal)
        startStopButton.setTitleColor(.green, for: .normal)
    }
    
    func updateTimeLabel(newValue: Int) {
        timeLabel.text = "\(newValue)"
        print(newValue)
    }
    
}
