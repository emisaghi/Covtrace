//
//  CSVCLASS.swift
//  Covtrace
//
//  Created by Neel Mehta on 4/24/20.
//  Copyright © 2020 Covtracers. All rights reserved.
//

import Foundation

//most of this is honestly just error checking, the shit in the do loop is the main reading
func readDataFromCSV(fileName:String, fileType: String)-> String! {
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
        else {
          return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            //contents = cleanRows(file: contents) //not sure what this does but read that this needs to be in here
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
}

func csv(data: String) -> [[String]] {
    var result: [[String]] = []
    let rows = data.components(separatedBy: "\n")
    for row in rows {
        let columns = row.components(separatedBy: ";")
        result.append(columns)
    }
    return result
}

/*
* TO PLACE IN MAIN *
var data = readDataFromCSV(fileName: jhulinks, fileType: csv) //i think?
data = cleanRows(file: data)
let csvRows = csv(data: data)
print(csvRows[1][1])
*/
