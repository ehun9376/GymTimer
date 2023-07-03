//
//  ViewController.swift
//  GymTimer
//
//  Created by 陳逸煌 on 2023/6/30.
//

import UIKit

class ViewController: BaseViewController {

    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet var timeLabels: [UILabel]!
    
    @IBOutlet weak var histtoryTableView: UITableView!
    
    @IBOutlet weak var settingButton: UIButton!
    
    var adapte: TableViewAdapter?
    
    var current: Int = 0 {
        didSet {
            self.creatTimer(current: self.current)
            self.setupButton(current: self.current)
            self.setupTextField()
            self.getTextField(tag: self.current).font = .systemFont(ofSize: 18, weight: .bold)
        }
    }
    
    var currentTime = 0 {
        didSet {
            guard self.timer != nil else { return }
            self.getTimeLabel(tag: self.current).text = self.timeFormat(self.currentTime)
            self.countDown(currentTime: self.currentTime)
        }
    }
    
    var max: Int = 3
    
    var timer: Timer?
    
    var currentModels: TrainingHistoryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.histtoryTableView.register(.init(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "SettingCell")
        self.setupSettingButton()
        self.startButton.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
        self.adapte = .init(self.histtoryTableView)
        self.setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.current = 0
        self.max = UserInfoCenter.shared.loadValue(.practiceTime) as? Int ?? 3
        self.currentTime = max
        self.setupLabel()
        self.setupRowModel()
    }
    func setupTableView() {
        self.histtoryTableView.layer.borderColor = UIColor.black.cgColor
        self.histtoryTableView.layer.borderWidth = 0.5
    }
    
    @objc func settingButtonAction(_ sender: UIButton) {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupRowModel() {
        var rowModels: [CellRowModel] = []
        
        for model in (UserInfoCenter.shared.loadData(modelType: [TrainingModel].self, .history) ?? []).reversed() {
            
            let rowModel = SettingCellRowModel(title: model.text,
                                               detail: model.time,
                                               imageName: "figure.strengthtraining.traditional",
                                               showSwitch: false)
            
            rowModels.append(rowModel)
        }
        
        self.adapte?.updateTableViewData(rowModels: rowModels)
    }
    
    func storeTaining() {
        var texts: [String] = []
        
        for (i,textField) in self.textFields.enumerated() {
            texts.append("\(i+1):\(textField.text ?? "")")
        }
        
        let text = texts.joined(separator: ",")
        
        let model = TrainingModel(text: text, time: String(self.max))
        
        if var array = UserInfoCenter.shared.loadData(modelType: [TrainingModel].self, .history) {
            array.append(model)
            UserInfoCenter.shared.storeData(model: array, .history)
        } else {
            UserInfoCenter.shared.storeData(model: [model], .history)
        }
    
    }
    
    func setupSettingButton() {
        if #available(iOS 15.0, *) {
            self.settingButton.configuration = nil
        }
        self.settingButton.setTitle(nil, for: .normal)
        
        self.settingButton.addTarget(self, action: #selector(self.settingButtonAction(_:)), for: .touchUpInside)
    }
    
    func setupLabel() {
        for label in self.timeLabels {
            label.text = self.timeFormat(self.max)
            label.font = .systemFont(ofSize: 18)
        }
    }
    
    func setupTextField() {
        for textField in self.textFields {
            textField.font = .systemFont(ofSize: 18)
            textField.layer.borderColor = UIColor.black.cgColor
            textField.layer.borderWidth = 0.5
        }
    }
    
    func countDown(currentTime: Int) {
        if self.currentTime <= 0 {
            self.timer?.invalidate()
            self.current += 1
            if current > 5 {
                self.current = 0
            }
            self.currentTime = max
            if current == 0 {
                self.setupLabel()
            }
        }
    }
    
    func timeFormat(_ time: Int) -> String {
        return String(format: "%02d:%02d", time / 60 , time % 60)
    }
    
    func setupButton(current: Int) {
        if #available(iOS 15.0, *) {
            self.startButton.configuration = nil
        }
        
        let times = UserInfoCenter.shared.loadValue(.iaped) as? Int

        var title = "Start,  Last \(times ?? 0) times"
        
        var backColor: UIColor = .green
        
        switch current {
        case 0:
            title = "Start,  Last \(times ?? 0) times"
            backColor = .green
            break
        case 1:
            title = "Next"
            backColor = .yellow
        case 2:
            title = "Next"
            backColor = .yellow
        case 3:
            title = "Next"
            backColor = .yellow
        case 4:
            title = "Next"
            backColor = .yellow
        case 5:
            title = "Stop"
            backColor = .red
        default:
            break
        }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.startButton.setTitle(title, for: .normal)
            self.startButton.setTitleColor(.black, for: .normal)
            self.startButton.backgroundColor = backColor
        })

//        self.creatTimer(current: current)
    }
    
    func getTextField(tag: Int) -> UITextField {
        if let first = self.textFields.first(where: {$0.tag == tag}) {
            return first
        } else {
            return self.textFields.first ?? .init()
        }
    }
    
    func getTimeLabel(tag: Int) -> UILabel {
        if let first = self.timeLabels.first(where: {$0.tag == tag}) {
            return first
        } else {
            return self.timeLabels.first ?? .init()
        }
    }
    
    func creatTimer(current: Int) {
        guard current > 0 else { self.timer?.invalidate()
            return
        }
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            self.currentTime -= 1
        })
        
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        guard var times = UserInfoCenter.shared.loadValue(.iaped) as? Int , times > 0 else {
            self.showToast(message: "次數不夠囉請至設定頁購買")
            return
        }
        self.current += 1
        self.currentTime = max
        switch self.current {
        case 1:
            times -= 1
            UserInfoCenter.shared.storeValue(.iaped, data: times)
            self.creatTimer(current: self.current)
        case 2,3,4,5:
            self.creatTimer(current: self.current)
        default:
            self.current = 0
            self.timer?.invalidate()
            self.setupLabel()
            self.storeTaining()
            self.setupRowModel()
        }
    }


}

