//
//  OrderDetailVC.swift
//  CodeNameFive
//
//  Created by Muhammad Imran on 25/06/2020.
//  Copyright © 2020 ITRID TECHNOLOGIES LTD. All rights reserved.
//

import UIKit

class OrderDetailVC: UIViewController {
    
    
    let detail = ["Trip fee","Surge fee","Tip","Adjustment"]
    let earntDetail = ["$3.00","$4.00","$0.55","$0.33"]
    var orderedResturantName : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "#14792"
        setBackButton()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MainMenuTableViewController.BackviewController(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    @objc func BackviewController(gesture: UIGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    func setBackButton(){
        let button: UIButton = UIButton (type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "back"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(backButtonPressed(btn:)), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(x: 0 , y: 0, width: 30, height: 30)
        
        let barButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.leftBarButtonItem = barButton
    }
    @objc func backButtonPressed(btn : UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
}


extension OrderDetailVC : UITableViewDelegate,UITableViewDataSource{

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return detail.count
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "orderdetail", for: indexPath) as! OrderDetailCell
            cell.ResturantName.text = orderedResturantName
            cell.travelDistance.text = "2.2 mi"
            cell.timeandTip.text = "21:21 - 21:40 - 50m"
            return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as! OrderDetailCell
            cell.detail.text = detail[indexPath.row]
            cell.earnLbl.text = earntDetail[indexPath.row]
            return cell
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "total", for: indexPath) as! OrderDetailCell
            cell.Total.text = "Total"
            cell.totalEarnLbl.text = "$7.88"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.backgroundView = UIView()
        headerView.backgroundColor = .clear
      
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        if indexPath.section == 2{
            if indexPath.row == 0{
                cell.backgroundColor = .clear
            }
        }
        cell.selectionStyle = .none
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2{
            return CGFloat.leastNormalMagnitude
        }
        else{
            return 20
        }
    }
}
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                         let vc = storyBoard.instantiateViewController(withIdentifier: "TripDayDataVC") as! TripDayDataVC
//        navigationController?.navigationBar.topItem?.title =  resturantName[indexPath.row]
//        navigationController?.pushViewController(vc, animated: false)
//
//    }
