import Foundation
import Observation

@MainActor
@Observable
final class AppStore {
    /// 单例：ViewModel 与视图层共用一份，避免环境注入漏传导致两处余额不一致
    static let shared = AppStore()

    var session: Session?
    var accounts: [Account] = []
    var transactions: [Transaction] = []

    var loginState: LoadState = .idle
    var homeState: LoadState = .idle
    var transferState: LoadState = .idle

    private let persistence = Persistence()

    var primaryAccount: Account? { accounts.first }
    var balance: Decimal { accounts.first?.balance ?? 0 }

    init() {
        accounts = persistence.loadAccounts() ?? MockNet.seedAccounts
        transactions = persistence.loadTransactions() ?? MockNet.seedTransactions
        // 演示工程：默认已登录，直接进主界面；退出登录才回登录页
        session = persistence.loadSession() ?? Session(cardNo: "6217000000008866", loggedInAt: .now)
    }

    // MARK: 余额（长按修改的唯一入口）
    func updateBalance(_ newValue: Decimal) {
        guard let idx = accounts.indices.first else { return }
        let old = accounts[idx]
        accounts[idx] = Account(
            id: old.id,
            maskedCardNo: old.maskedCardNo,
            accountName: old.accountName,
            balance: newValue
        )
        persistence.saveAccounts(accounts)
    }

    // MARK: 登录 / 登出
    func login(cardNo: String, password: String, smsCode: String) async {
        guard !loginState.isLoading else { return }
        loginState = .loading
        defer { if loginState.isLoading { loginState = .idle } }

        let r = await MockNet.shared.login(cardNo: cardNo, password: password, smsCode: smsCode)
        switch r {
        case .success(let s):
            session = s
            persistence.saveSession(s)
            loginState = .success
        case .failure(let e):
            loginState = .failure(e.localizedDescription)
        }
    }

    func logout() {
        session = nil
        loginState = .idle
        persistence.clearSession()
    }

    // MARK: 转账
    func transfer(_ req: TransferRequest) async -> Result<Transaction, TransferError> {
        guard !transferState.isLoading else { return .failure(.network) }
        transferState = .loading
        defer { if transferState.isLoading { transferState = .idle } }

        let r = await MockNet.shared.transfer(req, available: balance)
        switch r {
        case .success(let tx):
            transactions.insert(tx, at: 0)
            updateBalance(balance - req.amount)
            persistence.saveTransactions(transactions)
            transferState = .success
            return .success(tx)
        case .failure(let e):
            transferState = .failure(e.localizedDescription)
            return .failure(e)
        }
    }
}

// MARK: - 本地持久化
final class Persistence {
    private let d = UserDefaults.standard
    private let kSession = "postbank.session"
    private let kAccounts = "postbank.accounts"
    private let kTx = "postbank.transactions"

    private func save<T: Encodable>(_ v: T, _ key: String) {
        guard let data = try? JSONEncoder().encode(v) else { return }
        d.set(data, forKey: key)
    }
    private func load<T: Decodable>(_ type: T.Type, _ key: String) -> T? {
        guard let data = d.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }

    func saveSession(_ s: Session) { save(s, kSession) }
    func loadSession() -> Session? { load(Session.self, kSession) }
    func clearSession() { d.removeObject(forKey: kSession) }

    func saveAccounts(_ a: [Account]) { save(a, kAccounts) }
    func loadAccounts() -> [Account]? { load([Account].self, kAccounts) }

    func saveTransactions(_ t: [Transaction]) { save(t, kTx) }
    func loadTransactions() -> [Transaction]? { load([Transaction].self, kTx) }
}