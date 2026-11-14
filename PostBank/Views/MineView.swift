import SwiftUI

struct MineView: View {
    @Environment(AppStore.self) private var store

    private let gridA: [(String, String, Color, (String, Color)?)] = [
        ("circle.hexagongrid.fill", "邮享分", C.textPrimary, ("3.0%起", C.red)),
        ("star", "推荐给朋友", C.textPrimary, nil),
        ("circle.dashed", "分期服务", C.textPrimary, nil),
        ("square.grid.2x2", "全部", C.textPrimary, nil)
    ]
    private let gridB: [(String, String, Color)] = [
        ("crown.fill", "权益专区", Color(red: 1.0, green: 0.65, blue: 0.20)),
        ("ticket.fill", "卡券中心", Color(red: 0.90, green: 0.25, blue: 0.30)),
        ("gift.fill", "活动专区", Color(red: 0.95, green: 0.42, blue: 0.35)),
        ("bag.fill", "生活精选", Color(red: 0.95, green: 0.35, blue: 0.45))
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                topBar
                greeting
                threeCards
                gridCard
                assetCard
                monthFlow
                Spacer(minLength: 20)
            }
        }
        .background(C.pageBg.ignoresSafeArea())
    }

    // MARK: 顶部
    private var topBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "arrow.left")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(C.textPrimary)

            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 13)).foregroundStyle(C.textSecondary)
                Text("9.5折观影").font(.system(size: 13)).foregroundStyle(C.textSecondary)
                Spacer(minLength: 0)
                Text("搜索").font(.system(size: 12, weight: .medium))
                    .foregroundStyle(C.textPrimary)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color(white: 0.95)))
            }
            .padding(.horizontal, 10)
            .frame(height: 34)
            .background(Capsule().fill(.white))

            ZStack(alignment: .topTrailing) {
                Image(systemName: "hexagon")
                    .font(.system(size: 19)).foregroundStyle(C.textPrimary)
                Badge(text: "大字版", bg: C.red, size: 8).offset(x: 12, y: -8)
            }
            Circle().fill(.white).frame(width: 30, height: 30)
                .overlay(Image(systemName: "person.crop.circle")
                    .font(.system(size: 18)).foregroundStyle(C.textSecondary))
            Image(systemName: "ellipsis.message")
                .font(.system(size: 18)).foregroundStyle(C.textPrimary)
        }
        .padding(.horizontal, M.hpad)
        .padding(.top, 8)
    }

    // MARK: 问候
    private var greeting: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color(white: 0.93))
                .frame(width: 62, height: 62)
                .overlay(Image(systemName: "person.fill")
                    .font(.system(size: 30)).foregroundStyle(.white))

            VStack(alignment: .leading, spacing: 5) {
                Text("晚上好，*威")
                    .font(.system(size: 21, weight: .semibold))
                    .foregroundStyle(C.textPrimary)
                Text("上次登录：2026-09-28 18:31:55")
                    .font(.system(size: 11))
                    .foregroundStyle(C.textSecondary)
                HStack(spacing: 3) {
                    Image(systemName: "medal.fill")
                        .font(.system(size: 10)).foregroundStyle(C.gold)
                    Text("1星级").font(.system(size: 11))
                    Image(systemName: "chevron.right").font(.system(size: 8))
                }
                .foregroundStyle(Color(red: 0.72, green: 0.52, blue: 0.20))
                .padding(.horizontal, 8).padding(.vertical, 3)
                .background(Capsule().fill(Color(red: 1.0, green: 0.93, blue: 0.84)))
            }
            Spacer()
            VStack(spacing: 2) {
                ZStack {
                    Circle().fill(Color(red: 0.98, green: 0.72, blue: 0.30)).frame(width: 34, height: 34)
                    Text("1").font(.system(size: 17, weight: .bold)).foregroundStyle(.white)
                }
                Text("已陪伴您").font(.system(size: 9)).foregroundStyle(C.textSecondary)
                Text("2年163天").font(.system(size: 9)).foregroundStyle(C.textSecondary)
            }
        }
        .padding(.horizontal, M.hpad)
    }

    // MARK: 三卡
    private var threeCards: some View {
        HStack(spacing: 8) {
            miniCard(title: "我的账户", value: "1", bg: Color(red: 1.0, green: 0.97, blue: 0.90))
            miniCard(title: "我的待办", value: "0", bg: Color(red: 1.0, green: 0.97, blue: 0.90))
            VStack(alignment: .leading, spacing: 4) {
                Text("我的").font(.system(size: 13)).foregroundStyle(C.textPrimary)
                    + Text("金融画像").font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(red: 0.18, green: 0.42, blue: 0.85))
                Text("快来测测吧")
                    .font(.system(size: 11)).foregroundStyle(C.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.92, green: 0.95, blue: 1.0)))
        }
        .padding(.horizontal, M.hpad)
    }

    private func miniCard(title: String, value: String, bg: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title).font(.system(size: 12)).foregroundStyle(C.textSecondary)
            Text(value).font(.system(size: 20, weight: .semibold)).foregroundStyle(C.textPrimary)
        }
        .frame(width: 84, alignment: .leading)
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 10).fill(bg))
    }

    // MARK: 金刚区 2×4
    private var gridCard: some View {
        VStack(spacing: 16) {
            HStack(spacing: 0) {
                ForEach(gridA, id: \.1) { it in
                    GridItem(symbol: it.0, title: it.1, color: it.2,
                             badge: it.3.map { (text: $0.0, color: $0.1) })
                }
            }
            HStack(spacing: 0) {
                ForEach(gridB, id: \.1) { it in
                    GridItem(symbol: it.0, title: it.1, color: it.2, filled: true)
                }
            }
        }
        .padding(.vertical, 16)
        .background(C.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: M.cardRadius, style: .continuous))
        .padding(.horizontal, M.hpad)
    }

    // MARK: 我的资产（余额长按可改）
    private var assetCard: some View {
        RCard(padding: 16) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Text("我的资产")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(C.textPrimary)
                    Image(systemName: "eye").font(.system(size: 13)).foregroundStyle(C.textSecondary)
                    Image(systemName: "arrow.clockwise").font(.system(size: 12)).foregroundStyle(C.textSecondary)
                    Spacer()
                    Text("投资问诊")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12).padding(.vertical, 5)
                        .background(Capsule().fill(C.wealthGold))
                }

                HStack(spacing: 4) {
                    Text("总资产").font(.system(size: 13)).foregroundStyle(C.textSecondary)
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 11)).foregroundStyle(C.textSecondary.opacity(0.6))
                }

                EditableAmount(amount: store.balance, fontSize: 34)

                Divider()

                HStack {
                    Image(systemName: "e.circle.fill")
                        .font(.system(size: 16)).foregroundStyle(C.brandGreen)
                    Text("邮惠万家资产")
                        .font(.system(size: 14)).foregroundStyle(C.textPrimary)
                    Spacer()
                    Text("零钱享收益 随用随时取")
                        .font(.system(size: 12)).foregroundStyle(C.textSecondary)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10)).foregroundStyle(C.textSecondary.opacity(0.6))
                }
            }
        }
        .padding(.horizontal, M.hpad)
    }

    // MARK: 本月收支
    private var monthFlow: some View {
        RCard(padding: 16) {
            VStack(alignment: .leading, spacing: 10) {
                Text("本月收支")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(C.textPrimary)
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("支出").font(.system(size: 12)).foregroundStyle(C.textSecondary)
                        Text("¥11,871.43")
                            .font(.system(size: 21, weight: .semibold, design: .rounded))
                            .foregroundStyle(C.textPrimary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 6) {
                        Text("收入").font(.system(size: 12)).foregroundStyle(C.textSecondary)
                        Text("¥14,301.00")
                            .font(.system(size: 21, weight: .semibold, design: .rounded))
                            .foregroundStyle(C.textPrimary)
                    }
                }
            }
        }
        .padding(.horizontal, M.hpad)
        .padding(.bottom, 12)
    }
}