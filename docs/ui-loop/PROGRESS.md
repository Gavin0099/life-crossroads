# Visual Loop Progress

## VA-01 / Round 0 — 2026-10-23

Problem：GS工程可操作，但窄螢幕及大字第一屏被身份／資源／場景擠滿；紙橋與清單漂浮，人物沒有做出文案描述的活動。

Hypothesis：先將完整資源收合、縮短身份層級並以可用高度配置世界與事件，可恢復決策辨識；再加入同一工作平面和少量實際動作候選，讓兩路差異由畫面傳達。

Edit：固定最新GS checkpoint 9bd75d2，建立獨立branch與四小時deadline；保留原kit並修正執行器Gate設計；鎖定STYLE_GUIDE。尚未改動新loop UI。Root正在生成必要的兩路動作候選。

Evidence：基底42張原生圖及12個方法／裝置組合通過；它們只證明checkpoint工程，不是新loop品質。獨立Critic-00親看11張畫面與角色atlas，判定CHANGES_REQUESTED，P0=0、P1=2、P2=1。

Risk：新圖仍可能出現身份錨或手部漂移；測試能通過不等於美術合格；中間年份依舊是作者省略片段。

Next：第一輪只優先修普通／大字第一屏的事件與決策層級；保留可捲動完整資源及既有所有流程。

## VA-02 / Round 1 — 2026-10-23

Problem：對應 Critic-00 **P1-01**。親看 standard／narrow 的 `01-world-home.png`、narrow `accessibility-home.png` 與 standard `accessibility-reaction.png`：SE 普通首頁看不到完整選項，標準首頁第二項代價被導覽切斷；最大字級的首頁及反應先被身份與資源填滿。這些都是基底實圖，不能用來驗收本輪修改。

Hypothesis：將身份變成短列、完整資源移到事件之後並預設收合，以可用高度縮放場景及人物，可為普通首頁留下兩項決策空間。最大字級先給明確的事件／決策入口，導覽改為隨內容捲動，選後直接對準反應，可保留完整放大文字而不以字級上限換空間。

Edit：

- `WorldGameplayView.swift`：移除獨立品牌大標題，保留身份、年齡、年份與時段；首頁改用既有事件名「紙橋又歪了一邊」。場景高度按可用高度在 170–300pt 之間調整，人物隨高度縮放，降低事件浮層的重疊。
- 完整四項資源移至事件之後，以「四項近況」展開／收合；展開後逐項直排、文字隨系統字級增長，沿用所有 fixture 值與缺資料語意。每次新故事片段將此區收合。
- 兩項行動保留 `team`／`help`、既有完整標題與質性代價；代價改用不透明的 footnote 字級，按鈕至少 44pt。最大字級移除按鈕裝飾圖示，將寬度交給文字，首屏新增「前往選擇」捲動入口。
- 選後心聲移至事件浮層頂端，避免縮短場景後遮角色；最大字級選後捲到反應。最大字級的時光過場文字也放進可捲動事件區。錯誤狀態對準事件，維持缺資料時的原有阻擋／重啟流程。
- 移除本 view 的 Dynamic Type 上限。普通字級保留底部安全區導覽；無障礙字級改為內容底部直排導覽，以免固定區占滿螢幕。
- `WorldGameplayTests.swift`：在既有方法加入普通首屏兩個完整按鈕／代價清晰位於導覽上方、四項資源可展開讀取、最大字級入口可見／可到兩項代價／選後反應可見的斷言。捲動輔助函式同時依螢幕與導覽邊界計算可見區，支援隨內容捲動的導覽；既有方法與截圖名稱保留。

可觀察預期：iPhone 17／SE3 普通首頁能一起看全兩個選項與各自的時間、材料／等待代價；最大字級初始畫面可見事件與「前往選擇」，點擊後可捲到兩個完整行動。兩路選後先看到心聲；資源仍能展開閱讀，底部內容不被導覽蓋住。這些是待驗收的預期，不是本輪實圖觀察。

