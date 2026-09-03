// ============================================================
// MODULE 4: Swift Programming Fundamentals
// LAB — PNC Banking Domain Model
// Enterprise Mobile Application Development Bootcamp
// ============================================================
//
// OVERVIEW
// You are building the Swift data model layer for the PNC Mobile
// Banking application. This layer will be carried forward into
// Modules 6, 7, and 8 as the foundation of the real application.
//
// Every type you define here uses the Swift features from all
// three days of this module. Take time to read the full spec
// before writing any code.
//
// ESTIMATED TIME: 90–120 minutes
//
// ============================================================
// LAB SPEC
// ============================================================
//
// You will build five interconnected Swift types:
//
//   1. TransactionType enum
//   2. TransactionStatus enum
//   3. Transaction struct
//   4. Account class
//   5. AccountAnalytics struct
//
// And three protocols:
//
//   A. Summarizable       — any type that can produce a summary string
//   B. AccountOperations  — deposit, withdraw, transfer
//   C. AnalyticsProvider  — compute basic financial metrics
//
// The lab ends with an error handling system and a generic
// result reporting function that ties everything together.
//
// Read each section completely before implementing it.
// ============================================================

import Foundation
print("TOP OF FILE")

// ============================================================
// SECTION 1: Enumerations
// ============================================================

// TODO 1A: TransactionType
// Conform to: String, CaseIterable, Codable
// Cases:     credit, debit, transfer, fee
// Add computed property: isExpense: Bool
//   → true for .debit and .fee, false otherwise


// TODO 1B: TransactionStatus
// Conform to: String, Codable
// Cases:     pending, completed, failed, cancelled
// Add computed property: isTerminal: Bool
//   → true for .completed, .failed, .cancelled
//   → false for .pending (can still change)
enum TransactionType: String, CaseIterable, Codable {
    case credit
    case debit
    case transfer
    case fee
    
    var isExpense: Bool {
        switch self {
        case .debit:
            return true
        case .fee:
            return true
        default:
            return false
        }
    }
}
enum TransactionStatus: String, Codable {
    case pending
    case completed
    case failed
    case cancelled
    
    var isTerminal: Bool {
        switch self {
        case .completed:
            return true
        case .failed:
            return true
        case .cancelled:
            return true
        default:
            return false
        }
    }
}

// ============================================================
// SECTION 2: Transaction Struct
// ============================================================

// TODO 2: Define struct Transaction conforming to:
//   Identifiable, Codable, Equatable, Hashable, Summarizable (see Section 4A)
//
// Stored properties:
//   id: String                (unique identifier, default to UUID().uuidString)
//   date: Date
//   amount: Double            (always positive — type determines direction)
//   description: String
//   type: TransactionType
//   status: TransactionStatus (default: .completed)
//   category: String?
//   merchantName: String?
//
// Computed properties:
//   formattedAmount: String
//     → "-$X.XX" for expenses (type.isExpense == true)
//     → "+$X.XX" for income/credit
//
//   formattedDate: String
//     → Use DateFormatter with dateStyle: .medium, timeStyle: .short
//
//   resolvedCategory: String
//     → Returns category if non-nil, "Uncategorized" otherwise
//
// Custom initializer (all params except id, status, category, merchantName
// should be required; the rest should have defaults):
//   init(date:amount:description:type:status:category:merchantName:)
struct Transaction: Identifiable, Codable, Equatable, Hashable, Summarizable {
    var id: String = UUID().uuidString
    var date: Date
    var amount: Double
    var description: String
    var type: TransactionType
    var status: TransactionStatus = .completed
    var category: String?
    var merchantName: String?
    var summary: String
    
