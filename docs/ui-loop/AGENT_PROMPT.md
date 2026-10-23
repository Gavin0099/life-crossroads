# Bounded Visual Builder — adopted brief

本工作線由使用者2026-10-23授權，執行契約以本檔和LOOP_PLAN為準。`source-kit/`是原始交接資料，不直接取代目前repo事實。

基底：`9bd75d23e6fed6057700fa23a71de31bf3e201d8`，分支 `codex/ui-visual-loop-4h`。不要退回 `1771c57`，也不動任何其他worktree。先讀repo AGENTS、PLAN、project-guardrails、memory active task及 SYSTEM_PROMPT，然後 STYLE_GUIDE、PROGRESS、最近critic和實際WorldGameplay程式。

你是每輪Builder。先修上輪最大缺口，不從頭重做。保留WorldFlow的事件＋選項配對、錯誤／缺資料時不編造、兩路後果／比較／隔天、播放／暫停、成年回憶與重啟。EventFirst target保持原樣。新美術及文字皆是fixture展示，不接正式Domain，不重新計算人生規則。

第一輪優先：壓縮品牌／身份，完整四資源做可展開區，兩個選擇和質性代價在普通iPhone17／SE3第一屏容易比較；大字第一屏仍有事件或決策入口。選後呈現反應，底部導覽不遮內容。場景可依可用高度縮放但保留角色主體。

第二優先：使用root提供的動作素材候選（若已存在且manifest通過像素檢查），兩路有共同工作焦點，紙橋／工具清單有可信工作平面。移除漂浮圖示與重疊名牌。沒有素材則用既有圖層重組，並修正文案中的站／坐／手部描述，不假裝完成新圖。

可寫：UIPrototype/WorldGameplay、WorldGameplayTests、WorldGameplay.xcodeproj、assets/gameplay、assets/prompts、docs/ui-loop。不要改Domain、Data、Package.swift、正式App、治理、其他資料夾或git；不要commit、push、切branch、安裝依賴或使用付費API。Simulator及測試由supervisor執行。不要自己建立模擬器。

每輪最多30分鐘，總截止時間2026-10-23T14:30:56Z不可重設，最多六輪。完成有界變更後更新PROGRESS：Problem/Hypothesis/Edit/可觀察預期/風險/下一輪唯一優先。不能寫測試PASS或美術PASS，除非引用supervisor提供的當輪真實證據；不得改已存在測試結果或critic報告。

實作前說明需要驗證的行為／反例。測試要驗可觀察UI，而不是複製implementation；保留現有可及性ID或同步更新真正行為斷言，勿刪除難通過的驗證。新CTA要有至少44pt可點區，普通字級優先兩選項一起可見；最大字級必須可捲到完整正文與兩項代價。

結束輸出：變更檔案、對應critic issue、待supervisor執行的具體驗證、尚未解決事項。不要自評已通過真人遊戲感。

## 使用者追加 Acting v1.1（優先完成）

讀 CHARACTER_ACTING_SPEC.md 與 tools/ui-loop/README.md 最後的精確 attachment 契約。沿用目前 WorldGameplay，不回舊 EventFirst。將角色演出建成同一 presentation state（expression、pose、prop、實際 asset IDs），同時驅動畫面、可及性摘要及 native preview。四表情 neutral/thinking/hopeful/tired；三姿勢 idle/collaborating/asking。初始 thinking/idle，team hopeful/collaborating，help neutral 或 hopeful/asking。選後可用4表情圖集中的 portrait 加上工作桌整組姿勢；不要用 emoji、只改文字或把同一立繪位置移動當四表情。預覽須使用遊戲相同素材與元件。