Evidence：本輪僅做原始碼 diff 與靜態文字比對：原有 UI 方法、所有 `capture` 名稱保留，view 內 Dynamic Type 上限為 0，兩個 Swift 檔沒有尾端空白。**build／Swift tests／UI tests／本輪截圖皆 NOT_RUN，交 supervisor 執行**。系統 `git`／`python3` 包裝器曾輸出 xcrun cache 與 xcodebuild 初始化診斷；沒有要求專案 build，亦沒有產生本輪 app 驗證證據。未更新或冒用任何舊測試結果／critic 報告。

Risk：尚未經編譯或原生實圖確認，170–300pt 的場景配置、普通首屏空間、最大字級捲動位置及新斷言均需 supervisor 驗證。P1-02 的靜態角色／漂浮道具／工作平面問題仍在，P2-01 身份錨仍未解決；本輪沒有導入動作圖。`assets/gameplay/va-*`、prompts、manifest 未改。沒有真人遊戲感、實機或手動 VoiceOver 結論。

Next：唯一優先是用本輪 supervisor 的新截圖與 UI 結果驗收 P1-01；若首屏／最大字級仍不符合，下一輪只修此層級。動作／道具留待此優先項確認後處理。

## VA-03 / Round 2 — 2026-10-23

Problem：**P1-01 仍未取得新畫面驗收**。supervisor 提供的 `round-01-standard-ui` 為 exit=1；親讀 `/Users/macminim4/.codex/visual-loop-control/01a16763/round-01-standard-ui.stderr.log`，入口在選擇 runtime 時回報 `No installed iOS runtime supports the requested device type`，不是 app 編譯或 UI 斷言失敗的證據。沒有 Round 1 After 或新 critic 可供判定。本輪重新親看 GS 基底 standard／narrow `01-world-home.png`、narrow `accessibility-home.png`、standard `accessibility-reaction.png`，它們仍只支持原始層級問題。原始碼另可見首屏場景以固定 470pt 扣除估算，沒有依事件文字實際換行及導覽高度分配空間；這是實作風險，**不是已觀察到的 Round 1 回歸**。

Hypothesis：量測身份列、完整事件面板及固定導覽的自然高度，再將剩餘高度分配給場景，可比固定估算更可靠地保留兩個完整選項。把事件名稱與場景狀態放在同一個標頭、共用收合控制，也可減少重複的直向空間，將空間留給角色與決策。

Edit：僅改 `WorldGameplayView.swift` 與本輪兩份紀錄。

- 用背景 GeometryReader／PreferenceKey 量測身份列、事件面板、普通字級導覽。普通待選狀態依實際剩餘高度配置 128–300pt 場景；事件上疊的 12pt 留作選項底部與導覽之間的餘裕。未收到量測、收合或選後時維持原估算，大字場景維持 190pt。
- 將 `scene-state` 與 `beat-title` 組成同一個直排標頭，44pt 收合控制在旁；刪除原先獨立標題列及其重複間距。正文、選項及代價文字沒有刪減，角色仍隨場景縮放。
- 保留 Round 1 的最大字級入口、完整捲動、資源展開及選後反應定位；沒有新增 CTA 或字級上限。沒有改 fixture、choice IDs、UI tests、capture 名稱、project、runner 或素材。`va-*`、prompts、manifest 保留原樣。

可觀察預期：普通 iPhone 17／SE3 不捲動時，兩個完整行動及代價都在固定導覽上方，世界能利用文字之外的剩餘高度。最大字級仍先看到事件／「前往選擇」，可依序讀完正文、兩項代價與四項近況；兩路選後反應、收合／展開及錯誤／重啟不受標頭重排影響。這些是**待 supervisor 驗證的預期**。

Evidence：Builder 只執行 source diff 與 Ruby 原始碼文字檢查：25 個 accessibility identifier 宣告與本輪修改前相同，沒有 Dynamic Type 上限或尾端空白，三個量測區域已接入。既有六個 UI 方法與 20 個 capture 呼叫宣告保留；沒有修改測試來放寬門檻。一次 heredoc 文字檢查因 sandbox 不能建立暫存檔而未執行，改用 `ruby -e` 完成同一項唯讀檢查。**本輪 build／Swift tests／UI tests／新截圖均 NOT_RUN**；沒有啟動 Simulator、xcodebuild 或其他測試入口，也未修改 Round 1 的失敗紀錄。

