//
//  SettingViewController.swift
//  GymTimer
//
//  Created by 陳逸煌 on 2023/6/30.
//

import Foundation

class SettingViewController: BaseTableViewController {
    
    
    
    var rowModels: [CellRowModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "設定"
        self.navigationController?.navigationBar.backgroundColor = .white
        self.regisCellID(cellIDs: [
            "SettingCell"
        ])
        self.setupRow()
        IAPCenter.shared.getProducts()
        
        IAPCenter.shared.requestComplete = { [weak self] debug in
            self?.setupRow()
        }
        
        
    }
    
    func setupRow() {
        self.rowModels.removeAll()
        let passWordRowModel = SettingCellRowModel(title: "變更每組時間",
                                                   detail:"\(String(UserInfoCenter.shared.loadValue(.practiceTime) as? Int ?? 3)) 秒" ,
                                                   imageName: "textformat.abc.dottedunderline",
                                                   showSwitch: false,
                                                   switchAction: nil,
                                                   cellDidSelect: { [weak self] _ in
            self?.showPasswordAlert(isON: true,fromSwitch: false)
        })
        
        self.rowModels.append(passWordRowModel)

        
        for model in IAPCenter.shared.buyTypes {
            let rowModel = SettingCellRowModel(title: model.title,
                                               imageName: "briefcase",
                                               showSwitch: false,
                                               switchAction: nil,
                                               cellDidSelect: { _ in
                if !IAPCenter.shared.buy(id: model.id) {
                    self.showToast(message: "取得內購產品資料錯誤")
                }
            })
            self.rowModels.append(rowModel)
        }
        
        
        self.adapter?.updateTableViewData(rowModels: self.rowModels)
        
    }
    
    func showPasswordAlert(isON: Bool, fromSwitch: Bool) {
        self.showInputDialog(title: "提示",
                             subtitle: "請輸入新密碼",
                             actionTitle: "確認",
                             cancelTitle: "取消",
                             inputPlaceholder: "請輸入密碼",
                             inputKeyboardType: .numberPad,
                             cancelHandler: nil,
                             actionHandler: { [weak self] value in
            if let value = Int(value ?? "0") {
                UserInfoCenter.shared.storeValue(.practiceTime, data: value)
                self?.setupRow()
            }
        })
    }
}
