
// ============================================================
// EXERCISE: Structs — Value Types
// Estimated time: 20 minutes
//
// Structs in Swift are MUCH more powerful than in C.
// They can have methods, computed properties, and protocol conformance.
// The key rule: assignment COPIES a struct. Two variables never
// share the same struct instance.
// ============================================================

import Foundation

// TODO 3a: Define a struct named Transaction with these stored properties:
//   id: String
//   date: Date
//   amount: Double
//   description: String
//   isDebit: Bool
struct Transaction{
    let id: String
    let date: Date
    let amount: Double
    var description: String
    let isDebit: Bool
    var isPending: Bool 
    
    var formattedAmount: String{
        guard isDebit else{
            return "+$\(String(format: "%.2f", amount))"
        }
        return "-$\(String(format: "%.2f", amount))"
    }
    var formattedDate: String{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }
    mutating func markAsPending(){
        guard !isPending else{
            return
        }
        isPending = true
        return
    }
} 
let t1 = Transaction(id: "1", date: Date(), amount: 2_500.00, description: "Direct Deposit", isDebit: false, isPending: false) 
var t2 = Transaction(id: "2", date: Date(), amount: 45.67, description:"Starbucks", isDebit: true, isPending: false)
print("Tranaction Amount: \(t1.formattedAmount) - \(t1.description)")
print("Tranaction Amount: \(t2.formattedAmount) - \(t2.description)")
var t3 = t1
t3.description = "Modified"
print(t1.description)
print(t3.description)
print(t2.isPending)
t2.markAsPending()
print(t2.isPending)
// Add these computed properties:
//   formattedAmount: String
//     → returns "-$250.00" if isDebit, "+$250.00" if credit
//     → use String(format: "%.2f", abs(amount))
//
//   formattedDate: String
//     → use DateFormatter with dateStyle: .medium, timeStyle: .none
//
// Add a memberwise initializer (Swift gives you this FREE for structs —
// you do not need to write init() unless you want custom behavior).


// TODO 3b: Create two Transaction instances:
//   t1: a credit of $2,500.00 described as "Direct Deposit"
//   t2: a debit of $45.67 described as "Starbucks"
// Print their formattedAmount and description.


// TODO 3c: Prove value semantics
// Assign t1 to a new variable t3.
// Try to change t3.description to "Modified".
// What happens? Why?
//There is an error because t3 and description are let and lets are constants that cannot change
// Fix it by declaring t3 with var instead of let.
// Then change t3.description and print both t1.description and t3.description.
// Observe that t1 is unchanged. This is the key difference from classes.


// TODO 3d: Add a mutating method to Transaction named markAsPending
// that sets a new stored property isPending: Bool = false to true.
// Call it on t2 and verify.


// ============================================================
// EXERCISE: Classes — Reference Types
// Estimated time: 20 minutes
//
// Classes add: inheritance, reference semantics (assignment shares
// the same object), and deinitializers.
// Use classes for: managers, services, view controllers — things
// that have IDENTITY and LIFECYCLE, not just data.
// ============================================================
class BankAccount{
    let id: String
    let accountNumber: String
    var balance: Double
    let owner: String

    init(id: String, accountNumber: String, balance: Double = 0.0, owner: String){
        self.id = id
        self.accountNumber = accountNumber
        self.balance = balance
        self.owner = owner
    }
    func deposit(amount: Double){
        guard amount > 0 else{
            print("invalid amount")
            return
        }
        balance += amount
        return
    }
    func withdraw(amount: Double) -> Bool{
        guard amount > 0 && amount <= balance else{
            var success = false
            return success
        }
        balance -= amount
        var success = true
        return success
    }
    func printSummary(){
        print("Account \(accountNumber) | Owner: \(owner) | Balance: \(String(format: "$%.2f", balance))")
    }
}
var checking = BankAccount(id: "acc_001", accountNumber: "1234567890", balance: 1_000, owner: "Jane Smith")
var savings = BankAccount(id: "acc_002", accountNumber: "0987654321", balance: 5_000, owner: "Jane Smith")
checking.deposit(amount: 200.00)
checking.withdraw(amount: 50.00)
checking.printSummary()
savings.printSummary()
var checkingRef = checking
checkingRef.deposit(amount: 500)
print(checking.balance)
print(checkingRef.balance)
class PremiumBankAccount: BankAccount{
    var overdraftLimit: Double
    init(id: String, accountNumber: String, balance: Double, owner: String, overdraftLimit: Double){
        self.overdraftLimit = overdraftLimit
    
        super.init(
            id: id, 
            accountNumber: accountNumber,
            balance: balance,
            owner: owner
        )
    }
    convenience init(id: String, accountNumber: String, owner: String, overdraftLimit: Double){
        self.init(id: id, accountNumber: accountNumber, balance: 0.0, owner: owner, overdraftLimit: overdraftLimit)
    }
    override func withdraw(amount: Double) -> Bool{
        guard amount > 0 && amount <= balance + overdraftLimit else{
            var success = false
            return success
        }
        balance -= amount
        var success = true
        return success
    }
}
var premium = PremiumBankAccount(id: "acc_003", accountNumber: "2345678901", balance: 100, owner: "Jane Smith", overdraftLimit: 500)
premium.withdraw(amount: 400)
print(premium.balance)
premium.withdraw(amount: 800)
print(premium.balance)
// - value shows overdraft and no shange shows guard caught the seconf withdraw

