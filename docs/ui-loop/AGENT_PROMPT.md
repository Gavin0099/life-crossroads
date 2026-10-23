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

已備妥的兩路動作圖：`assets/gameplay/va-friend-worktable-v2.png`、`assets/gameplay/va-teacher-worktable-v2.png`，1536×1024原生透明圖。manifest已有prompt/input/output hashes與只讀alpha檢查。請複製至各自xcassets image set並在選後反應使用：合作兩人扶紙橋；求助三人整理待借用清單，尚未取得工具。這是整組含工作桌的合成前景；不要再疊加舊立繪、漂浮紙橋或名牌。保留完整耳朵、手與共同焦點，搭配既有背景。初始選擇前仍用既有角色，不能預先顯示已完成其中一路的動作。舊v1保留追溯但不使用。
