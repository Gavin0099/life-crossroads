# WORLD-ART-01：河畔生活場景（歷史候選，已由 PR9 規格取代）

本文件僅保留 PR9 採納前的原型工作紀錄，不是另一份現行計畫。正式規格唯一來源為 PR9 `c823c82` 的 docs/life-loop-10h 四份文件；舊型別與自行 Timeline 不符合新的共同累積時鐘，不能整枝接入。

本片原負責 Visual World。共同凍結基底為 PR #8 `c136bebf48ae17e24235d9da72d7f9e51b90bf0c`；Gameplay 負責 `life-world-view-1` 契約與正式整合。

## 交付邊界

- 獨立 `LifeWorldScene(state: LifeWorldViewState)`，只讀人物、光線、暫停、片段進度與帶來源的事實；不接受決策／存檔回呼。
- 河畔門廊背景、童年／青少年待機／移動／互動六格透明圖集；既有 StoryCast 的成年／中年／老年及其他人物繼續沿用。
- 一張背景、主角姿勢圖集，以及針對獨立覆核 P1 修正的既有阿禾／樹老師互動圖集；不增加角色種類。候選素材只在獨立分支供 review，尚未核准進正式 App。
- 不改 Domain、Data、決策、機率、保存格式、`CrossroadsView.swift`、Gameplay 的 DTO 或正式 Xcode project。

## 畫面與行為規格

同一門廊保留背景、人物、物件、光線四層。主角顯示框取畫面寬度 82%，最大為場景高度 68%；一般手機畫面角色不再縮成 88×68 圖示。整合時請給元件至少 420pt 高，建議使用安全區中主要可用高度；不能再次塞進小型選項卡。

`progress` 沿門廊定位移動人物，姿勢取 `behavior`；本機 Timeline 只提供微幅呼吸／步伐起伏。`isMotionPaused`、Reduce Motion、App 非 active 時停止本機 Timeline。沒有 UI 亂數、離線補時、事件抽取或資源計算。步行是單姿勢配位移的原型，並非完整逐幀步態。

主角五個年齡造型沿用既有素材，僅童年／青少年有本片新增的三種姿勢。成年以後保留既有靜態造型配移動，不能宣稱五階段完整動作素材已完成。`resting` 降低姿態，沒有憑空畫病痛或疲勞數值。

世界變化只從 `visibleChanges` 畫出：聯絡卡、創作本、分工表、修理／觀察紀錄等小物件。不把 seeking／none／paused 畫成獲得支持、完成作品或未來獲獎。每件可點閱 `title` 與實際紀錄年齡；eventID／choiceID 留在 DTO 及測試快照中，不把開發識別字串放進玩家文字。看物件不修改人生。多物件橫向捲動，保留 44pt 觸控面積。

未知 sceneID 顯示缺場景狀態；空人物／空變化不補造人物或經歷。背景是跨國共用寓言，不代表各國實景或家庭實際設備。

## 獨立預覽與驗證

`tools/world-art-preview/PreviewApp.swift` 有 SwiftUI Preview 與可執行原生 harness。fixtures 使用正式 catalog / LifeSession 生成的紀錄：待機、步行、10歲朋友互動、13歲紙本創作、晚年、詢問協助。這些是預覽流程，不是假裝已接入正式生活循環。

```bash
source .venv/bin/activate
python tools/world-art-preview/run.py --contract-repo /path/to/gameplay/worktree --device standard
python tools/world-art-preview/run.py --contract-repo /path/to/gameplay/worktree --device narrow
```

執行器將 Gameplay 的兩份公開契約複製到忽略的 build support snapshot，記錄 SHA256；不寫入 Gameplay 工作樹或正式 Presentation 檔案。不提供參數時使用本片保留的 `contract-snapshot` 原樣公開契約快照，方便獨立重現。新元件和素材直接由本分支編譯。測試成功／失敗皆刪除本次專用 Simulator，留下收據；SIGTERM 亦會先終止 Xcode 子程序再清理。正式人生／存檔／Seed 回歸由 Gameplay 整合後執行，不能拿本片 harness 代替。

減少動態的自動案例使用 Debug 預覽專案啟用的 `-reduce-motion` 開關，走與系統 Reduce Motion 相同的視覺停止分支；不等於已實機操作系統設定。正式元件讀取系統環境，背景／暫停一併停止 Timeline。PNG 位元資料包含編碼差異，因此停止動畫的斷言比較解碼後像素；另外斷言角色可及性範圍不超過手機寬，保護圖集裁切回歸。

驗證結果、來源 hash、原生截圖與 cleanup 收據見 `artifacts/world-art/`；以本輪實際產物為準。獨立美術覆核、實機與兒少試玩另列，不從 build 或 UI 測試推論。

## Gameplay 整合步驟

1. 固定並提交 Gameplay 擁有的 `LifeWorldViewState.swift` / `LifePlayback.swift`，核對本片 source-binding 中契約 hash；若不同先檢視差異。
2. 取本片 `LifeWorldScene.swift` 和三個新增 imageset。不要同時採用另一份同名場景實作；由 Gameplay 選定替換點。
3. 在正式 project 登記新元件，於持續存在的世界區域傳入 DTO；速度／暫停／下一事件和後果浮層仍由 Gameplay 擁有。
4. 在整合來源版本驗證兩事件進入／暫停／決策／返回原場景，再跑全人生與存讀回歸；此後獨立 reviewer 檢視整合版真實截圖。

GAP：本分支尚未接正式主流程，因此無完整人生與正式場景元件的整合回歸。風險是整合後被壓成小卡或遮擋操作。關閉條件為 Gameplay 完成正式接線、雙機截圖與完整回歸。沒有新引擎或存檔格式變更。


## 獨立覆核後的 P1 修正

初版雙機5/5雖通過，Reviewer仍確認便條浮於夥伴胸前且視線未集中；原生圖與初版判定保留，不把測試當美術批准。修正版把便條附著主角手掌的局部座標，隨同姿勢縮放／轉動；僅為既有阿禾與樹老師補一組俯視共同物件的互動姿勢。三個候選imageset尚未批准進正式App。修正版必須另有同來源雙機回歸與新的獨立實圖覆核，舊5/5不能直接沿用。
