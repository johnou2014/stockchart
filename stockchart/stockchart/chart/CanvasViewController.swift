//
//  CanvasViewController.swift
//  ZeroShare
//
//  Created by saeipi on 2019/9/24.
//  Copyright © 2019 saeipi. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftHTTP
import SwiftIconFont
import Alamofire
//======================================================================
// MARK: - 1、常量/静态变量
//======================================================================
import Foundation


class CanvasViewController: KSBaseViewController {
    @IBOutlet private var pkLabel: UILabel!
    @IBOutlet private var userLabel:UILabel!
    @IBOutlet private var stockLabel: UILabel!
    @IBOutlet private var stockNameLabel: UILabel!
    @IBOutlet private var userIdLabel: UILabel!
    @IBOutlet private var stockIdLabel: UILabel!
    @IBOutlet private var thumbnailImageView: UIImageView!
    var watch: Watch?
    //======================================================================
    // MARK: - 2、属性
    //======================================================================
    // MARK: - 2.1、引用类型/值类型
    private var socket: KSWebSocket?
    private var msgMgr: KSSocketMsgMgr = KSSocketMsgMgr.init()
    private var isBar: Bool            = false
    private var isLocal: Bool          = true//是否读取本地数据
    // MARK: - 2.2、UIKit
    private var titleView: KSButton?
    private var followBtn: UIButton!
    var barView: KSTransactionBarView?
    //======================================================================
    // MARK: - 3、系统初始化方法/系统生命周期方法
    //======================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCtrl()
        if self.isLocal {
            readLocalFile()
        }
        if let watch = watch {
            navigationItem.title = watch.stock_name
            pkLabel.text = "pk:" + String(watch.pk)
            userLabel.text = "user:" + watch.user
            stockLabel.text = "stock:" + watch.stock
            stockNameLabel.text = "name:" + watch.stock_name
            userIdLabel.text = "userId:" + String(watch.user_id)
            stockIdLabel.text = "stockId:" + String(watch.stock_id)
            if watch.pk > 40 {
            thumbnailImageView.image = UIImage(from: .themify, code: "stats.up", textColor: .green, backgroundColor: .clear, size: CGSize(width: 200, height: 100))
            } else {
                thumbnailImageView.image = UIImage(from: .themify, code: "stats.down", textColor: .red, backgroundColor: .clear, size: CGSize(width: 200, height: 100))
            }
            //let ctr = KSBinanceController.init()
            //self.view.addSubview(ctr.view)
            print("watch ===",watch.stock)
            
            let ctrl = CanvasViewController.init()
            print("run pushView +++");
            /*
            let kAppdelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
            let rotation : UIInterfaceOrientationMask = [.landscapeLeft, .landscapeRight]
                    kAppdelegate?.blockRotation = rotation
     */
            ctrl.update(market: "eth/btc")
            //self.pushViewController(ctrl: ctrl)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        //消失显示生命周期
        super.viewWillDisappear(animated)
        print("---viewWillDissapear \(self)")
        socket?.activeClose()
        NotificationCenter.default.removeObserver(self)
    }
    deinit {
        socket?.activeClose()
        NotificationCenter.default.removeObserver(self)
        print("------ KSDashboardController deinit ------")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        msgMgr.isProcessing = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if msgMgr.isSubscription {
            msgMgr.isSubscription = false
            if let _titleView = self.titleView {
                update(market: _titleView.titleLabel.text!)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        msgMgr.isProcessing = false
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
    private func initializeCtrl() {
        defaultValue()
        createChildViews()
    }
    
    /// 初始化默认值
    private func defaultValue() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name(rawValue: "Won_Notification_WillEnterForeground"), object: nil)
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
    private func createChildViews() {
        /*
        titleView                              = KSButton.init(textColor: KS_Const_Color_White,
                                                               textFont: KS_Const_Font_Bold_18,
                                                               alignment: NSTextAlignment.center,
                                                               imgName: "ic_nav_triangle_white",
                                                               imgIsLeft: false,
                                                               offset: KS_Const_Point04,
                                                               imgWidth: 12,
                                                               imgHeight: 8)
        titleView?.frame                       = CGRect.init(x: 0, y: 0, width: 150, height: 30)
        self.navigationItem.titleView          = titleView
        updateTitleView()
        titleView?.addTarget(self, action: #selector(onNavTitleClick), for: UIControl.Event.touchUpInside)
        
        followBtn                              = UIButton.init(normalImage: "ic_desborad_follow_normal", selectedImage: "ic_desborad_follow_select")
        followBtn.ks_addTarget(self, action: #selector(onFollowClick))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: followBtn!)
        */
        print("frame =",self.view.frame)
        self.segmentedPager.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - self.ks_navigationHeight())
        self.view.addSubview(self.segmentedPager)
        defaultTai()
        
        if isBar {
            createBarView()
        }
        //self.headerChartView.menuBarView.theDelegate = self
    }
    
    private func createBarView() {
        barView = KSTransactionBarView.init()
        self.view.addSubview(barView!)
        barView!.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(KS_Const_Point64)
            make.bottom.equalToSuperview()
        }
        barView!.buyBtn.ks_addTarget(self, action: #selector(onBuyClick))
        barView!.sellBtn.ks_addTarget(self, action: #selector(onSellClick))
        
    }
    
    private func defaultTai() {
        self.headerChartView.resetDrawChart(isAll: true)
    }
    
    //======================================================================
    // MARK: - 10、按钮点击事件
    //======================================================================
    @objc private func onNavTitleClick() {
        //let title = configure.ask_currency.uppercased() + "/" + configure.bid_currency.uppercased()
        //msgMgr.isSubscription = true
        
        hideIndexMenu()
    }
    
    @objc private func onFollowClick() {
        hideIndexMenu()
    }
    
    @objc private func onBuyClick() {
        hideIndexMenu()
    }
    
    @objc private func onSellClick() {
        hideIndexMenu()
    }
    //======================================================================
    // MARK: - 11、辅助方法
    //======================================================================
    @objc func update(market: String) {
        isBar = true
        let isSucceed = updateConfigure(market: market)
        if isSucceed {
            if (socket != nil) {
                self.unSubscriptionAll()
                self.subscriptionAll(symbol: configure.symbol)
            }
        }
    }
    
    func updateConfigure(market: String) -> Bool {
        let array = market.components(separatedBy:"/")
        if array.count == 2 {
            self.configure.ask_currency = array[0].lowercased()
            self.configure.bid_currency = array[1].lowercased()
            self.configure.symbol       = self.configure.ask_currency + self.configure.bid_currency
            //infoCtrl.updateCurrency(self.configure.ask_currency)
            updateTitleView()
            return true
        }
        return false
    }
    
    private func updateTitleView() {
        //titleView?.update(text: configure.ask_currency.uppercased() + "/" + configure.bid_currency.uppercased(), isCenter: true)
    }
    
    private func hideIndexMenu() {
        self.headerChartView.hiddenTaiKit()
        self.headerChartView.hiddenTimeKit()
    }
    
    @objc private func willEnterForeground() {
        msgMgr.isProcessing = true
    }
    
    private func resetKit() {
        orderBookCtrl.resetKit()
        marketTradeCtrl.resetKit()
        self.headerChartView.resetKit()
    }
    
    //======================================================================
    // MARK: - 12、控制器跳转
    //======================================================================
    
    //======================================================================
    // MARK: - 13、网络请求
    //======================================================================
    private func requestBinanceKlines(isReset: Bool = false) {
        //清空数据
        configure.isSwitch = true
        self.msgMgr.messages.removeAll()
        if isReset {
            self.resetKit()
        }
        
        ASNetManager.request(url: "https://api.binance.com/api/v1/klines?symbol=\(self.configure.symbol.uppercased())&interval=1m", parameters: nil, success: { (result: Any?) in
            if let _result = result {
                let jsons = JSON(_result)
                var candles: [KSChartItem] = [KSChartItem]()
                for json in jsons.arrayValue {
                    let info        = KSChartItem()
                    info.time       = json[0].intValue/1000// 开盘时间
                    //json["k"]["T"]// 这根K线的结束时间
                    info.open   = json[1].stringValue// 开盘价
                    info.high   = json[2].stringValue// 最高价
                    info.low    = json[3].stringValue// 最低价
                    info.close  = json[4].stringValue// 收盘价(当前K线未结束的即为最新价)
                    info.volume = json[5].stringValue// 成交量
                    candles.append(info)
                }
                self.headerChartView.chartView.klineData.removeAll()
                self.headerChartView.chartView.resetChart(datas: candles)
                self.configure.isSwitch = false
                self.headerChartView.resetDrawChart(isAll: true)
            }
        }) { (error: ASRequestError?) in
            
        }
    }
    
    func readLocalFile() {
        //读取ajax
       
        func ks_toTimeStamp2(timeStamp: Double) ->Int {
            let k = NSDate.init(timeIntervalSince1970: timeStamp / 1000)
            let formatter = DateFormatter.init()
            formatter.dateFormat = "YYYY-MM-dd"
            let y = formatter.string(from: k as Date)
            KS_Date_Formatter.dateFormat = "YY-MM-dd"
            let last = KS_Date_Formatter.date(from: y)
            let timeStamp = last?.timeIntervalSince1970
            return Int(timeStamp!)
        }
        if(watch != nil) {
            HTTP.GET("http://easytrade007.com:8080/api/v1/marketdata/\(watch!.stock)/pricehistory/",parameters: ["periodType":"day","period":"30"],headers: ["Authorization":getUserInfo(type: "Authorization")]) {
            response in
            if let err = response.error {
                print("error \(err.localizedDescription)")
                return
            }
            let response = JSON(response.data)
                print("easytrade007 =", response.arrayValue.count)
            var candles: [KSChartItem] = [KSChartItem]()
            for json in response.arrayValue {
                let info    = KSChartItem()
                info.time   = ks_toTimeStamp2(timeStamp: Double(json["datetime"].intValue))// 开盘时间
                info.open   = json["open"].stringValue// 开盘价
                info.high   = json["high"].stringValue// 最高价
                info.low    = json["low"].stringValue// 最低价
                info.close  = json["close"].stringValue// 收盘价(当前K线未结束的即为最新价)
                info.volume = json["volume"].stringValue// 成交量
                candles.append(info)
        }
            self.headerChartView.chartView.klineData.removeAll()
            self.headerChartView.chartView.resetChart(datas: candles)
            self.configure.isSwitch = false
            self.headerChartView.resetDrawChart(isAll: true)
        }
    }
    }
    
    //======================================================================
    // MARK: - 14、懒加载
    //======================================================================
    lazy var segmentedPager: MXSegmentedPager = {
        let segmentedPager        = MXSegmentedPager.init()
        segmentedPager.delegate   = self
        segmentedPager.dataSource = self
        
        // Parallax Header
        segmentedPager.parallaxHeader.view                          = self.headerChartView
        segmentedPager.parallaxHeader.mode                          = MXParallaxHeaderMode.bottom
        segmentedPager.parallaxHeader.height                        = configure.headerHeight
        segmentedPager.parallaxHeader.minimumHeight                 = 0
        
        // Segmented Control customization
        segmentedPager.segmentedControl.selectionIndicatorLocation  = HMSegmentedControlSelectionIndicatorLocation.none
        segmentedPager.segmentedControl.backgroundColor             = UIColor.white
        segmentedPager.segmentedControl.segmentWidthStyle           = HMSegmentedControlSegmentWidthStyle.fixed//默认dixed/dynamic左对齐
        segmentedPager.segmentedControl.titleTextAttributes         = [
            NSAttributedString.Key.foregroundColor: KS_Const_Color_Chart_Ink,
            NSAttributedString.Key.font:KS_Const_Font_Normal_16
        ]
        segmentedPager.segmentedControl.selectedTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: KS_Const_Color_Menu_Text_Selectd,
            NSAttributedString.Key.font:KS_Const_Font_Normal_16
        ]
        segmentedPager.segmentedControl.selectionIndicatorLocation  = HMSegmentedControlSelectionIndicatorLocation.down
        segmentedPager.segmentedControl.selectionIndicatorColor     = KS_Const_Color_Menu_Text_Selectd
        segmentedPager.segmentedControl.selectionIndicatorHeight    = 2
        segmentedPager.segmentedControlEdgeInsets                   = UIEdgeInsets(top: 0, left: 0, bottom: KS_Const_Point02, right: 0)
        
        return segmentedPager
    }()
    
    lazy var headerChartView: KSHeaderChartView = {
        let headerChartView         = KSHeaderChartView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.configure.headerHeight))
        headerChartView.theDelegate = self
        return headerChartView
    }()
    
    lazy var orderBookCtrl: KSOrderBookController = {
        let orderBookCtrl       = KSOrderBookController.init()
        orderBookCtrl.configure = KSDashboardChildConfigure.init(bid: self.configure.bid_currency, ask: self.configure.ask_currency)
        orderBookCtrl.title     = String.ks_localizde("ks_app_global_text_orderbook")
        orderBookCtrl.isBar     = isBar
        return orderBookCtrl
    }()
    
    lazy var marketTradeCtrl: KSMarketTradeController = {
        let marketTradeCtrl       = KSMarketTradeController.init()
        marketTradeCtrl.configure = KSDashboardChildConfigure.init(bid: self.configure.bid_currency, ask: self.configure.ask_currency)
        marketTradeCtrl.title     = String.ks_localizde("ks_app_global_text_market_trade")
        marketTradeCtrl.isBar     = isBar
        return marketTradeCtrl
    }()
    
    lazy var infoCtrl: KSMarketTradeController = {
        let infoCtrl       = KSMarketTradeController.init()
        infoCtrl.configure = KSDashboardChildConfigure.init(bid: self.configure.bid_currency, ask: self.configure.ask_currency)
        infoCtrl.title     = String.ks_localizde("ks_app_global_text_info")
        infoCtrl.isBar     = isBar
        return infoCtrl
    }()
    
    lazy var childCtrls: [UIViewController] = {
        let childCtrls = [orderBookCtrl,marketTradeCtrl,infoCtrl]
        return childCtrls
    }()
    
    lazy var configure: KSDashboardConfigure = {
        let configure          = KSDashboardConfigure.init()
        configure.newConfigure = KSDashboardConfigure.init()
        configure.kline        = KSSingleton.shared.indexConfigure.chartType
        configure.headerHeight = 490
        return configure
    }()
    
    //======================================================================
    // MARK: - 15、TEST
    //======================================================================
    
}

