//
//  CSVCLASS.swift
//  Covtrace
//
//  Created by Neel Mehta on 4/24/20.
//  Copyright © 2020 Covtracers. All rights reserved.
//

import Foundation
class CSVCLASS : NSObject{
func openCSV(fileName:String, fileType: String)-> String!{
    guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
        else {
            return nil
    }
    do {
        let contents = try String(contentsOfFile: filepath, encoding: .utf8)

        return contents
    } catch {
        print("File Read Error for file \(filepath)")
        return nil
    }
}

    func parseCSV(state:String, county:String)->String{
    
    let dataString: String! = openCSV(fileName: "jhulinks", fileType: "csv")
    var items: [(String, String, String)] = []
    let lines: [String] = dataString.components(separatedBy: NSCharacterSet.newlines) as [String]

    for line in lines {
       var values: [String] = []
       if line != "" {
           if line.range(of: "\"") != nil {
               var textToScan:String = line
               var value:String?
               var textScanner:Scanner = Scanner(string: textToScan)
            while !textScanner.isAtEnd {
                   if (textScanner.string as NSString).substring(to: 1) == "\"" {


                       textScanner.currentIndex = textScanner.string.index(after: textScanner.currentIndex)

                       value = textScanner.scanUpToString("\"")
                       textScanner.currentIndex = textScanner.string.index(after: textScanner.currentIndex)
                   } else {
                       value = textScanner.scanUpToString(",")
                   }

                    values.append(value! as String)

                if !textScanner.isAtEnd{
                        let indexPlusOne = textScanner.string.index(after: textScanner.currentIndex)

                    textToScan = String(textScanner.string[indexPlusOne...])
                    } else {
                        textToScan = ""
                    }
                    textScanner = Scanner(string: textToScan)
               }

               // For a line without double quotes, we can simply separate the string
               // by using the delimiter (e.g. comma)
           } else  {
               values = line.components(separatedBy: ",")
           }
            
            // Put the values into the tuple and add it to the items array
            let item = (values[0], values[1], values[2])
            items.append(item)
            
            if(item.1 == state && item.0 == county ){
                
                let link = item.2
                //print(link)
                return link
            }
         
            //print(item.0)
            //print(item.1)
            //print(item.2)
           
        }
    }
        return("Not found")
}

}




