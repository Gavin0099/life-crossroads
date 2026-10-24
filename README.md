# 人生岔路 Life Crossroads

以原創人生故事探索資源分配與長期選擇的 iPhone 遊戲。
核心受眾為 10～15 歲，娛樂性與啟發性並重；繁體中文、完整離線。

P1 目標為 **8 國、16 種家庭情境、50～70 個事件**，每局 10～15 分鐘、12～18 個重要決策。
首個可玩交付為四國、童年到晚年回顧的完整人生，之後擴至八國。
候選為台灣、日本、美國、德國、印度、巴西、越南、肯亞；資料與內容尚待逐國驗證。

目前 LC-03 分支提供八國16虛構家庭的完整人生、40事件池、七故事線、Event-first與LC-04完整分岔。台灣部分環境成本仍缺同口徑資料，僅作明示家庭試算；比較頁保留缺口，不能當作0。
條件事件切片已交付 PR #3，工程覆審通過、產品維持 Draft／HOLD。下一片以其 `4f268b8` 為基底推進 [RNG-V2 人生多樣性與故事線系統](docs/rng-v2.md)，先建立量測基準，再以相同測試格比較新舊結果；維持不合併。
產品計畫與待決定事項見 [PLAN.md](PLAN.md)。

## 執行引擎

需要 Swift 6 / Xcode 16 以上；部署目標 iOS 17，日常測試在 macOS 執行。

```bash
swift test
swift run life-demo
swift run life-demo --json
swift run -c release life-demo --story-samples
swift run -c release life-demo --batch-report --seed-count 32 > batch-report.json
python3 scripts/render-batch-report.py batch-report.json batch-report.md
python3 scripts/build-data.py --check
```

`life-demo` 比較四國相同決策，並執行五階段、15 個決策的完整人生骨架。
`--story-samples` 輸出同日本／家庭一、Seed 0／1／2 的完整故事與選取依據，並核驗相同 Seed／選擇重播及中途 JSON 存讀；任何核驗失敗都以非零狀態結束。
`--batch-report` 量測四國兩家庭與四種明示策略，預設 Seed 0～31 共1,024局，輸出事件覆蓋、配對人生差異、故事與資源飽和。`--seed-count` 範圍2～128，只用於批次模式；報表分母及限制見 [量測契約](docs/lc05-measurement.md)。
這些是工程與故事路線證據，不代表 10～15 分鐘遊玩、實機或教育效果已驗收。
資料、假設、缺口及 LC-02 開工判斷見 [LC-01 交付](docs/lc01-delivery.md)。

在 Xcode 開啟 `LifeCrossroads.xcodeproj`，選 `LifeCrossroads` scheme 與 iPhone Simulator 執行。
本機 UI 流程測試：`bash scripts/ios-check.sh`。腳本建立專用暫存 Simulator，成功、失敗或中止後均刪除。
`LIFE_SIMULATOR_ID` 僅指定參考裝置的硬體／runtime 設定，不會操作或刪除該原有裝置；也可同時指定 `LIFE_SIMULATOR_DEVICE_TYPE` 和 `LIFE_SIMULATOR_RUNTIME`。
Xcode Launch Arguments 可加入 `-life-seed 0` 重現指定故事；App 的「同種子重新開始」保留背景與 Seed，「換個運氣」保留背景並更換 Seed。完整重現還需要相同選擇與版本。
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

RNG-V2：40 個事件、5 個固定里程碑＋10 個動態時點，七條具來源故事線。完整 1,024 局新舊比較與限制見 [比較報告](artifacts/evidence/rng-v2/comparison.md)；`python3 scripts/run-rng-v2-evidence.py` 可重跑兩次完整樣本。維持 Draft／HOLD，未合併。

## LC-03 國家環境比較

`swift run -c release life-demo --environment-samples` 產出八國×兩家庭×四策略及Seed0/3的128局重播/存讀證據，並比較三組有環境差異的實際事件及一組相同的離線活動。

資料授權、台灣口徑限制、版本與驗收邊界見 [LC-03契約](docs/lc03-country-environments.md)；執行結果見 [比較報告](artifacts/evidence/lc03/environment-report.md)。圖片工作獨立，這個分支不合併、不發布。