extension CanvasViewController: MXSegmentedPagerDelegate, MXSegmentedPagerDataSource {
    // MARK: - MXSegmentedPagerDataSource
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        return self.childCtrls.count
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
        return self.childCtrls[index].view
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return self.childCtrls[index].title ?? ""
    }
    
    // MARK: - MXSegmentedPagerDelegate
    func heightForSegmentedControl(in segmentedPager: MXSegmentedPager) -> CGFloat {
        return 40
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelectViewWith index: Int) {
        configure.pagerIndex = index
        if index == 0 {
            orderBookCtrl.reloadData()
        }
        else if index == 1 {
            marketTradeCtrl.reloadData()
        }
        hideIndexMenu()
        //self.headerChartView.menuBarView.updateSelected(index: index)
    }
}

// MARK: - Socket
extension CanvasViewController: KSWebSocketDelegate {
    
    func socket(_ socket: KSWebSocket!, didReceivedMessage message: Any!) {
        if let _message = message as? String {
            if let jsonData = _message.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                return;
                let json    = try! JSON(data: jsonData)
                handleBinanceKline(message: json)
            }
        }
    }
    
    func socketDidOpen(_ socket: KSWebSocket!){
        subscriptionAll(symbol: configure.symbol)
    }
    
    func socketDidFail(_ socket: KSWebSocket!) {
        self.msgMgr.messages.removeAll()
    }
}

