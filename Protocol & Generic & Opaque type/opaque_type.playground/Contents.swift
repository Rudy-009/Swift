protocol Vehicle {
    func drive() -> String
}

class Car: Vehicle {
    func drive() -> String {
        return "Car"
    }
}

class Bus: Vehicle {
    func drive() -> String {
        return "Bus"
    }
}

func someVehicle(type: String) -> some Vehicle {
//    switch type {
//    case "Bus":
        //return Bus()
    //default:
        return Car()
    //}
}

func returrnProtocol() -> Vehicle {
    return Car()
}

returrnProtocol()

func anyVehicle(type: String) -> any Vehicle {
    switch type {
    case "Bus":
        return Bus()
    default:
        return Car()
    }
}
