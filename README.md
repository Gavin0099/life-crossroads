# 人生岔路 Life Crossroads

以原創人生故事探索資源分配與長期選擇的 iPhone 遊戲。
核心受眾為 10～15 歲，娛樂性與啟發性並重；繁體中文、完整離線。

P1 目標為 **8 國、16 種家庭情境、50～70 個事件**，每局 10～15 分鐘、12～18 個重要決策。
首個可玩交付為四國、童年到晚年回顧的完整人生，之後擴至八國。
候選為台灣、日本、美國、德國、印度、巴西、越南、肯亞；資料與內容尚待逐國驗證。

LC-01 的純 Swift 引擎與資料已通過遠端 CI；LC-02 已開始四國完整人生 SwiftUI 原型。
產品計畫與待決定事項見 [PLAN.md](PLAN.md)。

## 執行引擎

需要 Swift 6 / Xcode 16 以上；部署目標 iOS 17，日常測試在 macOS 執行。

```bash
swift test
swift run life-demo
swift run life-demo --json
python3 scripts/build-data.py --check
```

`life-demo` 比較四國相同決策，並執行五階段、15 個決策的完整人生骨架。
這是 LC-01 工程證據，不代表 10～15 分鐘遊玩、實機或教育效果已驗收。
資料、假設、缺口及 LC-02 開工判斷見 [LC-01 交付](docs/lc01-delivery.md)。

在 Xcode 開啟 `LifeCrossroads.xcodeproj`，選 `LifeCrossroads` scheme 與 iPhone Simulator 執行。
本機 UI 流程測試：`bash scripts/ios-check.sh`；可用 `LIFE_SIMULATOR_ID` 指定 Simulator。
實機執行需在 Xcode 設定自己的開發團隊並連接 iPhone；Simulator 通過不等於實機 Gate 通過。
LC-02 原型目前關閉 app 後不保留進度；SwiftData 完整存檔屬 LC-06。

## 開始工作

需要 Git 與 Python 3.11+。治理工具在本機 `.venv/` 執行，不加入 iOS app。

```bash
git submodule update --init -- additional/ai-governance-framework
bash scripts/governance-setup.sh
source .venv/bin/activate
bash scripts/governance-check.sh --profile basic
```

若預設 Python 過舊，可指定 `AI_GOVERNANCE_PYTHON=/path/to/python3.12` 執行 setup。
clone 後需重新安裝 hooks；請在啟用 `.venv` 的 terminal 執行 Git 操作。

## 治理入口

- [AGENTS.md](AGENTS.md)：本專案風險、必測路徑、授權及記憶規則。
- [contract.yaml](contract.yaml)：領域契約與框架驗證器入口。
- [專案執行規則](docs/project-guardrails.md)：兒少內容、資料與實機證據邊界。
- [導入紀錄](docs/governance-adoption.md)：固定版本、驗證結果及待驗收項目。
- [P1 slices](docs/p1-slices.md)：八國完整人生的七個開發切片與驗收條件。

框架以 submodule 固定版本。後續更新依框架 F-7 流程；不手動更新 pointer/lock 後宣稱受治理更新完成。
本機檢查產物位於 `artifacts/governance/`，CI 使用相同指令並上傳證據。
基本檢查為 CI 必過工作；`--profile full` 執行完整治理稽核，在 CI 採 advisory。
完整 runtime 治理尚未驗證，不是開始遊戲開發的前置條件。

## 參考與權利

產品參考：[born-somewhere](https://github.com/rollroyces/born-somewhere)、
[1in8b.life 教學入口](https://1in8b.life/zh/?edu=1)。本專案自行設計內容，不沿用其內容庫。
治理框架來源與授權見 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)。