Risk：PreferenceKey 接線、首輪量測後的版面穩定性、標頭在最大字級的換行與兩機型實際餘裕皆未經編譯或原生圖確認。較大的非無障礙字級若已需超過一屏，保留至少 128pt 世界並允許捲動，不壓縮或截斷文字。P1-02 的動作／工作平面及 P2-01 身份錨仍開放；本輪沒有整合動作圖，也沒有真人遊戲感、實機或 VoiceOver 結論。

Next：唯一優先是由 supervisor 以可用且支援該機型的既有 runtime 取得本輪 build、兩機型 UI 結果與新截圖，驗收 P1-01。Builder 不改 runner／安裝 runtime；待新證據確認層級後再進動作／道具。

## VA-04 / Round 4 — 2026-10-23

Problem：追加 acting v1.1 尚未實作；Critic-00 P1-02 的站立角色／漂浮道具仍見於 Round 2 實圖。最新 round-02-standard-ui stderr 為 exit=1，失敗方法是最大字級；同輪 schema/accessibility review 記錄五方法通過、一方法失敗。本輪親看 GS SE 首頁、Round 2 standard 首頁／兩路反應／大字首頁及三張 root 候選原圖，沒有本輪 After 或新 critic。Round 3 已有 direct choices anchor 與 sheet viewport source 修正，保留不重做。

Hypothesis：用同一 presentation state 驅動原圖 portrait、姿勢 foreground、道具與 accessibility JSON，並讓 native catalog 共用 renderer，可把實際演出與 XCTest 觀測綁在一起。整張工作桌候選應能讓兩路透過手、共同焦點與真實平面辨識，而不是只改文字。

Edit：

- WorldGameplayView 同檔新增 ActorEmotion（neutral/thinking/hopeful/tired）、ActorPose（idle/collaborating/asking）、ActorStageVisualState 與共用 portrait／stage renderer。初始 thinking/idle；已接受的 team-reaction 為 hopeful/collaborating；help-reaction 為 neutral/asking。映射檢查真實 workshop-2027、selected key 與 snapshot；bridge 只是 art/proof alias。
- 初始用既有 cast 加 SwiftUI 材料工作面；兩路反應分別使用原 friend-v2／teacher-v2 整組前景，不疊舊人物、名牌或漂浮道具。原四格 portrait 精確顯示在初始標頭及反應對話。三張候選原 PNG 複製至同名 imageset，來源、prompts、manifest 不變，無新生成／像素修改。
- App 的 -acting-contact-sheet 開啟原生四表情／三姿勢目錄，與遊戲共用實際 component 及 catalogs。選擇轉場為 0.25 秒，Reduce Motion nil animation 直接相同終態。缺 route 保留 initial；缺 next 保留最後有效反應；隔天／成年保留原 fallback。WorldModels 僅將朋友「坐在旁邊」改為「在旁邊」、老師「坐到桌邊」改為「來到桌邊」，不改故事結果。
- 保留六個既有 UI 方法與全部 20 個 capture 呼叫；新增四個精確 mandatory 方法。branch test 讀 native rendered catalog，從初始及實際 team/help 點擊後的 world-actor accessibilityValue 讀 JSON，再附上 acting-state-observations.json／keepAlways；預期斷言不代填觀測。Reduce Motion test 對兩路比較實際 actor 字典、反應、不確定性與 enabled continuation；另驗缺 route 與 acting-contact-sheet 七項 frame／截圖。
- 最大字級入口補兩秒 hittable predicate 與 accessibility-decisions capture，保留無額外 swipe 斷言；sheet 捲動改用當前 sheet ScrollView。新 ACTING_IMPLEMENTATION 說明接線／限制，FINAL_REVIEW 改為本輪 PARTIAL。

