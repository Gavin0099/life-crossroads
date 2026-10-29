# Reigns+：13歲可玩PoC

Owner明確指示「先做這個」，本輪只RC-00～02。以PR21 `eb6eff1be21e809e82f61806d53a1ef404910c3e`開始獨立`codex/reigns-card-poc`，Draft base為`codex/final-polish-loop`。

- RC-00：凍結同一存檔、原生基準及四選項；先寫正反測試。[操作契約](SWIPE_CONTRACT.md)。
- RC-01：中央單卡左紙本／右線上，求助、休息可見；四項按鈕替代、原UI回退；首屏小螢幕可找到操作。
- RC-02：保存後才回原本真實人物／道具反應；保存失敗可重試；無重複提交、背景誤觸、未保存成功演出。

保護Domain/Data/Persistence/GameStore/WorldPlayback與既有測試。新增純Presentation手勢狀態不進存檔。正常/大字/深色/ReduceMotion的最小可操作性屬本PoC回歸，不代表完成RC-04整套審查。不得以工程測試宣稱90–95%或兒少娛樂性。

RC-03多事件3～7選項、RC-04完整品質、RC-05真人比較與RC-06全人生均待Owner後續決策。完成PoC後停止，待Owner review；維持HOLD，不合併發布、這輪不安裝手機。

## 採用的互動參考

[Apple Gestures HIG](https://developer.apple.com/design/human-interface-guidelines/gestures)：保持直接操作回饋、可發現的手勢與替代輸入；採用既有SwiftUI Pro的Button/Dynamic Type/Reduce Motion原則。Reigns只作操作方向參考，沒有拷貝程式、敘事或圖片，也未加第三方套件。Apple文件透過官方Markdown核對；Devolver官方頁本次回403，沒有把未讀內容當證據。
