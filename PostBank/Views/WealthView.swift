import SwiftUI

struct WealthView: View {
    @Environment(AppStore.self) private var store

    private let g1: [(String, String, Color)] = [
        ("circle.circle", "理财", C.textPrimary),
        ("chart.pie", "基金", C.textPrimary),
        ("shield.lefthalf.filled", "保险", C.textPrimary),
        ("banknote", "存款", C.textPrimary),
        ("doc.text", "私募专区", C.textPrimary)
    ]
    private let g2: [(String, String, Color)] = [
        ("cube", "贵金属", C.textPrimary),
        ("building.columns", "国债", C.textPrimary),
        ("heart.circle", "个人养老金", C.textPrimary),
        ("house", "私人银行", C.textPrimary),
        ("square.grid.2x2", "更多", C.textPrimary)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                header
                assetCard
                gridCard
                newGuest
                managerBar
                Spacer(minLength: 20)
            }
        }
        .background(
            LinearGradient(colors: [C.wealthTop, C.pageBg],
                           startPoint: .top, endPoint: .bottom).ignoresSafeArea()
        )
    }

    private var header: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                Circle().fill(Color(white: 0.85)).frame(width: 38, height: 38)
                    .overlay(Image(systemName: "person.fill")
                        .foregroundStyle(.white))
                HStack(spacing: 6) {
                    Text("热销理财有哪些，速戳")
                        .font(.system(size: 13)).foregroundStyle(C.textSecondary)
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 12).frame(height: 36)
                .background(Capsule().fill(.white))
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 17)).foregroundStyle(C.textPrimary)
                Circle().fill(.white).frame(width: 32, height: 32)
                    .overlay(Image(systemName: "person.crop.circle")
                        .font(.system(size: 19)).foregroundStyle(C.textSecondary))
            }
            .padding(.horizontal, M.hpad)
            .padding(.top, 10)

            // 深棕横条
            HStack(spacing: 8) {
                Image(systemName: "sailboat.fill")
                    .font(.system(size: 15)).foregroundStyle(C.wealthGold)
                Text("U航资配，帮您的资产把把脉！")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color(red: 1.0, green: 0.95, blue: 0.86))
                Spacer()
                Text("一键问诊")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(C.wealthBrown)
                    .padding(.horizontal, 12).padding(.vertical, 5)
                    .background(Capsule().fill(Color(red: 1.0, green: 0.85, blue: 0.50)))
            }
            .padding(.horizontal, 14).padding(.vertical, 11)
            .background(RoundedRectangle(cornerRadius: 12).fill(C.wealthBrown))
            .padding(.horizontal, M.hpad)
        }
    }

    private var assetCard: some View {
        RCard(padding: 16) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("总资产（元）").font(.system(size: 13)).foregroundStyle(C.textSecondary)
                    Image(systemName: "eye").font(.system(size: 12)).foregroundStyle(C.textSecondary)
                    Spacer()
                    Text("查看详情").font(.system(size: 12)).foregroundStyle(C.textSecondary)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 9)).foregroundStyle(C.textSecondary.opacity(0.6))
                }

                // 余额：长按可改
                EditableAmount(amount: store.balance, prefix: "", fontSize: 32, weight: .semibold)

                HStack(spacing: 0) {
                    quadItem("理财", "0.01元起购")
                    quadItem("基金", "U选好基金")
                    quadItem("保险", "去投保")
                    quadItem("个人养老金", "开启养老规划")
                }
                .padding(.top, 4)
            }
        }
        .padding(.horizontal, M.hpad)
    }

    private func quadItem(_ t: String, _ s: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(t).font(.system(size: 12)).foregroundStyle(C.textSecondary)
            Text(s).font(.system(size: 11)).foregroundStyle(C.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var gridCard: some View {
        VStack(spacing: 18) {
            HStack(spacing: 0) {
                ForEach(g1, id: \.1) { it in
                    GridItem(symbol: it.0, title: it.1, color: it.2)
                }
            }
            HStack(spacing: 0) {
                ForEach(g2, id: \.1) { it in
                    GridItem(symbol: it.0, title: it.1, color: it.2)
                }
            }
        }
        .padding(.vertical, 16)
        .background(C.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: M.cardRadius, style: .continuous))
        .padding(.horizontal, M.hpad)
    }

    private var newGuest: some View {
        RCard(padding: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "gift.fill").font(.system(size: 11))
                        Text("新客专区").font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(C.wealthBrown)
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 12, bottomTrailingRadius: 10))

                    Text("精挑细选 | 新人专享 | 低波稳健")
                        .font(.system(size: 11)).foregroundStyle(C.textSecondary)
                    Spacer()
                }

                HStack(alignment: .center, spacing: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("1.28%")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(C.red)
                        Text("七日年化").font(.system(size: 11)).foregroundStyle(C.textSecondary)
                        Text("一元试试")
                            .font(.system(size: 11)).foregroundStyle(C.red)
                            .padding(.horizontal, 10).padding(.vertical, 3)
                            .background(Capsule().fill(C.red.opacity(0.10)))
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("爆款好“理”1元购")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(C.textPrimary)
                        Text("小白理财的安心选择")
                            .font(.system(size: 11)).foregroundStyle(C.textSecondary)
                    }
                    Spacer()
                }
                .padding(16)
            }
            .padding(.top, 12)
        }
        .padding(.horizontal, M.hpad)
    }

    private var managerBar: some View {
        HStack(spacing: 10) {
            Circle().fill(Color(white: 0.88)).frame(width: 34, height: 34)
                .overlay(Image(systemName: "person.fill")
                    .foregroundStyle(.white))
            VStack(alignment: .leading, spacing: 3) {
                Text("亲爱的客户，有什么可以帮您？")
                    .font(.system(size: 13, weight: .medium)).foregroundStyle(C.textPrimary)
                HStack(spacing: 6) {
                    smallPill("我的客户经理")
                    smallPill("远程客户经理")
                }
            }
            Spacer()
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(Color(red: 0.93, green: 0.95, blue: 1.0)))
        .padding(.horizontal, M.hpad)
        .padding(.bottom, 12)
    }

    private func smallPill(_ t: String) -> some View {
        Text(t)
            .font(.system(size: 9))
            .foregroundStyle(.white)
            .padding(.horizontal, 8).padding(.vertical, 3)
            .background(Capsule().fill(Color(red: 0.35, green: 0.55, blue: 0.92)))
    }
}