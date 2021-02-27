//
//  ChartViewController.swift
//  stockchart
//
//  Created by Sheldon_Gao on 2021/2/27.
//


import UIKit

//======================================================================
// MARK: - 1、常量/静态变量
//======================================================================

class CanvasViewController: KSBaseViewController {

    //======================================================================
    // MARK: - 2、属性
    //======================================================================
    // MARK: - 2.1、引用类型/值类型
    
    // MARK: - 2.2、UIKit
    var tableView: KSTableView?
    
    //======================================================================
    // MARK: - 3、系统初始化方法/系统生命周期方法
    //======================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCtrl()
    }
    
    //======================================================================
    // MARK: - 4、虚方法
    //======================================================================
    
    //======================================================================
    // MARK: - 5、重写/调用父类方法
    //======================================================================
    
    //======================================================================
    // MARK: - 6、功能初始化方法
    //======================================================================
    /// 初始化数据和视图
    func initializeCtrl() {
        defaultValue()
        createChildViews()
    }
    
    /// 初始化默认值
    func defaultValue() {
    }
    //======================================================================
    // MARK: - 7、系统代理方法 Extension
    //======================================================================

    //======================================================================
    // MARK: - 8、自定义代理方法 Extension
    //======================================================================
    
    //======================================================================
    // MARK: - 9、创建视图方法
    //======================================================================
    /// 创建子控件
    func createChildViews() {
        tableView        = self.createTableView(target: self, separatorStyle: UITableViewCell.SeparatorStyle.none)
        tableView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(self.ks_navigationHeight())
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-self.ks_tabBarHeight())
        })
    }
    //======================================================================
    // MARK: - 10、按钮点击事件
    //======================================================================
    
    //======================================================================
    // MARK: - 11、辅助方法
    //======================================================================
    
    //======================================================================
    // MARK: - 12、控制器跳转
    //======================================================================
    func enterBinanceController() {
        let ctrl = KSBinanceController.init()
        print("run pushView +++");
        /*
        let kAppdelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        let rotation : UIInterfaceOrientationMask = [.landscapeLeft, .landscapeRight]
                kAppdelegate?.blockRotation = rotation
 */
        ctrl.update(market: "eth/btc")
        self.pushViewController(ctrl: ctrl)
    }
    //======================================================================
    // MARK: - 13、网络请求
    //======================================================================
    
    //======================================================================
    // MARK: - 14、懒加载
    //======================================================================
    lazy var datas : [String] = {
        return ["Binance"]
    }()
    
    //======================================================================
    // MARK: - 15、TEST
    //======================================================================

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CanvasViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = KSLineChartCell.initialize(tableView: tableView)
        cell.textLabel?.text = self.datas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        enterBinanceController()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
