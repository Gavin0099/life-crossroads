# LIFE-LOOP-01 / WORLD-ART-01 共用契約 v1

> 封存：這是採納 PR #9 `c823c82` 之前的原型契約，並非 LIFE-LOOP 10H v1.1。正式工作改以 `docs/life-loop-10h/` 四文件為準。本支只保留可恢復 WIP，不宣稱新版契約、自然續行或動畫相位 Gate 完成。

共同凍結基底：PR #8 `c136bebf48ae17e24235d9da72d7f9e51b90bf0c`，仍是Draft，不表示批准上游合併/發布。Gameplay（主Agent）負責此契約、GameStore/CrossroadsView、時間呈現、原子保存、測試與整合。Visual World只實作 `LifeWorldScene(state: LifeWorldViewState)`，不改核心/主流程。

正式型別在 `LifeCrossroads/Presentation/LifeWorldViewState.swift` 與 `LifePlayback.swift`。版本 `life-world-view-1`。

- `sceneID = river-home`：跨國共用的虛構河畔生活場景，五階段保持同一場景；不是各國實景。
- `age` 是生活片段中的呈現年齡，`targetAge` 是已保存的下一決策年齡；播放不能改引擎年齡或事件。`stageID` 為 childhood/adolescence/youngAdult/middleAge/laterLife。
- `phase` living/event/consequence/ended；`progress` 0...1；`isMotionPaused` 暫停人物/環境動畫；`isEventPaused` 表示等待玩家選擇。日/晚光線只是片段演出，不是國家時區或真實時間。
- `characters` 內的 actor 為 mumu/ahe/teacher/cheng，behavior 為 idle/walking/interacting，expression 為 calm/attentive/resting。相遇取實際事件人物，選後人物取本次真實人際互動；視覺層不可自行加入朋友或推斷協助。
- `visibleChanges` 逐項有 kind/value/title/source。source 保留實際 eventID/choiceID/age；value 為實際故事事實，seeking/none/paused 不畫成已獲支持/完成作品。可畫便條、聯絡卡、作品本、觀察本、分工表等象徵物；不畫獲獎/成功或保證未來。
- `activity` 是最近一筆已執行選擇的日記，value為choiceID，title直接取實際choiceTitle；不代表新增故事旗標。首個8歲事件沒有旗標，仍能留下真實日記；休息同樣留下紀錄。
- Visual元件只讀DTO，不拿catalog、不做抽選、不修改資源/存檔、不呼叫GameStore。沒有自動推進回呼。動畫可插值走動/呼吸/互動，但狀態與物件不得來自UI亂數或AI臨場推理。
- 大型場景應包含原創場景分層、主角待機/移動/互動、實際事實物件及日/晚光線；尊重Reduce Motion與Dynamic Type，不能讓畫面強迫等待。沿用現有原型或程式原創圖形，不整批匯入未核准圖片，不模仿參考品牌的獨特素材。

播放每32個呈現pulse完成一段（正常速度8秒，3倍約2.75秒），可隨時暫停/跳到事件。pulse只改呈現，事件早已由正式Seed與歷史選定；所有操作/背景恢復不得重抽。重開不補算離線時間，從已保存的選擇/回饋停住；動畫進度不存檔。失敗操作不發佈新人生或後果。

此片驗收先看童年至少兩件事件：生活→自動暫停→真實決策→同場景留下物件→返回生活。再驗完整15次人生、跨國比較、原局/分岔、存讀和固定Seed。兩個開發角色保持分離；整合後另做有界獨立Reviewer驗證，不新增第三條長期開發線。