// TODO 4a: Define a class named BankAccount with:
//   Stored properties:
//     id: String
//     accountNumber: String
//     balance: Double
//     owner: String
//
//   A designated initializer: init(id:accountNumber:owner:initialBalance:)
//   where initialBalance has a default of 0.0
//
//   Methods:
//     deposit(amount: Double) — adds to balance if amount > 0
//     withdraw(amount: Double) -> Bool — subtracts if amount > 0 and <= balance; returns success
//     printSummary() — prints "Account [accountNumber] | Owner: [owner] | Balance: $X.XX"


// TODO 4b: Create two BankAccount instances:
//   checking: id "acc_001", accountNumber "1234567890", owner "Jane Smith", balance 1_000.00
//   savings:  id "acc_002", accountNumber "0987654321", owner "Jane Smith", balance 5_000.00
// Call deposit and withdraw on checking. Print summaries for both.


// TODO 4c: Prove reference semantics
// Assign checking to a new variable checkingRef.
// Call checkingRef.deposit(amount: 500)
// Print checking.balance and checkingRef.balance.
// Observe they are THE SAME object — both show the updated balance.
// Write a comment explaining why this is different from the struct in 3c.

//This is differnt because stucthas value properties and a class has reference 
// properties, things in a reference are pointing at an object that can change 
// a value does not change a new one must be made.

// TODO 4d: Inheritance
// Define a class PremiumBankAccount that inherits from BankAccount.
// Add a stored property overdraftLimit: Double
// Override withdraw(amount:) so that withdrawal succeeds if
// amount <= balance + overdraftLimit (draws from overdraft if needed).
// Add a convenience initializer that takes the same params as BankAccount
// plus overdraftLimit.
//
// Test it: create a premium account with balance 100 and overdraftLimit 500.
// Withdraw 400 — should succeed (draws on overdraft).
// Withdraw 800 — should fail (exceeds balance + overdraftLimit).


// ============================================================
// EXERCISE: Enumerations
// Estimated time: 15 minutes
//
// Swift enums are the richest in any mainstream language.
// They can carry associated values — meaning each case can
// store different data. This replaces many patterns where
// Python/JS developers would use a dict or tuple.
// ============================================================

// TODO 5a: Define an enum TransactionType with cases:
//   credit, debit, transfer, fee
// Make it conform to String and CaseIterable:
//   enum TransactionType: String, CaseIterable


// TODO 5b: Add a computed property displayName: String to TransactionType
// using a switch that returns:
//   credit   → "Credit"
//   debit    → "Debit"
//   transfer → "Transfer"
//   fee      → "Fee"

enum TransactionType: String, CaseIterable{
    case credit 
    case debit
    case transfer
    case fee
    var displayName: String{
        switch self{
            case .credit:
                return "Credit"
            case .debit:
                return "Debit"
            case .transfer:
                return "Transfer"
            case .fee:
                return "Fee"
        }
    }
}
enum AccountError{
    case insufficientFunds(available: Double, requested: Double )
    case accountInactive
    case dailyLimitExceeded(limit: Double)
    case invalidAmount
}
func describeError(_ error: AccountError) -> String{
        switch error{
            case .insufficientFunds(let available, let requested):
            return "Insufficent Funds. Available: $\(available), Requested: $\(requested)."
            case .accountInactive:
            return "You're account is inactive."
            case .dailyLimitExceeded(let limit):
            return "Exceeded daily limit of $\(limit)."
            case .invalidAmount:
            return "Amount entered is invalid"
        }
    }
print(describeError( .insufficientFunds(available: 100.0, requested: 200.0)))
print(describeError( .accountInactive))
print(describeError( .dailyLimitExceeded(limit: 100.0)))
print(describeError( .invalidAmount))
for type in TransactionType.allCases {
    print(type.rawValue)
}


// TODO 5c: Enum with associated values
// Define an enum AccountError with these cases:
//   insufficientFunds(available: Double, requested: Double)
//   accountInactive
//   dailyLimitExceeded(limit: Double)
//   invalidAmount
//
// Write a function describeError(_ error: AccountError) -> String
// that uses a switch with associated value binding to return
// a user-friendly message for each case.
// Test it with all four cases.


// TODO 5d: Iterate over all cases
// Using CaseIterable on TransactionType, print all transaction types
// and their raw values:
// for type in TransactionType.allCases { print(...) }
// Expected:
//   credit → "credit"
//   debit → "debit"
//   etc.