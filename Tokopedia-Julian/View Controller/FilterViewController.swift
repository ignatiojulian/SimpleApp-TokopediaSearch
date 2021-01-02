//
//  FilterViewController.swift
//  Tokopedia-Julian
//
//  Created by Ignatio Julian on 1/2/21.
//

import UIKit




class FilterViewController: UIViewController {
    
    @IBOutlet weak var txtMinP: UITextField!
    @IBOutlet weak var txtMaxP: UITextField!
    
    @IBOutlet weak var switchOfficial: UISwitch!
    @IBOutlet weak var switchWholesale: UISwitch!
    @IBOutlet weak var switchGold: UISwitch!
    
    var minPrice = 0
    var maxPrice = 0
    var gold = 0
    var wholesale = false
    var official = false
    var query = ""
    
    
    let pickerValue = [10000, 25000, 50000, 100000, 500000, 1000000, 3000000, 5000000, 10000000, 30000000, 50000000, 75000000, 100000000]
    override func viewDidLoad() {
        super.viewDidLoad()
        let pickerview = UIPickerView()
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: "donePicker")
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        pickerview.delegate = self
        pickerview.dataSource = self
        
        txtMinP.inputView = pickerview
        txtMinP.inputAccessoryView = toolBar
        txtMaxP.inputView = pickerview
        txtMaxP.inputAccessoryView = toolBar
        
        txtMinP.text = "IDR \(String(minPrice))"
        txtMaxP.text = "IDR \(String(maxPrice))"
        if wholesale {
            switchWholesale.isOn = true
        }else{
            switchWholesale.isOn = false
        }
        
        if official{
            switchOfficial.isOn = true
        }else{
            switchOfficial.isOn = false
        }
        
        if gold > 1{
            switchGold.isOn = true
        }else{
            switchGold.isOn = false
        }
        
        switchWholesale.addTarget(self, action: #selector(wholesaleStateChanged(switchState:)), for: UIControl.Event.valueChanged)
        switchGold.addTarget(self, action: #selector(GoldStateChange(switchState:)), for: UIControl.Event.valueChanged)
        switchOfficial.addTarget(self, action: #selector(officialStateChange(switchState:)), for: UIControl.Event.valueChanged)

        // Do any additional setup after loading the view.
    }

    @IBAction func reset(_ sender: Any) {
        minPrice = 50000
        maxPrice = 500000
        gold = 0
        wholesale = false
        official = false
        txtMinP.text = "IDR \(String(minPrice))"
        txtMaxP.text = "IDR \(String(maxPrice))"
        switchWholesale.setOn(false, animated: true)
        switchOfficial.setOn(false, animated: true)
        switchGold.setOn(false, animated: true)
        
    }
    
    @IBAction func btnApply(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let mainstoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "search") as! SearchViewController
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "first") as! ViewController
    
        viewcontroller.count = 0
        viewcontroller.minPrice = minPrice
        viewcontroller.maxPrice = maxPrice
        viewcontroller.wholesale = wholesale
        viewcontroller.official = official
        viewcontroller.gold = gold
        viewcontroller.query = query
        
        navigationController?.setViewControllers([vc, viewcontroller], animated: true)
        
    }
    
    @objc func wholesaleStateChanged(switchState: UISwitch){
        if switchState.isOn{
            wholesale = true
            
        }else{
            wholesale = false
        }
    }
    
    @objc func GoldStateChange(switchState: UISwitch) {
        if switchState.isOn{
            gold = 2
        }else{
            gold = 0
        }
    }
    
    @objc func officialStateChange(switchState: UISwitch){
        if switchState.isOn{
            official = true
        }else{
            official = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}
extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValue.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerValue[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if txtMinP.isEditing{
            txtMinP.text = "IDR \(String(pickerValue[row]))"
            minPrice = pickerValue[row]
        }
        if txtMaxP.isEditing {
            txtMaxP.text = "IDR \(String(pickerValue[row]))"
            maxPrice = pickerValue[row]

        }
    }
}
