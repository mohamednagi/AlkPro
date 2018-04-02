import UIKit

class ViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle{return.lightContent}
    @IBOutlet weak var ProductImage: UIImageView!
    @IBOutlet weak var ProductName: UILabel!
    @IBOutlet weak var Timerlbl: UILabel!
    @IBOutlet weak var DaysCount: UITextField!
    @IBOutlet weak var Sendingoutlet: UIButton!
    @IBOutlet weak var MaxDaysNum: UILabel!
    var productName:String?
    var productImage:String?
    var start:Bool?
    var finish:Bool?
    var timerType:Int?
    var max:Int?
    var hide:Bool?
    var datetype:String?
    var count = 5
    var bidtype:Int?
    var days:Int?
    var bids:Int?
    
    func CreatAlertCon(message : String){
        let alert = UIAlertController(title: "Error Confirmation", message: message , preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        AuctionAvailable()
        timerupdatefunc()
        HideMe()
         let secondstring = "http://176.31.75.69:7001/elk/elkservice?action=resultzx&auid=1202&cid=19953"
        guard let secondpath = URL(string: secondstring) else {return}
        let secondrequest = URLRequest(url: secondpath)
        URLSession.shared.dataTask(with: secondrequest) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    do{
                        let json = try(JSONSerialization.jsonObject(with: data!, options: [])) as! [String:Any]
                        let results = json["auction"] as! [String:Any]
                        self.days = results["current"] as! Int
                        self.DaysCount.text = "\(self.days!)"
                        self.bidtype = results["bidtype"] as! Int
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
            }.resume()
        let firststring = "http://176.31.75.69:7001/elk/elkservice?action=resultzx&auid=1&cid=19953"
        guard let firstpath = URL(string: firststring) else {return}
        let firstrequest = URLRequest(url: firstpath)
        URLSession.shared.dataTask(with: firstrequest) { (data, response, error) in
            DispatchQueue.main.async {
                do{
                    let json = try(JSONSerialization.jsonObject(with: data!, options: [])) as! [String:Any]
                    let auction = json["auction"] as! [String:Any]
                    self.bids = auction["bids"] as! Int
                     print(self.bids!)
                }catch{
                    print(error.localizedDescription)
                }
            }
        }.resume()
        let string = "http://176.31.75.69:7001/elk/elkservice?action=currentauctionz&auid=384&cid=1"
        guard let path = URL(string: string) else {return}
        let request = URLRequest(url: path)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                do{
                    let json = try(JSONSerialization.jsonObject(with: data!, options: [])) as! [[String:Any]]
                    for result in json {
                        self.max = result["max"] as? Int
                        self.start = result["started"] as? Bool
                        self.finish = result["finished"] as? Bool
                        let productName = result["name"] as! String
                        let productImage = result["image"] as! String
                        self.datetype = result["datetype"] as! String
                        if self.datetype == "1" {
                            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerupdatefunc), userInfo: nil, repeats: true)
                        }else if self.datetype == "2" {
                            Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(self.timerupdatefunc), userInfo: nil, repeats: true)
                        }else if self.datetype == "3" {
                            Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector(self.timerupdatefunc), userInfo: nil, repeats: true)
                        }else if self.datetype == "4" {
                            Timer.scheduledTimer(timeInterval: 86400, target: self, selector: #selector(self.timerupdatefunc), userInfo: nil, repeats: true)
                        }
                        self.hide = result["hide"] as! Bool
                        let photo = "http://elkdeals.com/admin/uploads/\(productImage)"
                        let url = URL(string: photo)
                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                            if error != nil {
                                print(error?.localizedDescription)
                            }else{
                                DispatchQueue.main.async{
                                    self.ProductImage.image = UIImage(data: data!)
                                    self.ProductName.text = productName
                                }
                            }
                        }).resume()
                        let msg = result["msg"] as! String
                        self.MaxDaysNum.text = msg
                    }
                }catch{
                    print(error)
                }
            }
            }.resume()
    }
    func MyTime(time:TimeInterval)->String{
        let mytime = Int(time) % 60
        return String(format: "%02i" , mytime)
    }
    @objc func timerupdatefunc() {
                if(count > 0) {
                    count -= 1
                Timerlbl.text =  MyTime(time: TimeInterval(count + 1))
                    Sendingoutlet.isHidden=true
                }else {
                    Sendingoutlet.isHidden=false
                    Timerlbl.text=""
                }
    }
    func HideMe(){
        if hide == true {
            Sendingoutlet.isHidden = true
        }else{
            Sendingoutlet.isHidden = true
        }
    }
    func AuctionAvailable(){
        if start == false {
            Sendingoutlet.isHidden = true
        }else if start == true || finish == true{
            Sendingoutlet.isHidden = true
        }else{
            Sendingoutlet.isHidden=false
        }
    }

    @IBAction func SendingBu(_ sender: UIButton) {
        if self.bidtype! == 0  && Int(DaysCount.text!)! <= 5000{          // change it to 1 to match the requirments
            performSegue(withIdentifier: "new", sender: nil)
        }else if self.bidtype! == 1 && Int(DaysCount.text!)! <= 5000{
            performSegue(withIdentifier: "old", sender: nil)
        }else {
            CreatAlertCon(message: "الحد الأقصى ٥٠٠٠")
        }
    }
    
    @IBAction func Resultbu(_ sender: UIButton) {
        if Int(DaysCount.text!)! <= 5000 {
        performSegue(withIdentifier: "old", sender: nil)
        }else{
            CreatAlertCon(message: "الحد الأقصى ٥٠٠٠")
        }
    }
    @IBAction func OpinionBu(_ sender: UIButton) {
        
    }
}
