//
//  GoToPickupVC.swift
//  CodeNameFive
//
//  Created by Muhammad Imran on 03/07/2020.
//  Copyright © 2020 ITRID TECHNOLOGIES LTD. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import Alamofire
import CoreLocation

class GoToPickupVC: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var googleMaps: GMSMapView!
    @IBOutlet weak var timeAndDistance: UILabel!
    @IBOutlet weak var resturentName: UILabel!
    @IBOutlet weak var resturentAddress: UILabel!
    @IBOutlet weak var cardView: UIView!
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    var fromLoc : CLLocationCoordinate2D?
    var toLoc : CLLocationCoordinate2D?
    var TrackPolylineArr = [GMSPolyline]()
    var stepsCoords:[CLLocationCoordinate2D] = []
    var iPosition:Int = 0;
    var timer = Timer()
    var marker:GMSMarker?
    var path = GMSPath()
    var animationPath = GMSMutablePath()
    var animationPolyline = GMSPolyline()
    var i: UInt = 0
    var driverLat : CLLocationDegrees?
    var driverLong : CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        cardView.layer.shadowColor = UIColor.white.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 3
        cardView.layer.cornerRadius = 12
        cardView.layer.masksToBounds = false
        googleMaps.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.googleMaps.bringSubviewToFront(cardView)
        googleMaps.delegate = self
        LocationManger()
        SetupMap()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            currentLocation = locationManager.location
            fromLoc = CLLocationCoordinate2DMake((currentLocation?.coordinate.latitude)!, (currentLocation?.coordinate.longitude)!)
            toLoc = CLLocationCoordinate2DMake(((currentLocation?.coordinate.latitude)! + 0.01), ((currentLocation?.coordinate.longitude)! + 0.03))
            drawPolygon(from: fromLoc!, to: toLoc!)
        }
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.timer.invalidate()
    }
    
    
    @IBAction func menuBarButton(_ sender: UIBarButtonItem) {
        GoToAppMenu()
    }
    @IBAction func helpCenterBarButton(_ sender: UIBarButtonItem) {
        
        let helptoCancel : HelpOrCancelVC = self.storyboard?.instantiateViewController(withIdentifier: "HelpOrCancelVC") as! HelpOrCancelVC
        self.presentOnRoot(viewController: helptoCancel)
    }
    @IBAction func callBarButton(_ sender: UIBarButtonItem) {
        callingnNumber()
    }
    @IBAction func deliveryInformationButton(_ sender: UIButton) {
        
        GotoDeliveryInformation()
    }
    func presentOnRoot(viewController : UIViewController){
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(navigationController, animated: false, completion: nil)
        
    }
}


extension GoToPickupVC{
    
    func GoToDashBoard(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardVC")
        navigationController?.pushViewController(newViewController, animated: true)
    }
    func GoToPickup(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "GoToPickupVC")
        navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func GoToAppMenu() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AppMenu")
        navigationController?.pushViewController(newViewController, animated: true)
    }
    func GotoDeliveryInformation() {
        
        let collect : CollectOrderTVC = self.storyboard?.instantiateViewController(withIdentifier: "CollectOrderTVC") as! CollectOrderTVC
        self.presentOnRoot(viewController: collect)
        
    }
    
    
    func phoneNumber(){
        callingnNumber()
    }
    
    func callingnNumber() {
        if let url = URL(string: "tel://\("+923084706656")") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }
    }
    
}

extension GoToPickupVC {
    
    func LocationManger(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.distanceFilter = 50
        locationManager?.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
    }
    
    func SetupMap() {
        googleMaps.isMyLocationEnabled = true
    }
    //MARK:- Call API for polyline points
    func drawPolygon(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        googleMaps.isHidden = false
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=AIzaSyBXfR7Zu7mvhxO4aydatsUY-VUH-_NG15g") else {
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    if json["status"] as! String == "OK"{
                        let routes = json["routes"] as! [[String:AnyObject]]
                        OperationQueue.main.addOperation({
                            for route in routes{
                                let routeOverviewPolyline = route["overview_polyline"] as! [String:String]
                                let points = routeOverviewPolyline["points"]
                                self.path = GMSPath.init(fromEncodedPath: points!)!
                                let polyline = GMSPolyline(path: self.path)
                                self.drawPath(polyline: polyline)
                            }
                        })
                    }
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
        
    }
    
    //MARK:- Draw polyline
    
    private func drawPath(polyline : GMSPolyline){
        
        //DispatchQueue.main.async {
            
            polyline.strokeWidth = 6.0
            polyline.strokeColor = #colorLiteral(red: 0, green: 0.8465872407, blue: 0.7545004487, alpha: 1)
            polyline.map = self.googleMaps
            self.addMarker()
//        let bounds = GMSCoordinateBounds(path: path)
//            self.googleMaps.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
            let bounds = GMSCoordinateBounds(coordinate: self.fromLoc!, coordinate: self.toLoc!)
            let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 170, left: 30, bottom: 30, right: 30))
            self.googleMaps.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 20.0))
            self.googleMaps.animate(toZoom: 10)
            self.googleMaps.animate(toViewingAngle: 30)
            self.googleMaps!.moveCamera(update)
          self.timer = Timer.scheduledTimer(timeInterval: 0.003, target: self, selector: #selector(animatePolylinePath), userInfo: nil, repeats: true)
            
        //}
    }
    
    @objc func animatePolylinePath() {
        if (self.i < self.path.count()) {
            self.animationPath.add(self.path.coordinate(at: self.i))
            self.animationPolyline.path = self.animationPath
            self.animationPolyline.strokeColor = UIColor.black
            self.animationPolyline.strokeWidth = 3
            self.animationPolyline.map = self.googleMaps
            self.i += 1
        }
        else {
            self.i = 0
            self.animationPath = GMSMutablePath()
            self.animationPolyline.map = nil
        }
    }
    func addMarker(){
        
        let customerIcon = self.imageWithImage(image: UIImage(named: "Customer")!, scaledToSize: CGSize(width: 50.0, height: 50.0))
        let dmarker = GMSMarker()
        dmarker.icon = customerIcon
        dmarker.position = self.toLoc!
        dmarker.map = self.googleMaps
        
    }
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        googleMaps.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        driverLat = location.coordinate.latitude
        driverLong = location.coordinate.longitude
               
        
        
    }
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            googleMaps.isMyLocationEnabled = true
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    func ChangedTheRoute() {
        if !(GMSGeometryIsLocationOnPathTolerance(CLLocationCoordinate2D(latitude: driverLat!, longitude: driverLong!), self.path, true, 3)) {
                       
            drawPolygon(from: CLLocationCoordinate2D(latitude: driverLat!, longitude: driverLong!), to: toLoc!)
        }
    }
}

