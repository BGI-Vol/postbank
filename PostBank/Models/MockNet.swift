import Foundation

/// 联网仿真层：全部在本地演算，不发任何真实请求。
/// 目的只是让界面出现「加载中 → 结果」的时序和失败分支，
/// 这样 UI 的状态机和真实联网 App 一致。
@MainActor
final class MockNet {
    static let shared = MockNet()

    private init() {}

    /// 模拟网络延迟。base 是基准秒数，jitter 是上下浮动。
    private func latency(_ base: Double, _ jitter: Double = 0) async {
        let d = jitter > 0 ? base + Double.random(in: -jitter...jitter) : base
        try? await Task.sleep(nanoseconds: UInt64(max(0, d) * 1_000_000_000))
    }

    /// 登录。卡号 16 位、密码 ≥6 位视为通过；验证码任意 6 位。
    func login(cardNo: String, password: String, smsCode: String) async -> Result<Session, TransferError> {
        await latency(1.2, 0.3)
        let digits = cardNo.filter(\.isNumber)
        guard digits.count >= 16 else { return .failure(.invalidAccount) }
        guard password.count >= 6 else { return .failure(.invalidAmount) }
        guard smsCode.filter(\.isNumber).count == 6 else { return .failure(.invalidAmount) }
        return .success(Session(cardNo: digits, loggedInAt: .now))
    }

    /// 查询余额。小概率返回失败，用来验证重试分支。
    func fetchAccounts() async -> Result<[Account], TransferError> {
        await latency(0.6, 0.2)
        if Int.random(in: 0..<20) == 0 { return .failure(.network) }
        return .success(Self.seedAccounts)
    }

    /// 查询交易流水。
    func fetchTransactions() async -> Result<[Transaction], TransferError> {
        await latency(0.5, 0.15)
        return .success(Self.seedTransactions)
    }

    /// 转账。校验通过后延迟 1.5–2.5 秒返回成功；约 8% 概率模拟网络异常。
    func transfer(_ req: TransferRequest, available: Decimal) async -> Result<Transaction, TransferError> {
        await latency(1.8, 0.4)

        guard !req.payeeName.trimmingCharacters(in: .whitespaces).isEmpty else { return .failure(.invalidPayee) }
        let acct = req.payeeAccount.filter(\.isNumber)
        guard acct.count >= 12 else { return .failure(.invalidAccount) }
        guard req.amount > 0 else { return .failure(.invalidAmount) }
        guard req.amount <= available else { return .failure(.insufficientFunds(available: available)) }
        guard req.amount <= 50_000 else { return .failure(.dailyLimitExceeded(limit: 50_000)) }

        if Int.random(in: 0..<12) == 0 { return .failure(.network) }

        return .success(Transaction(
            title: "转账汇款",
            counterparty: req.payeeName,
            amount: req.amount,
            direction: .expense,
            note: req.note.isEmpty ? nil : req.note
        ))
    }

    // MARK: - 种子数据

    static let seedAccounts: [Account] = [
        Account(maskedCardNo: "**** **** **** 8866", accountName: "借记卡·活期", balance: 128_640.55),
        Account(maskedCardNo: "**** **** **** 2024", accountName: "借记卡·定期", balance: 50_000.00)
    ]

    static let seedTransactions: [Transaction] = {
        let cal = Calendar.current
        let now = Date()
        func ago(_ h: Int) -> Date { cal.date(byAdding: .hour, value: -h, to: now) ?? now }
        return [
            Transaction(title: "工资入账", counterparty: "某某科技有限公司", amount: 18_500, direction: .income, date: ago(6)),
            Transaction(title: "转账汇款", counterparty: "李*", amount: 2_300, direction: .expense, date: ago(11)),
            Transaction(title: "pos消费", counterparty: "全家便利店", amount: 38.50, direction: .expense, date: ago(20)),
            Transaction(title: "快捷支付", counterparty: "某某网络科技", amount: 128, direction: .expense, date: ago(29)),
            Transaction(title: "利息", counterparty: "活期结息", amount: 12.36, direction: .income, date: ago(52)),
            Transaction(title: "转账汇款", counterparty: "王*", amount: 5_000, direction: .expense, date: ago(73)),
            Transaction(title: "退款", counterparty: "某某商城", amount: 199, direction: .income, date: ago(96))
        ]
    }()
}

// MARK: - 校验小工具
extension String {
    var isAllDigits: Bool { !isEmpty && allSatisfy(\.isNumber) }
}