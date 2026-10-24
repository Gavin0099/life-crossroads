# P1 Integrated Preview 0.1｜八國完整人生整合測試版

日期：2026-10-24。**用途：工程／玩法預覽；非 App Store 發布或 P1 完成宣告。**

## 可追溯基線

- 原 `main`：`f194808bc2808d5358ee18ee842567731404cd22`，已包含合併的 [LC-04 PR #5](https://github.com/Gavin0099/life-crossroads/pull/5)，提供回到岔路、完整後半生比較及一組本機原子存檔。
- 本預覽基於 [LC-03 PR #6](https://github.com/Gavin0099/life-crossroads/pull/6) HEAD `4a6e32bc3a0ad980bca9eecd1c02d9bc57f9a6b5`，八國／16 家庭及同選擇環境比較。PR #6 仍是 Draft，未合併 main，完整資料 Gate 尚未通過。
- CI 來源：[PR #6 Project CI #40056224935](https://github.com/Gavin0099/life-crossroads/actions/runs/40056224935)，已確認與 `4a6e32b` 相同 HEAD 的 basic-checks、swift-engine、ios-app、governance-audit 四項成功。該 CI **沒有檢查本預覽分支的後續小幅畫面／文件變更**；應以本預覽 PR 新觸發的 CI 為準。
- 未重設原 PR #5／#6 的提交或替它們宣稱合併。

## 這一版已可測試的實際功能

| 項目 | 預覽涵蓋 |
| --- | --- |
| 出生情境 | 台灣、日本、美國、德國、印度、巴西、越南、肯亞，共八國，每國兩組明示虛構家庭情境 |
| 人生 | 五階段至80歲回顧，15次重要選擇，40個原創事件及七條故事線 |
| 事件 | 固定 Seed、候選權重、故事記憶、前後呼應和事件來源 trace |
| 跨背景選擇 | 相同實際事件及選項的不同國家成本／支持／可行性比較，另有同國兩家庭情境比較 |
| 人生分岔 | 原局完整保留，從一項已發生的重大選擇改選，由玩家自行走完整段後半生，再比較人物、事件、選項與資源 |
| 離線儲存 | JSON 原子保存與恢復：一個原人生及最多一條改選後的人生；不含多存檔、SwiftData 或跨版本自動遷移 |
| 畫面 | 目前正式 App 已有的原創動物角色／想像河畔插畫與 Event-first SwiftUI；**未合入新 Visual Agent 的 WIP 或未核准素材** |

## 明確限制

1. **台灣資料不完整。** 台灣數位調查母體是12歲以上國民，衛福部的家庭自付指標與 WHO 口徑不同；不能拿來填入跨國相同成本公式。App 對缺少的成本標成「未估／無法判斷」，不是0，也不是沒有服務。
2. 八國可玩不代表八國家庭真實統計聯合分布已重建。國家背景、虛構家庭、可行成本與模型選擇效果須各自辨識；沒有依國籍判定成功或道德價值。
3. 圖片 Agent 仍獨立開發。舊 `codex/lc-visual-design`、`codex/ui-visual-loop-4h` 與 `codex/sim-workshop-continuity` 均不是基於本預覽 HEAD；**不得整枝合併、直接覆蓋 Domain／App 或自動批准素材**。經人工選稿／權利審查後，再以素材 ID 和 View DTO 選擇性接入。
4. 舊版存檔與目前 `rng-v2-1` 及 LC-03 版本不相容時要明確拒絕，原檔保留；本版沒有跨版本遷移。
5. 仍待：完整 LC-03 同口徑資料 Gate、50～70事件的最終內容量、10～15分鐘真人節奏、實機／人工 VoiceOver、10～12和13～15歲試玩及兒少理解／重玩意願。
6. CI Simulator Build ≠ 可直接安裝在 iPhone 的簽署 IPA；這個分支不包含 TestFlight 發布、簽章或 App Store 審核。

## 本機啟動／操作路徑

```bash
git fetch origin
git switch integration/p1-preview-20261024
git submodule update --init --recursive
python3 scripts/build-data.py --check
swift test -c release
bash scripts/ios-check.sh
```

在 Xcode 開啟 `LifeCrossroads.xcodeproj`，選 `LifeCrossroads` scheme 並指定 iPhone Simulator。需要真實 iPhone 時，在本機設定自己的 Team／Bundle Signing，再用 Xcode 執行；不能假設 GitHub Actions 的 xcresult 是可安裝套件。

人工 Demo 建議：先挑日本家庭一與台灣家庭一各走一次、打開13歲線上創作比較（台灣留缺口）；完成一生後選13歲岔路改成紙本，再走完整個後半生，檢視最後「原人生／改選人生」差異。最後用同背景、不同 Seed 再玩一次，確認故事的隨機性與可追溯性。

## 整合／驗收策略

- **本預覽 PR 對 PR #6 分支提出**，只納入預覽說明及小幅標示；不改國家資料、隨機引擎、分岔及存檔規則。
- 預覽通過 CI 只能證明可用來試玩，不自動通過 LC-03 產品 Gate。
- PR #6 經獨立資料與程式審查、必要修正及 HEAD CI 成功後，再決定是否合併 main；之後本預覽分支要重新檢視 base／CI，不以一個疊加 PR 取代 LC-03 審查。
- Visual Agent 可以此分支的 App 功能與 View DTO 作預覽素材的整合目標；**圖片正式選稿和授權檢查仍單獨驗收**。

## 測試證據來源

PR #6 本機記錄 96 Swift、23 Python、八項完整 UI 加一項定向 UI；遠端相同 HEAD 的四項 CI 成功。數據代表該候選的工程證據，不宣稱本預覽 branch 自己已實測，亦不把 128 局的兩 Seed 當作人口代表性樣本。
