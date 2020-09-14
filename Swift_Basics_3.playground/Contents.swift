import UIKit

// custom date
struct CustomDate {
    
    private var date:Date?
    
    // initialiser
    init(day: Int, month: Int, year: Int, hour: Int = 0, minute: Int = 0, timeZone: TimeZone = .current) {
        
        // date components
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.timeZone = timeZone
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        // get calender
        let userCalender = Calendar.current
        
        // assign callender to date variable
        date = userCalender.date(from: dateComponents)
    }
    
    // get back date in a string format
    // as = external, format = internal
    func formatted(as format:String = "dd-MM-yyyy") -> String? {
        guard let date = self.date else {return nil}
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}

// movie genre enum
enum Genre {
    case Drama, Comedy, Action, Romance
}

// underlying raw type - need to define the raw values
enum DateType:String {
    case production = "Production", release = "Release"
}

// use private properties as default then open up when needed
struct ImportantDates {
    // create a dictionary - private setter - internal getter
    private (set) var dates:[DateType:CustomDate] = [:]
    
    // initialiser
    init(date: CustomDate, type: DateType) {
        add(date: date, type: type)
    }
    
    // mutating keyword - you must using the mutating keyword when mutating a property of a struct
    mutating func add(date:CustomDate, type:DateType) {
        dates.updateValue(date, forKey: type)
    }
    
    // calculated properties
    var list:String {
        var result:String = ""
        for (key, value) in dates {
            result += key.rawValue + ":\t" + (value.formatted()!) + "\n"
        }
        return result
    }
}

// movie struct
struct Movie {
    private var title:String
    private var description:String
    private var leadActor:String
    private var genre:Genre
    
    private (set) var importantDates:ImportantDates?
    
    init(title:String, description:String, leadActor:String, genre:Genre, importantDates:ImportantDates? = nil) {
        self.title = title
        self.description = description
        self.leadActor = leadActor
        self.genre = genre
        self.importantDates = importantDates
    }
    
    var shortSummary:String {
        let result = "Title:\t \(title)\nLead Actor:\t\(leadActor)\nGenre:\t\(genre)\n"
        // no variable name because i wont use it anywhere else in this method/function
        guard let _ = importantDates else {return result}
        return result + importantDates!.list
    }
    
    // mutating function
    mutating func addDate(date: CustomDate, type:DateType) {
        guard let _ = importantDates else {
            importantDates = ImportantDates(date:date, type:type)
            return
        }
        // optional chaining - allows unwrap and call function - different style programming
        importantDates?.add(date: date, type: type)
    }
}

var mos = Movie(title: "Man of Steel", description: "Awesome!!!", leadActor: "Henry Cavill", genre: Genre.Action)
print("Without Dates")
print(mos.shortSummary)

print("With one date")
let productionDate = CustomDate(day: 3, month: 8, year: 2019)
mos.addDate(date: productionDate, type: .production)
print(mos.shortSummary)

print("With two dates")
let releaseDate = CustomDate(day: 3, month: 8, year: 2020)
mos.addDate(date: releaseDate, type: .release)
print(mos.shortSummary)