root提供 assets/gameplay/va-otter-emotions-v1.png（若生成未完成，讀 manifest 確認，不能偽造）；2×2四表情透明圖集，精確像素 crop 以 manifest 為準。可將原圖複製至 xcassets，UIImage.cgImage.cropping 或 SwiftUI 顯示裁切均可，不改來源像素。portrait在遊戲中要看得清楚，但保留場景主體。三姿勢使用舊idle atlas、friend-v2、teacher-v2。組合圖的動作不必假裝骨架動畫。

識別映射：實際WorldFlow事件ID為workshop-2027，不得改名。proof的event_id=bridge僅是本規格的art presentation alias，payload同時保留source_event_id=workshop-2027（root runner README會核對）。在ACTING_IMPLEMENTATION明列此映射；snapshot workshop-start/team-reaction/help-reaction映射bridge-initial/team/help。兩選項仍team/help。第3次Builder已留下直接ScrollView choice anchor及detail-scroll viewport修正，先讀最新diff，勿重做已完成修正；尚待實測。

已生成並看圖的portrait來源實測1254×1254，四格627×627：neutral(0,0)，thinking(627,0)，hopeful(0,627)，tired(627,627)。動畫統一0.25秒即可，Reduce Motion直接終態。新增ActorEmotion/ActorPose/state與renderer可放現有View同檔以免pbxproj接線遺漏；App用-acting-contact-sheet顯示同renderer原生預覽，iPhone17一張截圖需看全7項。對大字入口使用hittable predicate最多2秒及點後capture(accessibility-decisions)，保留no-extra-swipe斷言。sheet捲動應對sheet ScrollView，不對app背景swipe。

可及性邊界：正常launch角色用中文說明表情／動作，不能讓VoiceOver朗讀JSON技術碼。機讀JSON value可限測試專用-acting-proof launch argument才啟用；同一renderer/state輸出，視覺不變，測試明示啟用。catalog機讀value同樣限測試，不取代正式語意標籤。

新增10項 Gate 中四個指定UI測試：testActingBranchesAreVisuallyDistinct、testReducedMotionPreservesOutcome、testActingContactSheetShowsCatalog、testMissingRouteKeepsInitialActing；保留原六項。Contact sheet以專用launch argument開啟原生預覽，四表情／三姿勢必須都真正渲染，截圖attachment名 acting-contact-sheet。branch test需從實際 actor accessibilityValue 讀 JSON，點選前/兩路之後三次觀察，保存 acting-state-observations.json keepAlways attachment；catalog IDs也從同一rendered catalog讀取，不能在測試寫預設結果充當觀測。Reduce Motion比較實際最終state與普通設定相等；Missing route保留initial表情姿勢，不出現成功演出。新增 ACTING_IMPLEMENTATION.md 說明實際資產、狀態接線、Reduce Motion、限制。

## 上輪實際失敗的精準修正

round2 iPhone17五過一敗；普通首屏兩選擇已通過。最大字前往選擇點擊後 team.isHittable 仍false，勿刪斷言或加額外swipe掩蓋。明確把scrollTo指向第一個choice或獨立anchor，避免nested VStack的world-decisions解析成整個panel；等待穩定後截圖。comparison-end helper錯把底層world-records當sheet底界，實際截圖最後一行與回到生活已可見；改用當前sheet ScrollView/toolbar viewport判定，保留完整最後一行frame驗證。詳細證據可讀external control round-02/schema-and-accessibility-review.md。

已備妥的兩路動作圖：`assets/gameplay/va-friend-worktable-v2.png`、`assets/gameplay/va-teacher-worktable-v2.png`，1536×1024原生透明圖。manifest已有prompt/input/output hashes與只讀alpha檢查。請複製至各自xcassets image set並在選後反應使用：合作兩人扶紙橋；求助三人整理待借用清單，尚未取得工具。這是整組含工作桌的合成前景；不要再疊加舊立繪、漂浮紙橋或名牌。保留完整耳朵、手與共同焦點，搭配既有背景。初始選擇前仍用既有角色，不能預先顯示已完成其中一路的動作。舊v1保留追溯但不使用。
