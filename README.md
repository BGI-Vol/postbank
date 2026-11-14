# 邮储银行界面仿真（单机版）

iOS 界面仿真工程，本地运行，无任何网络请求。用于界面还原与演示。

## 关键特性

- 五标签页：首页 / 信用卡 / 财富 / 生活 / 我的
- 全部数据在本地 `UserDefaults`，不联网
- **余额可改**：在「我的 · 我的资产」或「财富 · 总资产」的长按金额 1.5 秒，弹出输入框
- 联网效果为仿真：有延迟、有加载态、有失败分支，但没有真实请求

## 本地构建（需 macOS）

```bash
brew install xcodegen
cd E:\项目\07-postbank        # macOS 上换成实际路径
xcodegen generate
open PostBank.xcodeproj
```

或用命令行：

```bash
xcodebuild -project PostBank.xcodeproj -scheme PostBank \
  -sdk iphoneos -configuration Release \
  -archivePath build/PostBank.xcarchive archive \
  CODE_SIGNING_ALLOWED=NO
```

## 云编译（无 Mac）

推到 GitHub，Actions 会自动跑 `.github/workflows/build.yml`，产出未签名 `PostBank.ipa` 到 Artifacts。

免费额度：公开仓库无限，私有仓库 2000 分钟/月（macOS runner 按 10 倍计费，即约 200 分钟实际）。

## 签名安装（iOS 26.4.1 / 无越狱）

TrollStore 只支持到 iOS 17.0，26.4.1 用 SideStore：

1. 手机装 **SideStore**（首次需一台电脑通过 AltServer/iloader 装一次）
2. SideStore 里登录**免费 Apple ID**
3. 导入云编译产出的 `.ipa` → 安装
4. 手机「设置 → 通用 → VPN与设备管理」信任你的 Apple ID
5. 每 7 天 SideStore 自动续签（在手机上完成，不用电脑）

限制：免费 Apple ID 同时最多 3 个 App；用 **LiveContainer** 可绕过。

## 目录结构

```
PostBank/
├── PostBankApp.swift          入口（用 AppStore.shared）
├── Models/
│   ├── Models.swift           Account / Transaction / Session / LoadState
│   └── MockNet.swift          联网仿真层（延迟、失败分支、种子数据）
├── Store/
│   └── AppStore.swift         单例状态 + UserDefaults 持久化 + updateBalance
└── Views/
    ├── Theme.swift            配色、尺寸、RCard、GridItem、Badge、TopSearchBar
    ├── Components.swift       PrimaryButton、FieldRow、ErrorBanner、TransactionRow
    ├── EditableAmount.swift   ★ 长按改余额
    ├── RootTabView.swift      五标签
    ├── HomeView.swift         首页
    ├── CreditCardView.swift   信用卡
    ├── WealthView.swift       财富（含总资产）
    ├── LifeView.swift         生活
    ├── MineView.swift         我的（含我的资产）
    └── LoginView.swift        登录页（演示工程默认跳过）
```

## 改余额的实现

```swift
// EditableAmount.swift
.onLongPressGesture(minimumDuration: 1.5) { draft = "\(amount)"; editing = true }
.alert("修改余额", isPresented: $editing) {
    TextField("金额", text: $draft).keyboardType(.decimalPad)
    Button("确定") { AppStore.shared.updateBalance(Decimal(string: draft) ?? 0) }
}
```

写入 `UserDefaults` 的 key：`postbank.accounts`。

## 已知限制

- **图标不是邮储原版**：全部用 SF Symbols 近似，无法 1:1
- **Banner 无实拍素材**：用渐变色块 + 文字 + SF Symbols 拼出结构，不是原图
- **字体不是邮储定制字**：用系统字体
- 需要 1:1 时，必须逐页对照截图微调间距与字号