可觀察預期：三個流程狀態用同一阿澄、不同真實表情與姿勢；合作是試做且仍需修改，求助是待借用清單且未取得工具。native contact sheet 的七樣本可見，UI 觀測附件可由 supervisor 直接匯出並跨裝置核對；減少動態效果不改結果。普通首屏仍應有兩個完整行動與代價，大字入口應直接到第一選項。這些全是待執行預期，不是 After 結論。

Evidence：Ruby source／JSON／Digest 靜態檢查確認十個精確 mandatory method 宣告、全部 20 個既有 capture 呼叫、三個 imageset PNG 與 manifest hash 完全相同、原 prompt hashes 相同及尺寸 1254×1254／1536×1024／1536×1024，approved_for_app=false，touched Swift files 無尾端空白；人工閱讀 source diff。沒有手寫 acting-state-proof 或 observation fixture。build／Swift tests／UI tests／本輪截圖皆 NOT_RUN。一次唯讀系統 git status 包裝器輸出 xcrun cache／xcodebuild 初始化診斷，未要求專案 build 或測試；後續只用 diff／Ruby，不將該診斷當驗證。

Risk：新程式未編譯，native catalog frame、actor accessibilityValue 的實際匯出、同屏表情辨識、兩機型首屏及最大字級均未驗證；portrait 增加標頭高度，需重驗 P1-01。P1-02 僅 source 已接線，不能稱美術通過。P2-01 身份錨／舊 idle 尾部／13與22歲識別仍待驗；隔天／成年舊 fallback 的道具平面尚在。沒有真人、實機、手動 VoiceOver、商用批准結論，候選 approved_for_app=false 保留。

Next：唯一優先是 supervisor 對目前 source 跑既有 Swift/flow/alpha/provenance 與雙機型十方法，匯出真實 acting-state-observations.json 和 acting-contact-sheet，再以新畫面評 P1-01／P1-02。先修第一個實際編譯或 UI blocker，不以 declaration 或靜態 hash 代替 Gate。

## Round 5 — controlled native takeover after CLI transport interruption

Problem: Round 4 wrote the acting implementation but spent over twenty minutes including repeated WebSocket/HTTPS reconnects and did not return a final receipt. Root stopped that supervisor; the fourth attempt and transcript remain preserved, with no test PASS claimed.
Hypothesis/edit: isolate machine observations behind -acting-proof while normal VoiceOver reads Chinese. Apply the independently prepared minimal patch and keep all ten tests, including an ordinary-mode Chinese/no-JSON regression assertion.
Validation: the same deadline-bound Runner.validate and independent CLI critics will run from an external controlled driver. No test/gate changes, no clock reset, and this counts as the fifth of six builder attempts. Source will be frozen during validation.
Expected: actual two-model ten-method results, six screenshot package, machine observation equivalence, and two current-source visual critics. No outcome claimed before those commands finish.

## Round 6 — last bounded correction

Problem/evidence: Round5 standard nine methods passed and one failed (two entry assertions); narrow diagnostic eight passed and two failed (entry plus catalog bounds). All three owned device runs so far were deleted, source stayed frozen for the narrow diagnostic.
Edit/hypothesis: replace the failing maximum-text jump with a native large decision sheet; choose only after dismissal, cancel without decision. Crop portrait cells in memory so accessibility bounds match pixels, reserve catalog space, and replace the flat native table with matching painted candidate. No expected-value or visibility assertion is removed.
Validation: first run the two actual narrow-screen regressions, then the unchanged full two-model ten-method runner and two independent image critics. This is the sixth and final builder attempt. No reset of the 14:30:56 UTC deadline.

Round6 focused results: native catalog passed; the first entry attempt still failed even with a sheet. The underlying cause was decorative scene hit testing outside clipped image bounds. Scene-only allowsHitTesting(false) was then applied; SE3 maximum-text case passed including cancel/reopen, both costs, selected reaction, comparison bottom and next day. All focused temporary devices were deleted. Source is now frozen for the complete original two-model validation and independent critics.
