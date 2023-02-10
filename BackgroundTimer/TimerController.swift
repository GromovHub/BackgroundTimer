//
//  TimerController.swift
//  BackgroundTimer
//
//  Created by Vitaly Gromov on 2/10/23.
//

import Foundation

class TimerController {
    
    
    init() {
        //restore values
        print("timer controller init")
        startTime = UserDefaults.standard.object(forKey: UserDefaultsKeys.START_TIME.rawValue) as? Date
        stopTime = UserDefaults.standard.object(forKey: UserDefaultsKeys.STOP_TIME.rawValue) as? Date
        timeCounting = UserDefaults.standard.bool(forKey: UserDefaultsKeys.COUNTING.rawValue)
        print(startTime ?? "startimenil",stopTime ?? "stoptimenil",timeCounting)
        
        //start/stop branch
        if timeCounting {
          startTimer()
        } else {
            stopTimer()
            if let start = startTime {
                if let stop = stopTime {
                    let time = calcRestartTime(start: start, stop: stop)
                    let diff = Date().timeIntervalSince(time)
                    setTimeLabel(date: Int(diff))
                }
            }
        }
    }
    
    // values
    weak var delegate: VCProtocolDelegate?
    var startTime: Date?
    var stopTime: Date?
    var timeCounting: Bool = false {
        didSet {
            print("timeCounting changed to \(timeCounting)")        }
    }
    var sheduledTimer: Timer?
    
    func startTimer() {
        // TODO: create
        print("timer started")
        sheduledTimer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(refreshView), userInfo: nil, repeats: true)
        timeCounting = true
        delegate?.didTapStart()
    }
    
    @objc func refreshView() {
        print("view refreshed")
        if let startTime = startTime {
            let diff = Date().timeIntervalSince(startTime)
            setTimeLabel(date: Int(diff))
        } else {
            // !!!
            
            stopTimer()
            setTimeLabel(date: 0)
        }
    }
    
    @objc func refreshView2() {
        print("refresh view 2")
        guard let startTime = startTime else { return }
        let diff = Date().timeIntervalSince(startTime)
        setTimeLabel(date: Int(diff))
    }
    
    func stopTimer() {
        // TODO: create
        print("timer stoped")
        sheduledTimer != nil ? sheduledTimer?.invalidate() : print("ok")
        timeCounting = false
        delegate?.didTapStop()
    }
    
    func startStopAction() {
        if timeCounting {
            // time counting = "stop"
            setStopTime(date: Date())
            stopTimer()
        } else {
            // time not counting = "start" or "resume"
            
            // if stop time exist = "resume"
            if let stop = stopTime {
                guard let start = startTime else { print("start time error"); return}
                let restartTime = calcRestartTime(start: start, stop: stop)
                setStopTime(date: nil)
                setStartTime(date: restartTime)
            } else  {
                // if we do not have last stop time = "start" new timer and set start time for .now
                setStartTime(date: Date())
            }
            startTimer()
        }
    }
    
    func calcRestartTime(start: Date, stop: Date) -> Date {
        // current time + time from last exit
        let diff = start.timeIntervalSince(stop)
        return Date().addingTimeInterval(diff)
    }
    
    func setTimeLabel(date: Int) {
        delegate?.updateTimeLabel(newValue: date)
        // TODO: create with delegate
        // conveter to min sec
        // converter to string for view
        
    }
    
    func setStopTime(date: Date?) {
        stopTime = date
        UserDefaults.standard.set(stopTime, forKey: UserDefaultsKeys.STOP_TIME.rawValue)
    }
    
    func setStartTime(date: Date?) {
        startTime = date
        UserDefaults.standard.set(startTime, forKey: UserDefaultsKeys.START_TIME.rawValue)
    }
    
    func setCounting(value: Bool) {
        timeCounting = value
        UserDefaults.standard.set(timeCounting, forKey: UserDefaultsKeys.COUNTING.rawValue)
    }
    
    func resetTimer() {
        setStopTime(date: nil)
        setStartTime(date: nil)
        delegate?.didTapStop()
        stopTimer()
        setTimeLabel(date: 0)
        
    }
}


enum UserDefaultsKeys: String {
    case START_TIME = "startTime"
    case STOP_TIME = "stopTime"
    case COUNTING = "counting"
}


