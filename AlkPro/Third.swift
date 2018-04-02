//
//  Third.swift
//  AlkPro
//
//  Created by Sierra on 4/1/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import UIKit

class Third: UIViewController {

    @IBOutlet weak var pricetxt: UITextField!
    @IBOutlet weak var confirmtxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    func CreatAlertCon(message : String){
        let alert = UIAlertController(title: "حدث خطأ", message: message , preferredStyle: .alert)
       
        let ok = UIAlertAction(title: "حسنا", style: .default, handler: nil)
        
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func sendBu(_ sender: UIButton) {
        if pricetxt.text != confirmtxt.text {
            CreatAlertCon(message: "من فضلك أعد ادخال المبلغ")
            confirmtxt.text = ""
            return
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
extension UITextField {
    @IBInspectable var PlaceHolderColor:UIColor{
        get{return self.PlaceHolderColor}
        set{self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor:newValue])}
    }
}

