//
//  detailServiceViewController.swift
//  Jeeran
//
//  Created by Nrmeen Tomoum on 6/9/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class DetailServiceViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{
//    private var papersDataSource = PapersDataSource()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var allReviews: UIButton!
    @IBOutlet weak var loc: UIButton!
    @IBOutlet weak var callUs: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var openHour: UILabel!
    @IBOutlet weak var rateS: UILabel!
    @IBOutlet weak var serviceAddress: UILabel!
    @IBOutlet weak var aboutServiceName: UILabel!
    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var favoriteLabel: UILabel!
    var main_Service_id : Int?
    var service_place_id :Int?
    var sub_service_id : Int?
    var  serviceName : String?
    var serviceShow : ResponseShowServicePlace?
    var servicesPlace = [ResponseServiceList]()
    var CollectionList = [Paper]()
    var servicesReview = [Review]()
    var latitude :Double?
    var longitude :Double?
    var telephone : String?
    var images : [Image]?
     var paper : Paper?
    override func viewDidLoad() {
        
        self.navigationItem.title = serviceName
        self.textView.contentOffset.y = 0
        self.allReviews.layer.cornerRadius = 5.0;
        self.callUs.layer.cornerRadius = 5.0;
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailServiceViewController.labelTapped(_:)))
        locationLabel.addGestureRecognizer(tapRecognizer)
        //  loc.addGestureRecognizer(tapRecognizer)
        WebserviceManager.showServicesPlace("http://jeeran.gn4me.com/jeeran_v1/serviceplace/show", header:["Authorization": ServicesURLs.token], parameters: ["service_place_id":sub_service_id!],result: { (servicesPlace :ResponseShowServicePlace,code:String?) -> Void in
            self.serviceShow = servicesPlace
            print("444040040400404040040404044004",servicesPlace.images?.count)
               print("444040040400404040040404044004",(servicesPlace.images?[0].origninal)!)
            self.images = servicesPlace.images
            self.name.text = self.serviceShow?.servicePlace?[0].title
             self.service_place_id = self.serviceShow?.servicePlace?[0].service_place_id
            self.telephone = self.serviceShow?.servicePlace?[0].mobile_1
            self.rateS.text = String((self.serviceShow?.servicePlace?[0].total_rate)!)
            self.aboutServiceName.text = "About "+(self.serviceShow?.servicePlace?[0].title)!
            
            print("rating value ", String((self.serviceShow?.servicePlace?[0].total_rate)!))
            
            WebserviceManager.getImage( (self.serviceShow?.servicePlace?[0].cover_image)! , result: { (image, code) in
                self.serviceImage.image = image
            })
            
            
            self.openHour.text =  self.serviceShow?.servicePlace?[0].opening_hours
            self.serviceAddress.text = self.serviceShow?.servicePlace?[0].address
            self.textView.text = self.serviceShow?.servicePlace?[0].description
            self.servicesReview = (self.serviceShow?.review)!
            print("latitute",(self.serviceShow?.servicePlace?[0].latitude)!)
            self.latitude = (self.serviceShow?.servicePlace?[0].latitude)!
            self.longitude = (self.serviceShow?.servicePlace?[0].longitude)!
            print("ddddd",self.servicesReview.count)
      //      print("ddddd",self.servicesReview[0].created_at!)
            WebserviceManager.getImage((self.serviceShow?.servicePlace?[0].logo)!, result: { (image, code) in
                self.serviceImage.image = image
            })
            }
        )
        WebserviceManager.getServicesPlaceList(ServicesURLs.servicePlaceListURL(), header:["Authorization": ServicesURLs.token], parameters: ["service_sub_category_id":main_Service_id!],result: { (servicesPlace :[ResponseServiceList],code:String?) -> Void in
            self.servicesPlace = servicesPlace
            self.fillData(servicesPlace)
            print("ghhhhh",servicesPlace.count,"ffffid ",self.main_Service_id!)
           // PapersDataSource.subServicesCategory = servicesPlace
        //    print("PapersDataSource.subServicesCategory",PapersDataSource.subServicesCategory.count)
            self.collectionView.reloadData()
            print("here")
            }
        )
        
        //        WebserviceManager.getSubServices("http://jeeran.gn4me.com/jeeran_v1/serviceplacecategory/list",header:["Authorization": ServicesURLs.token], parameters: ["main_category":1],result: {(mainServices :[ResponseSubServices],code:String?)->Void
        //            in
        //         //   self.subServicesCategory = mainServices
        //            print("here",mainServices.count)
        //            self.collectionView.reloadData()
        //            PapersDataSource.subServicesCategory = mainServices
        //        })
        // Do any additional setup after loading the view.
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        self.collectionView.reloadData()
    }
    
    func  fillData(servicesPlace:[ResponseServiceList] ) -> Void {
        for item in servicesPlace {
            //var paper = Paper(caption: <#T##String#>, section: <#T##String#>, index: <#T##Int#>, rate: <#T##Int#>, name: <#T##String#>)
            paper = Paper(caption: "ddd",imageName: item.logo!, section: "1", index: 1,rate:3 ,name: item.title!)
            // paper!.name="Nrmeen"
            
           // print("image", item.logo!)
//            WebserviceManager.getImage(item.logo! , result: { (image, code) in
//                print("hy ana nrmeen")
//                self.paper!.imageName = image
//                print(image)
//            })
            CollectionList.append(paper!)
        }
    }
    func labelTapped(gestureRecognizer: UITapGestureRecognizer) {
        loc.imageView?.image = UIImage(named: "location-icon-active")
        
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        //  let tappedImageView = gestureRecognizer.view!
        //     let storyBoard = UIStoryboard(name: "MainServices", bundle: nil)
        //          let mapController = storyboard!.instantiateViewControllerWithIdentifier("MapController") as MapController
        //
        //        self.navigationController.pushViewController(secondViewController, animated: true)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "serviceReview"
        {
            let view = segue.destinationViewController as! ServiceRate
         //   view.servicesReview = servicesReview
            view.serviceName = self.serviceName
            view.service_place_id = self.service_place_id
          //  view.isOwner =
        }
        if segue.identifier == "ServiceMap"
        {
            let view = segue.destinationViewController as! MapController
            view.latitude = self.latitude
            view.longitude = self.longitude
            view.serviceName = self.serviceName
            view.servicePlasceName = self.name.text
            
        }
        if segue.identifier == "ViewImages"
        {
            let view = segue.destinationViewController as! PhotosShow
            view.imageNames = images!
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let kWhateverHeightYouWant = 145
        return CGSizeMake(collectionView.bounds.size.width/3, CGFloat(kWhateverHeightYouWant))
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    //CollectionView
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // print("papersDataSource.count",papersDataSource.count)
        //return papersDataSource.count
        return servicesPlace.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CollectionCell
        
        var cellCollection : Paper?
    //    print("=====================",PapersDataSource.subServicesCategory.count)
        if servicesPlace.count == 0
        {
            cellCollection = Paper(caption: "ddd",imageName:"http://static1.yellow-pages.ph/business_photos/438185/sun_mall_thumbnail.png" , section: "1", index: 1,rate: 3,name: "Sun Moll")
            
//            WebserviceManager.getImage("http://static1.yellow-pages.ph/business_photos/438185/sun_mall_thumbnail.png" , result: { (image, code) in
//                cellCollection?.imageName = image
//                //self.collectionView.reloadData()
//            })
            
        }
        else
        {
            cellCollection = CollectionList[indexPath.row]
            //  print("heraratenig",self.servicesPlace[indexPath.row].)
            //  for subService in PapersDataSource.subServicesCategory {
//            paper = Paper(caption: "ddd", section: "1", index: 1,rate:3 ,name: self.servicesPlace[indexPath.row].title!)
//           // paper!.name="Nrmeen"
//            
//            print("image", self.servicesPlace[indexPath.row].logo!)
//            WebserviceManager.getImage( self.servicesPlace[indexPath.row].logo! , result: { (image, code) in
//                 print("hy ana nrmeen")
//                self.paper!.imageName = image
//                print(image)
//            })
            
        }
        //   }
        //        if let paper = papersDataSource.paperForItemAtIndexPath(indexPath) {
        cell.paper = cellCollection
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.grayColor().CGColor
        //            //Color().CGColor
        //            //e6e6e8
        //        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //  if let paper = papersDataSource.paperForItemAtIndexPath(indexPath) {
        let viewDetailService =  self.storyboard?.instantiateViewControllerWithIdentifier("DetailsSubView") as! DetailServiceViewController
        viewDetailService.main_Service_id = main_Service_id!
        viewDetailService.sub_service_id = self.servicesPlace[indexPath.row].service_place_id!
        viewDetailService.serviceName = serviceName
        print(serviceName)
        self.navigationController?.pushViewController(viewDetailService, animated: true)
        // }
    }
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //
    //        if segue.identifier=="MasterToDetail" {
    //
    //            let view =  DetailServiceViewController()
    //            view.main_Service_id = 1
    //            view.serviceName = serviceName
    //            self.navigationController?.pushViewController(view, animated: true)
    ////            let subService = segue.destinationViewController as! SubServices
    ////            subService.main_Service_id = index!
    ////            subService.serviceName = nameOfService
    //        }
    //    }
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        if segue.identifier == "MasterToDetail" {
    //            let detailViewController = segue.destinationViewController as! DetailViewController
    //            detailViewController.paper = sender as? Paper
    //            detailViewController
    //        }
    //    }
    @IBAction func showMoreOptions(sender: AnyObject) {
        //        setCurrentDiscussion(sender)
        //        print(currentDiscussion.id)
        let moreOprionsActionSheet : UIAlertController = UIAlertController(title: "Please select option", message: "", preferredStyle: .ActionSheet)
        //
        //        if currentDiscussion.isOwner == 1 {
        moreOprionsActionSheet.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (topicActionSheetClosure) in
            //   self.toggleNetworkAnimator(1)
            //   self.serviceLayer.deleteDiscussion(self.currentDiscussion.id!)
        }))
        //        }
        //
        //
        //
        moreOprionsActionSheet.addAction(UIAlertAction(title: "Edit", style: .Default, handler: { (topicActionSheetClosure) in
            
            //     self.setCurrentDiscussion(sender)
            
            //let reportReasonsView : DiscussionReport = self.storyboard!.instantiateViewControllerWithIdentifier("DiscussionReport") as! DiscussionReport
            // reportReasonsView.reportTypeId = 4
            //    reportReasonsView.reportId = self.currentDiscussion.id
            //  self.navigationController?.pushViewController(reportReasonsView, animated: true)
        }))
        //
        
        moreOprionsActionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) in
            
        }))
        
        self.presentViewController(moreOprionsActionSheet, animated: true, completion: nil)
    }
   
    
    @IBAction func addToFavourite(sender: AnyObject) {
        
         //   print("------------------",self.service_place_id!)
       self.favorite.setImage(UIImage(named: "favorite-icon-active.png"), forState: UIControlState.Normal)
        //self.favorite.setColor(UIColor.redColor(), forState: UIControlState.Normal)
        self.favoriteLabel.textColor = UIColor.redColor()
        WebserviceManager.addServiceFavorit(ServicesURLs.servicePlaceFavoriteAddURL(), header:["Authorization":ServicesURLs.token], parameters: ["service_places_id":self.service_place_id!]) { (result, code) in
            print("ggggggg:::::",(result.result?.errorcode)!)
            switch (result.result?.errorcode)!
            {
            case 0:
        
            let alert = UIAlertController(title: "Services", message: "Add service place Done.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
                break
            case 3:
                let alert = UIAlertController(title: "Services", message: result.result?.message!, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                break
            default :
                break
                
            }
        }
        
        
        
    }
    
    
    
    @IBAction func Showphotos(sender: AnyObject) {
        
        
    
        
        
        
    }
    @IBAction func Back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        //        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func CallUs(sender: AnyObject) {
        
    //    let url:NSURL = NSURL(string: "tel:"+telephone!)!
     let url:NSURL = NSURL(string: "tel:"+telephone!)!
        print("tel ",telephone!)
        UIApplication.sharedApplication().openURL(url)
    }
}
