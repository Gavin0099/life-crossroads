# Visual B 交接（場景可接線；整體 PARTIAL / HOLD）

唯一規格仍為 PR9 的本目錄 PLAN／SLICES／CONTRACT／MOTION。本文件是交付紀錄，不新增計畫、工時或產品 Gate。

## 本次進度與來源

上一輪停在前置預查，沒有完成10h。本輪依使用者更正繼續；先收到 LL-01 `6f5e3c1`，後查到 Gameplay／其 Visual r2 已在整合分支 `7040802846d8829ca969d98ff7023d51fb11913d` 提供正式場景。因此最後**沿用該整合場景**，不保留另一份同名正式 View，不要求整枝合併 B 歷史。

最終實作：`803539c`。`LifeWorldScene(frame:motion:)` 仍是純 renderer；Gameplay 擁有時計、事件、保存與主流程。相對7040802只補場景內的 CGImage 裁切、快取及主角尺寸（單人70%、同場60%，另受高度上限限制）；保留既有圖片、家具、token、系統Reduced Motion和單一時間輸入。`LifeWorldMotion.swift` 與7040802的blob完全相同，未另造時計、規則或外部helper。

可採用的差異在 `artifacts/evidence/life-loop-visual/integration/visual-delta-vs-7040802.patch`；A應先對自己的當前分支執行 apply --check，再審查整合。若場景已再變更，人工移植這個小差異，**不要整枝合併或覆蓋主流程**。本B分支未修改 CrossroadsView、GameStore、Domain、Data、Persistence、Package、正式 Xcode project／UITests或既有素材。

## 驗證與圖庫

- 最後同一來源：iPhone17 `standard-20261024T061950Z` **5/5**、SE3 `narrow-20261024T061948Z` **5/5**，0失敗。這是獨立 renderer App，**不是正式App全流程回歸**。
- 固定日本／家庭一／Seed0，真實 Session 經 SaveRepository 保存及重讀，再使用7040802的 WorldMomentProjector。13歲紙本、休息、求助及8／39歲來源皆保存。
- 26項來源核對通過：原始Session與實際save內容一致、權威年齡、契約版本、紙本／休息不同標記、休息不出現老師。這組固定Seed沒有尚未實現的pending clue，該負面案例**未實際覆蓋**。
- 採用的 LifeWorldMotion 有8項純取樣檢查通過：loop接縫、微動幅度、連續輸入、非有限時間、Reduced Motion及one-shot末幀／首幀已提交紀錄仍可見。**不能因此聲稱 Gameplay控制器的暫停／調速／背景行為已驗收。**
- 原先7項Preview取樣與8張macOS影格是早期fixture證據，與現在採用的8項Motion檢查分開，不混計。
- 24張完整原生截圖在 `artifacts/evidence/life-loop-visual/gallery/{standard,narrow}/`；索引、來源SHA與原始attachment對應見 `gallery-index.json`／`native-source-binding.json`。總覽見同層 `contact-sheet.png`。
- 13台本輪專用Simulator全數delete且確認不在inventory；包含失敗、被中止的Xcode收尾及受控1秒逾時。未刪他人裝置、iPhone或共用runtime。收據見 `simulator-cleanup-summary.json`。

首輪兩機各2/3（背景可及性範圍超出畫面）；第二輪各2/3（最大文字入口）；第三輪各3/5（外層覆蓋場景ID），其中SE的Xcode收尾掛住，TERM後result不完整，只有原始log，不宣稱有效xcresult。後續舊候選的5/5為歷史；最終以上述7040802對齊版為準。原始失敗log、截圖樣本及原因留在 evidence；原始xcresult／錄影在本機 `.build/life-loop-visual-ios/`，遠端不重複上傳所有錄影。

## 剩餘 Gate 與工時

VW-01場景與授權交付可接線；VW-02～04的renderer／隔離證據已備，**正式App中的連續生活、pause→resume／1×→3×、背景停更、同Seed分岔與主流程保存失敗、獨立視覺覆審仍由A整合後驗收**。本輪自查不是獨立Critic，G1～G6不因本報告自動PASS。

10 Agent-hours總帳仍為A7／Visual2／覆審1；已查到A並行Visual r2，不能在此再另加2h。觀測視窗及未精確量測的邊界見 `progress-ledger.json`；不同Visual貢獻的總用量須由A合併，不宣稱已跑滿10h或精確剩餘時數。本次不再擴張美術；優先將小差異接回唯一主流程、完成R4及Reviewer。

## 重現

```bash
git fetch origin codex/life-loop-gameplay-10h
python3 tools/life-loop-visual/run_ios.py --device narrow
python3 tools/life-loop-visual/run_ios.py --device standard
# 以上執行器固定使用7040802的package來源，並自動刪除專用Simulator。
xcrun swiftc -swift-version 6 -parse-as-library \
  LifeCrossroads/App/LifeWorldMotion.swift tools/life-loop-visual/VerifyMotion.swift \
  -o .build/life-loop-visual/verify-motion
.build/life-loop-visual/verify-motion artifacts/evidence/life-loop-visual/actual-motion-validation.json
```

run_ios.py的source-binding記錄實際hash；當時HEAD有文件／產物待記錄，不能只拿pre-run HEAD冒充受測所有bytes。`native-source-binding.json`另確認最後兩輪所有受測App／測試／素材bytes相同且吻合803539c。未merge、未發布、未安裝到實機。