    var formattedAmount: String{
        guard type.isExpense else {
            return "+\(String(format: "$%.2f",amount))"
        }
        return "-\(String(format: "$%.2f",amount))"
    }
    var formattedDate: String{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    var resolvedCategory: String{
        category ?? "Uncategorized"
    }
    init(date: Date, amount: Double, description: String, type: TransactionType, status: TransactionStatus, category: String?, merchantName: String?, summary: String){
        self.date = date
        self.amount = amount
        self.description = description
        self.type = type
        self.category = category
        self.merchantName = merchantName
        self.status = status
        self.summary = summary
    }
}

// ============================================================
// SECTION 3: Account Class
// ============================================================

// TODO 3A: Define protocol AccountOperations (see Section 4B)
// before defining Account, because Account will conform to it.
// (Define the protocol in Section 4B, then add conformance to Account here)

// TODO 3B: Define class BankAccount conforming to:
//   Identifiable, AccountOperations, Summarizable
//
// Stored properties:
//   id: String
//   accountNumber: String
//   accountType: String          (e.g., "CHECKING", "SAVINGS")
//   nickname: String?
//   var balance: Double
//   var availableBalance: Double
//   let currency: String         (default "USD")
//   let isActive: Bool           (default true)
//   var transactions: [Transaction]
//
// Computed properties:
//   displayName: String          → nickname if non-nil, else accountType.capitalized
//   maskedAccountNumber: String  → "****" + last 4 digits
//   formattedBalance: String     → "$X.XX"
//   recentTransactions: [Transaction]  → last 5, sorted by date descending
//   pendingCount: Int            → count of transactions with status .pending
//
// Designated initializer:
//   init(id:accountNumber:accountType:nickname:initialBalance:currency:isActive:)
//
// Implement AccountOperations (see Section 4B for the protocol requirements).
// Use the AccountError enum from Section 4C.
//
// Also add:
//   func addTransaction(_ transaction: Transaction)
//     → appends to transactions AND updates balance:
//       if transaction.type.isExpense: balance -= transaction.amount
//       else:                          balance += transaction.amount
//       Update availableBalance to match balance.

class BankAccount: Identifiable, AccountOperations, Summarizable{
    var summary: String
    var id: String
    var accountNumber: String
    var accountType: String
    var nickname: String?
    var balance: Double
    var availableBalance: Double
    var currency: String
    var isActive: Bool
    var transactions: [Transaction]
    var displayname : String{
        return nickname ?? accountType.capitalized
    }
    var maskedAccountNumber: String{
        return "**** \(String(accountNumber).suffix(4))"
    }
    var formattedBalance: String{
        return String(format: "$%.2f", balance)
    }
    var recentTransactions: [Transaction] {
                Array(transactions.sorted { $0.date > $1.date }.prefix(5))
    }
    var pendingCount: Int {
            transactions.filter { $0.status == .pending }.count
        }
    func deposit(amount: Double) {
        balance += amount
    }
    func withdraw(amount: Double) {
        balance -= amount
    }
    func transfer(amount: Double, to destination: BankAccount) {
        destination.balance += amount
        balance -= amount
    }
    func addTransaction(_ transaction: Transaction) {
    transactions.append(transaction)

    if transaction.type.isExpense {
        balance -= transaction.amount
    } else {
        balance += transaction.amount
    }

    availableBalance = balance
}
    init(summary: String, id: String, accountNumber: String, accountType: String, nickname: String? = nil, balance: Double, availableBalance: Double, currency: String, isActive: Bool, transactions: [Transaction]) {
        self.summary = summary
        self.id = id
        self.accountNumber = accountNumber
        self.accountType = accountType
        self.nickname = nickname
        self.balance = balance
        self.availableBalance = availableBalance
        self.currency = currency
        self.isActive = isActive
        self.transactions = transactions
    }
}

// ============================================================
// SECTION 4: Protocols
// ============================================================

// TODO 4A: Summarizable protocol
//   Required: var summary: String { get }
//   Default implementation via extension: func printSummary() — prints summary


// TODO 4B: AccountOperations protocol
//   func deposit(amount: Double) throws
//   func withdraw(amount: Double) throws
//   func transfer(amount: Double, to destination: BankAccount) throws
//
// These methods throw AccountOperationsError (define in Section 4C).


// TODO 4C: AccountOperationsError enum conforming to LocalizedError
// Cases:
//   invalidAmount
//   insufficientFunds(available: Double, required: Double)
//   accountInactive
//   transferToSameAccount
//   dailyLimitExceeded(limit: Double)
//
// Each case should have a meaningful errorDescription.
protocol Summarizable {
    var summary: String { get }
}
extension Summarizable {
    func printSummary() {
        print(summary)
    }
}
protocol AccountOperations {
    func deposit(amount: Double) throws
    func withdraw(amount: Double) throws
    func transfer(amount: Double, to destination: BankAccount) throws
}
enum AccountError: LocalizedError{
    case invalidAmount
    case insufficientFunds(available: Double, required: Double)
    case accountInactive
    case transferToSameAccount
    case dailyLimitExceeded(limit: Double)
    
