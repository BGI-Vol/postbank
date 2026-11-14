import SwiftUI

struct HomeView: View {
    @Environment(AppStore.self) private var store

    private let grid1: [(String, String, Color, (String, Color)?)] = [
        ("creditcard.fill", "充值特惠", C.ic1, ("充值·省", C.red)),
        ("bolt.fill", "生活缴费", C.ic2, nil),
        ("mappin.circle.fill", "本地服务", C.ic3, nil),
        ("building.columns.fill", "政务便民", C.ic4, nil),
        ("gift.fill", "活动专区", C.ic5, nil)
    ]
    private let grid2: [(String, String, Color, (String, Color)?)] = [
        ("envelope.fill", "中国集邮", C.ic1, ("邮票金", C.red)),
        ("film.fill", "电影票", C.ic2, nil),
        ("bag.fill", "邮乐商城", C.ic4, nil),
        ("shippingbox.fill", "快递服务", C.ic4, nil),
        ("square.grid.2x2.fill", "更多", C.icGray, nil)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                header
                bannerArea
                quickFour
                gridCard
                noticeBar
                hotNews
                wealthPick
                Spacer(minLength: 24)
            }
        }
        .background(C.pageBg.ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
    }

    // MARK: 顶部（天空渐变 + 搜索）
    private var header: some View {
        VStack(spacing: 0) {
            // 状态栏占位
            Color.clear.frame(height: 54)

            HStack(spacing: 10) {
                Image(systemName: "message.fill")
                    .font(.system(size: 17))
                    .foregroundStyle(C.textPrimary)
                HStack(spacing: 6) {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(C.textSecondary)
                    Text("省税啦，最高5400！")
                        .font(.system(size: 13))
                        .foregroundStyle(C.textSecondary)
                    Spacer(minLength: 0)
                    Text("搜索")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(C.textPrimary)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(RoundedRectangle(cornerRadius: 5).fill(Color(white: 0.95)))
                }
                .padding(.horizontal, 10)
                .frame(height: 34)
                .background(Capsule().fill(.white))

                Circle().fill(.white.opacity(0.9)).frame(width: 32, height: 32)
                    .overlay(Image(systemName: "person.crop.circle")
                        .font(.system(size: 19)).foregroundStyle(C.textSecondary))
                Circle().fill(.white.opacity(0.9)).frame(width: 32, height: 32)
                    .overlay(Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold)).foregroundStyle(C.textPrimary))
            }
            .padding(.horizontal, M.hpad)
            .padding(.bottom, 10)
        }
        .background(
            LinearGradient(colors: [C.homeGreenTop, C.homeGreenBot],
                           startPoint: .top, endPoint: .bottom)
        )
    }

    // MARK: Banner（用色块 + 文字近似，无原图素材）
    private var bannerArea: some View {
        ZStack(alignment: .topTrailing) {
            LinearGradient(colors: [C.homeGreenBot, Color(red: 0.93, green: 0.99, blue: 0.96)],
                           startPoint: .top, endPoint: .bottom)
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 6) {
                    Image(systemName: "e.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(C.brandGreen)
                    VStack(alignment: .leading, spacing: 0) {
                        Text("中国邮政储蓄银行").font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(C.brandGreen)
                        Text("POSTAL SAVINGS BANK OF CHINA").font(.system(size: 6))
                            .foregroundStyle(C.brandGreen.opacity(0.7))
                    }
                    Spacer()
                }
                .padding(.horizontal, M.hpad)
                .padding(.top, 4)

                HStack(alignment: .center, spacing: 8) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("邮储成长学院")
                            .font(.system(size: 26, weight: .heavy))
                            .foregroundStyle(C.brandGreen)
                        HStack(spacing: 4) {
                            Text("成长学院专属增值福利")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8).padding(.vertical, 3)
                                .background(Capsule().fill(C.brandGreen))
                        }
                        Text("即时报名")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14).padding(.vertical, 5)
                            .background(Capsule().fill(Color(red: 1.0, green: 0.62, blue: 0.20)))
                            .padding(.top, 2)
                    }
                    Spacer()
                    // 右侧插画位（无素材，用几何近似）
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0.62, green: 0.87, blue: 0.72))
                        .frame(width: 150, height: 96)
                        .overlay(
                            Image(systemName: "tree.fill")
                                .font(.system(size: 46))
                                .foregroundStyle(.white.opacity(0.85))
                        )
                }
                .padding(.horizontal, M.hpad)
                .padding(.top, 6)
                .padding(.bottom, 12)
            }

            Text("广告")
                .font(.system(size: 9))
                .foregroundStyle(.white)
                .padding(.horizontal, 5).padding(.vertical, 2)
                .background(Capsule().fill(.black.opacity(0.25)))
                .padding(.trailing, 10)
                .padding(.top, 34)
        }
    }

    // MARK: 四个大按钮
    private var quickFour: some View {
        let items: [(String, String)] = [
            ("person.crop.circle.badge.checkmark", "我的账户"),
            ("arrow.left.arrow.right", "转账汇款"),
            ("yensign.circle", "贷款"),
            ("chart.line.uptrend.xyaxis.circle", "天天盈+")
        ]
        return HStack(spacing: 0) {
            ForEach(items, id: \.1) { icon, title in
                VStack(spacing: 8) {
                    ZStack {
                        Circle().fill(C.brandGreen).frame(width: 54, height: 54)
                        Image(systemName: icon)
                            .font(.system(size: 24))
                            .foregroundStyle(.white)
                    }
                    Text(title).font(.system(size: 13)).foregroundStyle(C.textPrimary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, M.hpad)
        .padding(.vertical, 14)
        .background(C.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: M.cardRadius, style: .continuous))
        .padding(.horizontal, M.hpad)
        .offset(y: -8)
    }

    // MARK: 金刚区
    private var gridCard: some View {
        VStack(spacing: 14) {
            HStack(spacing: 0) {
                ForEach(grid1, id: \.1) { it in
                    GridItem(symbol: it.0, title: it.1, color: it.2,
                             badge: it.3.map { (text: $0.0, color: $0.1) })
                }
            }
            HStack(spacing: 0) {
                ForEach(grid2, id: \.1) { it in
                    GridItem(symbol: it.0, title: it.1, color: it.2,
                             badge: it.3.map { (text: $0.0, color: $0.1) })
                }
            }
            // 分页指示
            HStack(spacing: 5) {
                Capsule().fill(C.brandGreen).frame(width: 14, height: 3)
                Capsule().fill(C.separator).frame(width: 5, height: 3)
                Capsule().fill(C.separator).frame(width: 5, height: 3)
            }
            .padding(.top, 2)
        }
        .padding(.vertical, 16)
        .background(C.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: M.cardRadius, style: .continuous))
        .padding(.horizontal, M.hpad)
    }

    // MARK: 公告
    private var noticeBar: some View {
        RCard(padding: 12) {
            HStack(spacing: 8) {
                Text("[小邮公告]")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(C.brandGreen)
                Text("中国邮政储蓄银行信用卡核心系统升级公告")
                    .font(.system(size: 12))
                    .foregroundStyle(C.textPrimary)
                    .lineLimit(1)
                Spacer(minLength: 4)
                Badge(text: "NEW", bg: C.red)
                Image(systemName: "xmark")
                    .font(.system(size: 10))
                    .foregroundStyle(C.textSecondary)
            }
        }
        .padding(.horizontal, M.hpad)
        .padding(.top, 12)
    }

    // MARK: 热点资讯
    private var hotNews: some View {
        RCard(padding: 0) {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("热点资讯 触手可及")
                        .font(.system(size: 19, weight: .heavy))
                        .foregroundStyle(Color(red: 0.18, green: 0.42, blue: 0.85))
                    Text("财经内容全覆盖，总有你的“专属”频道")
                        .font(.system(size: 11))
                        .foregroundStyle(C.textSecondary)
                    Text("点击体验")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16).padding(.vertical, 6)
                        .background(Capsule().fill(Color(red: 0.25, green: 0.55, blue: 0.92)))
                }
                .padding(16)
                Spacer()
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.90, green: 0.94, blue: 0.99))
                    .frame(width: 110, height: 92)
                    .overlay(Image(systemName: "newspaper.fill")
                        .font(.system(size: 34))
                        .foregroundStyle(Color(red: 0.55, green: 0.70, blue: 0.90)))
                    .padding(.trailing, 14)
            }
        }
        .padding(.horizontal, M.hpad)
        .padding(.top, 12)
    }

    // MARK: 财富精选
    private var wealthPick: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("财富精选")
                    .font(.system(size: 19, weight: .bold))
                    .foregroundStyle(C.textPrimary)
                Spacer()
                Image(systemName: "ellipsis")
                    .foregroundStyle(C.textSecondary)
            }
            .padding(.horizontal, M.hpad)

            HStack(spacing: 10) {
                pickCard(title: "新人大礼包", sub: "最高 88 元", bg: Color(red: 1.0, green: 0.94, blue: 0.86))
                pickCard(title: "投资资讯", sub: "每日更新", bg: Color(red: 0.88, green: 0.95, blue: 1.0))
            }
            .padding(.horizontal, M.hpad)
        }
        .padding(.top, 14)
    }

    private func pickCard(title: String, sub: String, bg: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(C.textPrimary)
            Text(sub)
                .font(.system(size: 11))
                .foregroundStyle(C.textSecondary)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 74)
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 10).fill(bg))
    }
}