extension CanvasViewController: KSViewDelegate {
    func ksviewCallback(view: UIView, data: Any?, identifier: String?) {
        ///k线切换
        if identifier == "KSTimePickerView" {
            if self.isLocal {
                self.headerChartView.resetDrawChart(isAll: true)
            }
            else{
                //币安
                if let _data = data as? KSChartMenuInfo {
                    self.unSubscriptionKline(symbol: configure.symbol, kline: _data.identifier)
                    subscriptionKline()
                }
            }
        }
        else if identifier == "KSMenuBarView" {
            let index = data as! Int
            segmentedPager.pager.showPage(at: index, animated: true)
        }
    }
}

// MARK: - 消息处理
extension CanvasViewController {
    
    ///处理币安K线数据
    private func handleBinanceKline(message: JSON) {
        let msg = KSChartItem.formatBinanceMessage(json: message)
        if configure.isSwitch {
            self.msgMgr.recordMessage(chartItem: msg)
        }
        else{
            self.msgMgr.messageAppend(klineDatas: &self.headerChartView.chartView.klineData, chartItem: msg)
            self.headerChartView.chartView.chartView.refreshChart(isAll: false, isDraw: true)
        }
    }
    
    ///处理K线数据
    private func handleKline(message: JSON) {
        let msg = KSChartItem.formatKlineMessage(json: message)
        if configure.isSwitch {
            self.msgMgr.recordMessage(chartItem: msg)
        }
        else{
            let isComplete = self.msgMgr.integrityVerification(lastTime: self.headerChartView.chartView.klineData.last?.time ?? 0, currentTime: msg.time)
            if isComplete == false {
                subscriptionAll(symbol: configure.symbol)
                return
            }
            self.msgMgr.messageAppend(klineDatas: &self.headerChartView.chartView.klineData, chartItem: msg)
            self.headerChartView.chartView.chartView.refreshChart(isAll: false, isDraw: true)
        }
    }
    
