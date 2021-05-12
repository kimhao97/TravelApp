import Foundation

func convertDecimalToBinary(with number: Int) -> [Int] {
    var arrBinary = [Int]()
    var index: Int = 0
    var number: Int = number

    while number > 0 {
        arrBinary.append(number % 2)
        index += 1
        number = number / 2
    }

    return arrBinary
}

func showBinaryNumber(_ binaryNumber: [Int]) {
    for index in 1...binaryNumber.count {
        print(binaryNumber[binaryNumber.count - index])
    }
}

let binaryNumber: [Int] = convertDecimalToBinary(with: 8)

showBinaryNumber(binaryNumber)
