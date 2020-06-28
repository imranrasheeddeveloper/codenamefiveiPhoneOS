//
//  TripDayDataVC.swift
//  CodeNameFive
//
//  Created by Muhammad Imran on 25/06/2020.
//  Copyright © 2020 ITRID TECHNOLOGIES LTD. All rights reserved.
//

import UIKit

class TripDayDataVC: UIViewController {
    
    
    let resturantName = ["Golden Chicken","Hardess","Monal","Second Cup","Gloria Jeans","Khrachi Prhata Roll","What a Prhata","Cafe lanto"]
    let time = ["10:21 - 21:12-Tip","10:21 - 21:12-Tip","10:21 - 21:12-Tip","10:21 - 21:12-Tip","10:21 - 21:12-Tip","10:21 - 21:12-Tip","10:21 - 21:12-Tip","10:21 - 21:12-Tip" ]
    let earn = ["$100","$100","$100","$100","$100","$100","$100","$100"]
    var navigationBarTitle : String?
    @IBOutlet weak var dayDataEarnView: UIView!
    @IBOutlet weak var totalTrips: UILabel!
    @IBOutlet weak var totalEarning: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
             navigationController?.navigationBar.topItem?.title = navigationBarTitle
             setBackButton()
             dayDataEarnView.layer.shadowColor = UIColor.gray.cgColor
             dayDataEarnView.layer.shadowOpacity = 0.5
             dayDataEarnView.layer.shadowOffset = .zero
             dayDataEarnView.layer.shadowRadius = 4
             dayDataEarnView.layer.masksToBounds = false
             dayDataEarnView.fadeIn()
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

extension TripDayDataVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return resturantName.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "day", for: indexPath) as! TripDayDataCell
        cell.resturantNameLbl.text = resturantName[indexPath.row]
        cell.timeLbl.text = time[indexPath.row]
        cell.earnLbl.text = earn[indexPath.row]
        return cell
       }
       
       
       func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
           
           if traitCollection.userInterfaceStyle == .light {
               let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
               headerView.textLabel!.textColor = UIColor.darkGray
               headerView.textLabel!.font = UIFont(name: "Poppins-Regular", size: 15)
               headerView.backgroundView = UIView()
               headerView.backgroundColor = .clear
               
           } else {
               
               let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
               headerView.textLabel!.textColor = UIColor.darkGray
               headerView.textLabel!.font = UIFont(name: "Poppins-Regular", size: 15)
               
               
               headerView.backgroundView = UIView()
               headerView.backgroundColor = .clear
               
               let header = view as! UITableViewHeaderFooterView
               header.textLabel?.textColor = .white
               
           }
           
       }
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
           return UIView()
       }


        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            cell.selectionStyle = .none
           cell.accessoryView = UIImageView(image: UIImage(named: "chevron-right"))
          }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                         let vc = storyBoard.instantiateViewController(withIdentifier: "TripDayDataVC") as! TripDayDataVC
        navigationController?.navigationBar.topItem?.title =  resturantName[indexPath.row]
        navigationController?.pushViewController(vc, animated: false)
        
    }
}