    var errorDescription: String? {
        switch self {
        case .invalidAmount:
            return "Invalid amount."
        case .insufficientFunds(available: let available, required: let required):
            return "Insufficient funds. Available: \(available), Required: \(required)."
        case .accountInactive:
            return "Account is inactive."
        case .transferToSameAccount:
            return "Cannot transfer to the same account."
        case .dailyLimitExceeded(limit: let limit):
            return "Daily limit exceeded. Limit: \(limit)."
        }
    }
}

// ============================================================
// SECTION 5: Analytics
// ============================================================

// TODO 5A: AnalyticsProvider protocol
//   var totalCredits: Double { get }
//   var totalDebits: Double { get }
//   var netFlow: Double { get }         // credits - debits
//   var largestTransaction: Transaction? { get }
//   func monthlyTotal(month: Int, year: Int) -> Double
//   func transactionsByCategory() -> [String: [Transaction]]


// TODO 5B: AccountAnalytics struct
// Stored property: transactions: [Transaction]
// Conform to AnalyticsProvider.
// Implement each requirement.
//
// Tips:
//   totalCredits: use .filter { !$0.type.isExpense }.reduce(0) { $0 + $1.amount }
//   transactionsByCategory: group by resolvedCategory using a Dictionary
//     (hint: use Dictionary(grouping:by:))
//   monthlyTotal: filter by Calendar.current month/year components and sum expense amounts
protocol AnalyticsProvider {
    var totalCredits: Double { get }
    var totalDebits: Double { get }
    var netFlow: Double { get }         
    var largestTransaction: Transaction? { get }
    func monthlyTotal(month: Int, year: Int) -> Double
    func transactionsByCategory() -> [String: [Transaction]]
}
struct AccountAnalytics: AnalyticsProvider{
    var transactions: [Transaction]
    var totalCredits: Double {
        return transactions.filter { !$0.type.isExpense }.reduce(0) { $0 + $1.amount }
    }
    var totalDebits: Double {
        return transactions.filter { $0.type.isExpense }.reduce(0) { $0 + $1.amount }
    }
    var netFlow: Double {
        return totalCredits - totalDebits
    }
    var largestTransaction: Transaction? {
        transactions.max(by: { $0.amount < $1.amount })
    }
    func monthlyTotal(month: Int, year: Int) -> Double {
        let calendar = Calendar.current
        return transactions.filter {
            let components = calendar.dateComponents([.month, .year], from: $0.date)
            return components.month == month && components.year == year
        }
        .filter { $0.type.isExpense }
        .reduce(0) { $0 + $1.amount }
    }
    func transactionsByCategory() -> [String : [Transaction]] {
        Dictionary(grouping: transactions){
            $0.resolvedCategory
        }
    }
}
// ============================================================
// SECTION 6: Generic Result Reporter
// ============================================================

// TODO 6: Write a generic function:
//   func reportResults<T: Summarizable>(_ items: [T], title: String)
//
// It should:
//   1. Print a header line: "=== [title] ==="
//   2. Print the item count: "[N] items"
//   3. Call printSummary() on each item
//   4. Print a footer: "=== End of [title] ==="
//
// The function must work for any type conforming to Summarizable —
// including both Transaction and BankAccount.
func reportResults<T: Summarizable>(_ items: [T], title: String) {
    print ("=== \(title) ===")
    print ("[\(items.count)] items")
    for item in items {
        item.printSummary()
    }
    print ("=== End of \(title) ===")
}

// ============================================================
// SECTION 7: INTEGRATION TEST — Tie it all together
// ============================================================

// TODO 7: Write a function named runlabDemo() that does the following:

// 7A: Create at least two BankAccount instances:
//   - A checking account with $3,500 initial balance
//   - A savings account with $12,000 initial balance

// 7B: Create at least five Transaction instances across different types
//   and add them to the checking account using addTransaction(_:)
//   Include: one credit, two debits, one fee, one transfer
//   Verify the balance updates correctly after each addition.

// 7C: Demonstrate error handling:
//   - Try to withdraw more than the available balance → catch insufficientFunds
//   - Try to deposit a negative amount → catch invalidAmount
//   - Try to transfer to the same account → catch transferToSameAccount
//   Print the localized error description for each caught error.

// 7D: Create an AccountAnalytics instance with the checking account's transactions.
//   Print:
//   - Total credits
//   - Total debits
//   - Net flow
//   - The description and amount of the largest transaction
//   - The transactions grouped by category (print each category and count)

// 7E: Call reportResults with the checking account's transactions, title: "Checking Transactions"
//   Call reportResults with [checkingAccount, savingsAccount], title: "All Accounts"

// 7F: Demonstrate value vs. reference semantics:
//   Copy one Transaction (struct) into a new variable. Modify the copy's description.
//   Show the original is unchanged.
//   Assign the checking account (class) to a new variable. Deposit $100 through the alias.
//   Show both variables reflect the updated balance.




print("TOP OF FILE")
func runlabDemo() {

    let checkingAccount = BankAccount(
        summary: "Checking account",
        id: UUID().uuidString,
        accountNumber: "529846",
        accountType: "CHECKING",
        nickname: "Life Expenditures",
        balance: 3_500,
        availableBalance: 3_500,
        currency: "USD",
        isActive: true,
        transactions: []
    )

    let savingsAccount = BankAccount(
        summary: "Savings account",
        id: UUID().uuidString,
        accountNumber: "840637",
        accountType: "SAVINGS",
        nickname: "Emergencies",
        balance: 12_000,
        availableBalance: 12_000,
        currency: "USD",
        isActive: true,
        transactions: []
    )

    let paycheck = Transaction(
        date: Date(),
        amount: 1_500,
        description: "Paycheck",
        type: .credit,
        status: .completed,
        category: "Income",
        merchantName: "Employer",
        summary: "Paycheck credit"
    )

    let groceries = Transaction(
        date: Date(),
        amount: 85.92,
        description: "Groceries",
        type: .debit,
        status: .completed,
        category: "Groceries",
        merchantName: "Grocery Store",
        summary: "Grocery purchase"
    )

    let gasoline = Transaction(
        date: Date(),
        amount: 32.11,
        description: "Gasoline",
        type: .debit,
        status: .completed,
        category: "Automotive",
        merchantName: "Gas Station",
        summary: "Gas purchase"
    )

    let accountFee = Transaction(
        date: Date(),
        amount: 15,
        description: "Account Fee",
        type: .fee,
        status: .completed,
        category: "Fees",
        merchantName: "Bank",
        summary: "Monthly account fee"
    )

    let transferTransaction = Transaction(
        date: Date(),
        amount: 200,
        description: "Transfer to Savings",
        type: .transfer,
        status: .completed,
        category: "Transfer",
        merchantName: nil,
        summary: "Transfer transaction"
    )

    checkingAccount.addTransaction(paycheck)
    print("After paycheck: \(checkingAccount.formattedBalance)")

    checkingAccount.addTransaction(groceries)
    print("After groceries: \(checkingAccount.formattedBalance)")

    checkingAccount.addTransaction(gasoline)
    print("After gasoline: \(checkingAccount.formattedBalance)")

    checkingAccount.addTransaction(accountFee)
    print("After fee: \(checkingAccount.formattedBalance)")

    checkingAccount.addTransaction(transferTransaction)
    print("After transfer: \(checkingAccount.formattedBalance)")

    let analytics = AccountAnalytics(
        transactions: checkingAccount.transactions
    )

    print("Total credits: \(analytics.totalCredits)")
    print("Total debits: \(analytics.totalDebits)")
    print("Net flow: \(analytics.netFlow)")

    if let largest = analytics.largestTransaction {
        print("Largest transaction: \(largest.description) - \(largest.formattedAmount)")
    }

    let groupedTransactions = analytics.transactionsByCategory()

    for (category, transactions) in groupedTransactions {
        print("\(category): \(transactions.count)")
    }

    reportResults(
        checkingAccount.transactions,
        title: "Checking Transactions"
    )

    reportResults(
        [checkingAccount, savingsAccount],
        title: "All Accounts"
    )

    var transactionCopy = paycheck

    transactionCopy.description = "Modified Paycheck"

    print("Original: \(paycheck.description)")
    print("Copy: \(transactionCopy.description)")

    let checkingAlias = checkingAccount

    checkingAlias.deposit(amount: 100)

    print("Checking account balance: \(checkingAccount.formattedBalance)")
    print("Alias balance: \(checkingAlias.formattedBalance)")
}

runlabDemo()
// ============================================================
// END OF LAB
// ============================================================
//
// SELF-ASSESSMENT CHECKLIST
// Before submitting, verify:
//   [ ] All five types compile without warnings
//   [ ] runlabDemo() runs to completion with no crashes
//   [ ] Each error case in 7C is handled and prints a clear message
//   [ ] Struct copy semantics are correctly demonstrated in 7F
//   [ ] Class reference semantics are correctly demonstrated in 7F
//   [ ] reportResults works for both Transaction and BankAccount
//   [ ] Analytics produce correct totals matching your transactions
// ============================================================
