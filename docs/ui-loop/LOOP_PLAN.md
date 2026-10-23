# Visual Agent Loop — 四小時有界執行

來源：使用者的4h套件與本輪直接要求；原包以唯讀參考留在source-kit。原腳本的舊基底、弱版本Gate、程序／Simulator清理缺口先修正，使用已驗證GS checkpoint續做。

- 基底：`9bd75d23e6fed6057700fa23a71de31bf3e201d8`；獨立managed worktree，branch `codex/ui-visual-loop-4h`。
- 時窗：2026-10-23 10:30:56–14:30:56 UTC（台北18:30:56–22:30:56），最多4小時，含前置與收尾，不要求耗滿。
- 最多6輪Builder；每輪最多30分鐘、Critic最多12分鐘，至少兩輪獨立視覺審查；末段保留10分鐘收斂。時間到即停止，不能重設deadline續跑。
- 唯一產品範圍：13歲紙橋事件的主畫面、找朋友／找老師兩路後果、窄螢幕與大字。保留既有延伸流程但不量產全齡美術。

## 執行與判定

VA-01：已讀現有圖與實際UI，保存舊版和GS基線；鎖定STYLE_GUIDE及Critic-00三項缺口。
VA-02／03：Builder依最大缺口改UI與必要候選素材，Simulator測試由supervisor在固定命令下執行，每run精確記錄新UDID並刪除。
VA-04：保留兩機型原始xcresult summary、實際PNG及hash；獨立只讀Critic真的開圖，綁定當時source及PNG，不以舊PASS批准新版本。
VA-05：最後六張PNG（含原生acting contact sheet）、Before/After、style/progress/review、驗證收據；root以canonical memory writer留記錄。僅Gate通過且範圍／版本／工作樹檢查通過時推送新分支；不合併或發布。

## Gate

- build／既有Swift與WorldGameplay UI測試真實通過；iPhone17及SE3各至少10項，保留原六項加四個acting測試，每份summary保留原文，含正確scheme及完整必要測試。未跑標NOT_RUN，失敗標FAIL。
- 四表情／三姿勢用真正素材及遊戲共用元件展示；初始、合作、求助有不同表情／動作／物件，Reduce Motion仍得到相同狀態。原生contact sheet、兩裝置真XCTest觀測、schema1.1 acting-state-proof及ACTING_IMPLEMENTATION必備。
- 初始普通字級能看見兩個完整選項與質性代價；大字可見決策入口並能捲到所有文字，固定操作區不遮可點內容。
- 兩條路線有清楚且與敘事一致的動作／物件差異，沒有漂浮道具、名牌遮擋、多手多尾或AI文字。
- 最終獨立Critic的P0與P1均為0，至少兩輪真實看圖，最後一次source／PNG hash與交付一致；主觀偏好及人工門檻另列。
- 資產來源／prompt／版本／透明度可查，approved_for_app維持false；不得默默切付費API。
- 禁改Domain/Data/Package/正式App，禁止merge／release。連續兩次相同P0或沒有可驗證改善，停止重複生成並交付PARTIAL。
- 所有timeout、error、中斷路徑終止本次程序群，清除本次ledger中精確Simulator ID；不能把其他工作線裝置納入清理。

## 必交付

STYLE_GUIDE.md、PROGRESS.md、FINAL_REVIEW.md、CHARACTER_ACTING_SPEC.md、ACTING_IMPLEMENTATION.md；artifacts/ui-loop/final的01-home.png、02-friend-outcome.png、03-teacher-outcome.png、04-narrow.png、05-large-type.png、06-acting-contact-sheet.png；verification.json引用build、兩份UI原始summary、Swift log、最新獨立critic、acting-state-proof與asset-provenance。未通過不偽造空圖或PASS。

12:41 UTC使用者追加Acting v1.1，停止第三次Builder並保留未完成狀態與已耗輪次；同一截止時間與最多六次不重設。source-kit-acting-v1.1保留原包；採納上列新Gate，不採用原包過時的1771c57／EventFirst基底。

四小時是上限；五秒理解、10～15歲真人遊戲感、實機及手動VoiceOver、人工美術方向與商用素材審核仍獨立待驗。
