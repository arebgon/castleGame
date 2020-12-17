//
//  ViewController.swift
//  castleGame
//  Created by Alfredo Rebolloso
//

import UIKit

class ViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var ui_stateWindow_label: UILabel!
    @IBOutlet weak var ui_numberStateWindowClose_label: UILabel!
    @IBOutlet weak var ui_numberStateWindowOpen_label: UILabel!
    @IBOutlet weak var ui_numberStateWindowIZQ_label: UILabel!
    @IBOutlet weak var ui_numberStateWindowDER_label: UILabel!
    @IBOutlet weak var ui_winVisitors_label: UILabel!

    var array : [String] = []
    var stateWindowClose : String = "C"
    var stateWindowOpen : String = "A"
    var stateWindowIZQopen : String = "I"
    var stateWindowDERopen : String = "D"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //State Window after visitors
        let res : [String] = stateWindowAfterVisitors(array: array)
        self.ui_stateWindow_label.text = res.joined(separator:" - ")
        
        let numberObject: numberWindowStateArrayObject = self.numberWindowState(array: res)
        self.printNumberStateWindows(numberObject: numberObject)
        
        let wins = calculateWins(arrayStateWindow: res)
        self.ui_winVisitors_label.text = wins.joined(separator:" , ")

    }
    
    //MARK: - Functions
    
    /** Escriba una función que dado el estado actual de las ventanas devuelva el estado
    de las 64 ventanas en forma de un array de cadenas después de pasar los 64
    visitantes.
     */
    func stateWindowAfterVisitors(array: [String])->[String]{
        var array_status : [String] = []
        //Fill array[string]
        array_status = fillCellFirstTime()
        
        ///FirstVisitor
        array_status = firstVisitor(array: array_status)
        
        ///SecondVisitor
        array_status = secondVisitor(array: array_status)
        
        ///followingVisitors
        for index in 3...64 {
            array_status = followingVisitors(array: array_status, multiple: index)
        }
        
        ///Last Visitor
        array_status = lastVisitor(array: array_status)
        
        return array_status
    }
    
    /**
     Añada una función para devolver los números de los visitantes que ganaron este
     juego. El resultado es un array de enteros.
     */
    func numberVisitorsWin(array: [String])->[Int]{
        var res : [Int] = []
        
        for (index, element) in array.enumerated() {
            if !element.isEmpty {
                if element == "A" {
                    var before : String = ""
                    var after : String = ""
                    if index>0 {
                        before = array[index-1]
                    }
                    if index<63{
                        after = array[index+1]
                    }
                    
                    if after == "C" && before == "C" {
                        res.append(index)
                    }
                }
            }
        }
        return res
    }
    
    /**
        No hay suficientes ganadores, así que añada una segunda función que modifique la regla para que los visitantes cuyo número de ventana esté abierto (A) que ganen.
     */
    func winVisitorsByNumberWindow(array: [String])->[Int]{
        var res : [Int] = []
        
        for (index, element) in array.enumerated() {
            if !element.isEmpty {
                if element == "A" {
                    res.append(index)
                }
            }
        }
        return res
    }
    
    //MARK: - IBAction's
    
    /**
        Se permitirá resetear el estado de las ventanas al estado inicial (todas abiertas
    */
    @IBAction func resetStateWindows(_ sender: Any) {
        let res : [String] = fillCellFirstTime()
        self.ui_stateWindow_label.text = res.joined(separator:" - ")
        
        //Reload other data
        self.reloadData(res: res)
        
    }
    
    /**
        Se permitirá calcular el paso de los 64 visitantes por las 64 ventanas dado el estado actual de las ventanas
    */
    @IBAction func passVisitors(_ sender: Any) {
        let stateWindowNow : String = self.ui_stateWindow_label.text!
        if !stateWindowNow.isEmpty {
            let res : [String] = stateWindowAfterVisitors(array: Array(arrayLiteral: stateWindowNow))
            self.ui_stateWindow_label.text = res.joined(separator:" - ")
            
            //Reload other data
            self.reloadData(res: res)
        }
    }
    
    //MARK: - Design
    
    func printNumberStateWindows(numberObject: numberWindowStateArrayObject){
        self.defaultNumberState()
        for (_, elementArray) in numberObject.array!.enumerated() {
            
            switch elementArray.name {
            case "C":
                self.ui_numberStateWindowClose_label.text = "\(elementArray.name!): \(elementArray.num!)"
                break
            case "A":
                self.ui_numberStateWindowOpen_label.text = "\(elementArray.name!): \(elementArray.num!)"
                break
            case "I":
                self.ui_numberStateWindowIZQ_label.text = "\(elementArray.name!): \(elementArray.num!)"
                break
            case "D":
                self.ui_numberStateWindowDER_label.text = "\(elementArray.name!): \(elementArray.num!)"
                break
            default:
                break
            }
        }
    }
    
    func defaultNumberState() {
        self.ui_numberStateWindowClose_label.text = "\(stateWindowClose): - "
        self.ui_numberStateWindowOpen_label.text = "\(stateWindowOpen): - "
        self.ui_numberStateWindowDER_label.text = "\(stateWindowDERopen): - "
        self.ui_numberStateWindowIZQ_label.text = "\(stateWindowIZQopen): - "
    }
    
    //MARK: - ReloadData
    
    func reloadData(res: [String]){
        let numberObject: numberWindowStateArrayObject = self.numberWindowState(array: res)
        self.printNumberStateWindows(numberObject: numberObject)
        
        let wins = calculateWins(arrayStateWindow: res)
        self.ui_winVisitors_label.text = wins.joined(separator:" , ")
    }

    //MARK: - Other functions
    
    func calculateWins(arrayStateWindow: [String])->[String]{
        let resWin : [Int] = numberVisitorsWin(array: arrayStateWindow)
        let resWin2 : [Int] = winVisitorsByNumberWindow(array: arrayStateWindow)
        var arrChars = [String]()
         for i in 0..<resWin2.count{
            let item = resWin2[i]
            arrChars.append("\(item)")
         }
        
        return arrChars
    }
    
    func numberWindowState(array: [String])->numberWindowStateArrayObject{
        let array_numberStateWindow : numberWindowStateArrayObject = addElementNumberWindowState(arrayStateWindws: array)
        return array_numberStateWindow
    }
    
    func addElementNumberWindowState(arrayStateWindws: [String])->numberWindowStateArrayObject{
        let array_numberStateWindow : numberWindowStateArrayObject = numberWindowStateArrayObject()
        var array_elementsStateWindows : [numberWindowStateObject] = []
        
        for (_, element) in arrayStateWindws.enumerated() {
            if array_elementsStateWindows.count > 0 {
                for (_, elementArray) in array_elementsStateWindows.enumerated() {
                    let enc = encStateWindows(element: element, array: array_elementsStateWindows)
                    if enc == 1 {
                        switch elementArray.name {
                        case "C":
                            if element == "C" {
                                elementArray.num!+=1
                            }
                            break
                        case "A":
                            if element == "A" {
                                elementArray.num!+=1
                            }
                            break
                        case "I":
                            if element == "I" {
                                elementArray.num!+=1
                            }
                            break
                        case "D":
                            if element == "D" {
                                elementArray.num!+=1
                            }
                            break
                        default:
                            break
                        }
                    }else{
                        let object : numberWindowStateObject = numberWindowStateObject.init(name: element, num: 1)
                        array_elementsStateWindows.append(object)
                    }
                }
            }else{
                let object : numberWindowStateObject = numberWindowStateObject.init(name: element, num: 1)
                array_elementsStateWindows.append(object)
            }
        }
        array_numberStateWindow.array = array_elementsStateWindows
        return array_numberStateWindow
    }
    
    func encStateWindows(element: String, array: [numberWindowStateObject])->Int{
        var enc : Int = 0
        for (_, elementArray) in array.enumerated() {
            if element == elementArray.name {
                enc = 1
            }
        }
        return enc
    }
    
    //First Visitor
    func firstVisitor(array: [String])->[String]{
        var res : [String] = array
        for (index, element) in array.enumerated() {
            if !element.isEmpty {
                res[index] = stateWindowIZQopen
            }
        }
        return res
    }
    
    //Second Visitor
    func secondVisitor(array: [String])->[String]{
        var res : [String] = array
        for (index, element) in array.enumerated() {
            if !element.isEmpty {
                if isPar(number: index) {
                    if element != "D" {
                        res[index] = stateWindowDERopen
                    }
                }
            }
        }
        return res
    }
    
    //Visitors 3...63
    func followingVisitors(array: [String], multiple: Int)->[String]{
        var res : [String] = array
        for (index, element) in array.enumerated() {
            if !element.isEmpty {
                if index.isMultiple(of: multiple) {
                    if isPar(number: multiple){
                        //Index 4
                        res[index] = isEvenNumberFistCase(element: element)
                        res[index] = isEvenNumberSecondCase(element: element)
                    }else{
                        //Index 3
                        res[index] = isOddNumberFistCase(element: element)
                        res[index] = isOddNumberSecondCase(element: element)
                    }
                }
            }
        }
        return res
    }
    
    //Last Visitor (64)
    func lastVisitor(array: [String])->[String]{
        var res : [String] = array
        let element = array[array.endIndex-1]
        res[array.endIndex-1] = isEvenNumberFistCase(element: element)
        
        if element == "A" {
            res[array.endIndex-1] = "C"
        }
        return res
    }
    
    //Elemet Odd First Case(Impar)
    func isOddNumberFistCase(element: String)->String{
        var state = element
        if element == "D" {
            state = stateWindowOpen
        }else if element == "C" {
            state = stateWindowIZQopen
        }
        return state
    }
    
    //Element Odd Second Case
    func isOddNumberSecondCase(element: String)->String{
        var state = element
        if element == "A" {
            state = stateWindowDERopen
        }else if element == "D" {
            state = stateWindowClose
        }
        return state
    }
    
    //Elemet Even First Case(Par)
    func isEvenNumberFistCase(element: String)->String{
        var state = element
        if element == "C" {
            state = stateWindowDERopen
        }else if element == "I" {
            state = stateWindowOpen
        }
        return state
    }
    
    //Elemet Even Second Case(Par)
    func isEvenNumberSecondCase(element: String)->String{
        var state = element
        if element == "A" {
            state = stateWindowDERopen
        }else if element == "I" {
            state = stateWindowClose
        }
        return state
    }
    
    //isPar Number
    func isPar(number: Int)->Bool{
        var isPar : Bool = false
        if number % 2 == 0 {
            isPar = true
        }
        return isPar
    }

    //Fill Cell - the first time
    func fillCellFirstTime()->[String]{
        var array : [String] = []
        for _ in 1...64 {
            array.append(stateWindowOpen)
        }
        return array
    }
}


