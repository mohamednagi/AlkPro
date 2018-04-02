import UIKit

class Second: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    @IBAction func BackMeHome(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var numberofauctions: UILabel!
    @IBOutlet weak var firstmsg: UILabel!
    @IBOutlet weak var mazadlbl: UILabel!
    @IBOutlet weak var Timerlbl: UILabel!
    @IBOutlet weak var MyTableView: UITableView!
    @IBOutlet weak var Messagelbl: UILabel!
    @IBOutlet weak var Counterlbl: UITextField!
    @IBOutlet weak var ConfirmBu: UIButton!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var minus: UIButton!  
    var current:Int?
    var datetype:String?
    var count = 5
    var msg:String?
    var max:Int?
    var bids:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerupdatefunc()
        gettingData()
        let firststring = "http://176.31.75.69:7001/elk/elkservice?action=currentauctionz&auid=384&cid=1"
        guard let firstpath = URL(string: firststring) else {return}
        let firstrequest = URLRequest(url: firstpath)
        URLSession.shared.dataTask(with: firstrequest) { (data, response, error) in
            DispatchQueue.main.async {
                do{
                    let json = try(JSONSerialization.jsonObject(with: data!, options: [])) as! [[String:Any]]
                    for result in json {
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
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
            }.resume()
    }
    
    func gettingData(){
        let string = "http://176.31.75.69:7001/elk/elkservice?action=resultzx&auid=1202&cid=19953"
        guard let path = URL(string: string) else {return}
        let request = URLRequest(url: path)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                do{
                    let json = try(JSONSerialization.jsonObject(with: data!, options: [])) as! [String:Any]
                   
                    let results = json["auction"] as! [String:Any]
                    let can = results["can"] as! Int
                    if can == 1 {
                        self.ConfirmBu.isHidden=true
                    }
                    self.max = results["max"] as! Int
                   self.current = results["current"] as! Int
                    DispatchQueue.main.async {
                        self.Counterlbl.text = "\(self.current!)"
                    }
                        let bidder = json["bidder"] as! [[String:Any]]
                        for bid in bidder {
                            // let id = bid["id"] as! Int
                            let name = bid["name"] as! String
                            let date = bid["date"] as! String
                            let obj = CellDetails(name: name, date: date, days: self.current!)
                            self.arr.append(obj)
                        }
                }catch{
                    print(error)
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
                    self.firstmsg.text = "\(self.bids!)"
                    self.msg = auction["msg"] as! String
                    self.Messagelbl.text = self.msg
                }catch{
                    print(error.localizedDescription)
                }
            }
            }.resume()
    }
    func MyTime(time:TimeInterval)->String{
        let mytime = Int(time) % 60
        return String(format: "%02i" , mytime)
    }
    func HideMe(){
        ConfirmBu.isHidden=true
        numberofauctions.isHidden=true
        firstmsg.isHidden=true
        Messagelbl.isHidden=true
        Counterlbl.isHidden=true
        plus.isHidden=true
        minus.isHidden=true
    }
    @objc func timerupdatefunc() {
            if(count > 0) {
                count -= 1
                Timerlbl.text =  MyTime(time: TimeInterval(count + 1))
            }else {
                mazadlbl.text = "انتهى وقت المزاد"
                HideMe()
                Timerlbl.text = ""
            }
    }
    
    var arr:[CellDetails] = []{didSet{DispatchQueue.main.async {self.MyTableView.reloadData()}}}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCell
        cell.Namelbl.text = arr[indexPath.row].name
        cell.Datelbl.text = arr[indexPath.row].date
        cell.Dayslbl.text = String(describing: arr[indexPath.row].days!)
        if indexPath.row == 0 {
            //change the color
            cell.Namelbl.backgroundColor = UIColor.yellow
            cell.Datelbl.backgroundColor = UIColor.yellow
            cell.Dayslbl.backgroundColor = UIColor.yellow
            cell.Namelbl.textColor = UIColor.black
            cell.Datelbl.textColor = UIColor.black
            cell.Dayslbl.textColor = UIColor.black
        }
        return cell
    }
    func CreatAlertCon(message : String){
        let alert = UIAlertController(title: "Error Confirmation", message: message , preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func ConfirmBu(_ sender: UIButton) {
        if Int(self.Counterlbl.text!)! > (self.current! + self.max!){
            CreatAlertCon(message: "الحد الاقصى للمزايده ٣٠ يوم")
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    // msh sh8alen kwis ,, fehom error
    @IBAction func PlusBu(_ sender: UIButton) {
        if Int(self.Counterlbl.text!)! > (self.current! + self.max!){
            CreatAlertCon(message: "الحد الاقصى للمزايده ٣٠ يوم")
        }else{
            current = current! + 1
            self.Counterlbl.text = String(describing: current!)
        }
    }
    @IBAction func MinusBu(_ sender: UIButton) {
        if Int(self.Counterlbl.text!)! > (self.current! + self.max!){
            CreatAlertCon(message: "الحد الاقصى للمزايده ٣٠ يوم")
        }else{
            current = current! - 1
            self.Counterlbl.text = String(describing: current!)
        }
    }
}
