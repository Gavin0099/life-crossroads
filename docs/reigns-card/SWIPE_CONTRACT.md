# RC-00 滑動契約

基底 PR21 `eb6eff1`，Owner採納Issue23；僅13歲teen-project，完整四ID集合不符就回原介面。左offline，右invest，另外ask/rest直接按鈕；不依排序／國名推選「最好」道路。以`-decision-ui-swipe`或事件右上「決策方式」切換，旗標不寫人生存檔。

狀態：idle → dragging → preview → commitRequested → saved／failed。門檻96pt、只看實際最後位移，不看速度預測；12pt死區，橫向須大於垂直1.2倍。垂直先移動20pt且超過橫向，就把這次手勢判為捲動；不能途中誤變成決策。拖回中心、未達門檻、離開／背景中斷均取消。預覽只顯示正式choiceTitle、applied、unavailableReasons與環境缺值，不顯示尚未保存的結果。

`request`在commitRequested／saved拒絕重複；所有輸入（手勢、可見按鈕、AX action）走同一路徑。最後還由CrossroadsView核對正式事件與choosing，再呼叫原GameStore.choose。只有Store成功保存並發布反映同一choice的新trace才ack saved；失敗保留卡、檔案、原人生，解除故障可重試。View重建不自動提交，成功後舊卡不可再回傳選項。

未保存時卡片只跟隨手指偏移與旋轉，不啟動計時器、亂數或新動畫時鐘；放開取消立即復位。Reduce Motion不位移／旋轉，仍可讀文字預覽與按鈕。保存後由原本WorldPlayback與LifeWorldScene演出，卡片才離場；本片不另加彈簧或離場動畫。背景取消與捲動不消耗人生時間。

可行性反例採現有引擎對時間不足state的正式preview測試，不把合成的低預算當成真實完整人生。原生取證使用真實13-before存檔，JPN/jpn-1/Seed34。四種選擇各自與原選項UI比較保存SHA和冷恢復。既有完整分岔／重播測試保留。所有新專用Simulator使用trap delete；不動其他裝置。
