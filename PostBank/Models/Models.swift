import Foundation

// MARK: - 账户

struct Account: Codable, Identifiable, Hashable {
    let id: UUID
    /// 卡号后四位展示
    let maskedCardNo: String
    let accountName: String
    let balance: Decimal
    let currency: String

    init(id: UUID = UUID(), maskedCardNo: String, accountName: String, balance: Decimal, currency: String = "CNY") {
        self.id = id
        self.maskedCardNo = maskedCardNo
        self.accountName = accountName
        self.balance = balance
        self.currency = currency
    }

    var balanceText: String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f.string(from: balance as NSDecimalNumber) ?? "0.00"
    }
}

// MARK: - 交易

enum TxDirection: String, Codable {
    case income, expense
}

struct Transaction: Codable, Identifiable, Hashable {
    let id: UUID
    let title: String
    let counterparty: String
    let amount: Decimal
    let direction: TxDirection
    let date: Date
    let note: String?

    init(id: UUID = UUID(), title: String, counterparty: String, amount: Decimal,
         direction: TxDirection, date: Date = .now, note: String? = nil) {
        self.id = id
        self.title = title
        self.counterparty = counterparty
        self.amount = amount
        self.direction = direction
        self.date = date
        self.note = note
    }

    var amountText: String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        let s = f.string(from: amount as NSDecimalNumber) ?? "0.00"
        return (direction == .income ? "+" : "-") + s
    }

    var dateText: String {
        let f = DateFormatter()
        f.dateFormat = "MM-dd HH:mm"
        return f.string(from: date)
    }
}

// MARK: - 会话

struct Session: Codable, Hashable {
    let cardNo: String
    let loggedInAt: Date
}

// MARK: - 请求结果

struct TransferRequest {
    var payeeName: String
    var payeeAccount: String
    var bankName: String
    var amount: Decimal
    var note: String
}

enum TransferError: LocalizedError {
    case invalidPayee
    case invalidAccount
    case invalidAmount
    case insufficientFunds(available: Decimal)
    case dailyLimitExceeded(limit: Decimal)
    case network

    var errorDescription: String? {
        switch self {
        case .invalidPayee: return "收款人姓名不能为空"
        case .invalidAccount: return "收款账号格式不正确"
        case .invalidAmount: return "转账金额必须大于 0"
        case .insufficientFunds(let a): return "余额不足，可用余额 \(a) 元"
        case .dailyLimitExceeded(let l): return "超出单日限额 \(l) 元"
        case .network: return "网络异常，请稍后重试"
        }
    }
}

// MARK: - 加载状态

enum LoadState: Equatable {
    case idle
    case loading
    case success
    case failure(String)

    var isLoading: Bool { self == .loading }
}