    ///市场概要
    private func handleSummary(message: JSON) {
        let msg = KSSummaryInfo.formatSummaryMessage(json: message)
        self.headerChartView.update(summary: msg)
    }
    
    ///处理深度
    private func handleDepth(message: JSON) {
        let msg = KSOrderBookInfo.formatMessage(json: message)
        self.orderBookCtrl.update(orders: msg, configure: configure)
    }
    
    private func handleDetail(message: JSON) {
        let msg = KSTradeDetail.formatTradeMessage(json: message)
        marketTradeCtrl.update(details: msg, configure: self.configure)
    }
}

// MARK: - 发送消息
extension CanvasViewController {
    ///k线
    private func subscriptionKline() {
        self.msgMgr.subscriptionKline(configure: configure, socket: socket)
        //请求K线
        requestBinanceKlines(isReset: true)
    }
    
    private func unSubscriptionKline(symbol: String, kline: String) {
        self.msgMgr.unSubscriptionKline(symbol: symbol, kline: kline, configure: configure, socket: socket)
    }
    
    /// 订阅所有
    func subscriptionAll(symbol: String) {
        //self.msgMgr.subscriptionAll(symbol: symbol, configure: configure, socket: socket)
        //请求K线
        //requestWonKlines(isReset: true)
        requestBinanceKlines(isReset: true)
    }
    
    /// 取消订阅所有
    func unSubscriptionAll() {
        self.msgMgr.unSubscriptionAll(configure: configure, socket: socket)
    }
}
