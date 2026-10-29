# RC-FULLSCREEN-01 原生畫面

原版來源：PR24 `225c2828f4ea56c8ae5eb89a414ac506808b6374`。新版來源及每張 PNG 的 SHA 見 `artifacts/evidence/reigns-fullscreen/final/*/source.json`、`screenshots.json`；四條路徑均從正式 `13-before.json`（日本、家庭一、Seed34）實際選擇並保存。不是 mockup。

## 一般字級：同一事件的選前／選後

| 畫面 | 原版 SE3 | 新版 SE3 | 新版 iPhone17 |
|---|---|---|---|
| 尚未決定 | [原表單](../../artifacts/evidence/reigns-card/details-corrected/iPhone-SE-3rd-generation/light/rc-first-screen.png) | [單卡](../../artifacts/evidence/reigns-fullscreen/final/iPhone-SE-3rd-generation/light/rc-first-screen.png) | [單卡](../../artifacts/evidence/reigns-fullscreen/final/iPhone-17/light/rc-first-screen.png) |
| 紙本 | [原回饋](../../artifacts/evidence/reigns-fullscreen/final/iPhone-SE-3rd-generation/light/rc-original-offline-saved.png) | [紙本練習](../../artifacts/evidence/reigns-fullscreen/final/iPhone-SE-3rd-generation/light/rc-card-offline-saved.png) | [紙本練習](../../artifacts/evidence/reigns-fullscreen/final/iPhone-17/light/rc-card-offline-saved.png) |
| 線上 | [原回饋](../../artifacts/evidence/reigns-fullscreen/final/iPhone-SE-3rd-generation/light/rc-original-invest-saved.png) | [線上圖解](../../artifacts/evidence/reigns-fullscreen/final/iPhone-SE-3rd-generation/light/rc-card-invest-saved.png) | [線上圖解](../../artifacts/evidence/reigns-fullscreen/final/iPhone-17/light/rc-card-invest-saved.png) |
| 求助 | [原回饋](../../artifacts/evidence/reigns-fullscreen/final/iPhone-SE-3rd-generation/light/rc-original-ask-saved.png) | [表達需要](../../artifacts/evidence/reigns-fullscreen/final/iPhone-SE-3rd-generation/light/rc-card-ask-saved.png) | [表達需要](../../artifacts/evidence/reigns-fullscreen/final/iPhone-17/light/rc-card-ask-saved.png) |
| 休息 | [原回饋](../../artifacts/evidence/reigns-fullscreen/final/iPhone-SE-3rd-generation/light/rc-original-rest-saved.png) | [保留時間](../../artifacts/evidence/reigns-fullscreen/final/iPhone-SE-3rd-generation/light/rc-card-rest-saved.png) | [保留時間](../../artifacts/evidence/reigns-fullscreen/final/iPhone-17/light/rc-card-rest-saved.png) |

表格中「原回饋」是新版來源內明確切回原介面，同 fixture、同 choice 重新執行所得；不是拿不同人生當 Before。舊版正式原生記錄亦保留在 `artifacts/evidence/reigns-card/round2`。所有原始圖片未裁改，`rc-scene-*` 是 XCTest 直接取得原生元件像素的獨立附件，僅用於盲辨活動。

## 真實預覽、失敗與大字版

- 拖動期間：`final/*/light/rc-preview-hold-left.png`、`rc-preview-hold-right.png`，由實際 XCTest 手勢持續按住時 `simctl io screenshot` 拍攝；沒有注入假的預覽狀態。預覽只換意圖文字，角色尚未演出保存後的行動。
- 寫入失敗：`rc-save-failed.png`，重試後：`rc-retry-saved.png`。原檔 checksum 的斷言記錄於原生測試。
- 最大字級／深色／提高對比／Reduce Motion：`final/*/accessible/rc-first-screen.png`、`rc-all-actions.png`、`rc-rest-saved.png`。完整按鈕可捲動，正常字級的卡片比例不套用到此模式。
- 一般遊玩（移除 capture 自動暫停）：`rc-normal-outcome-held.png`、`rc-normal-branch-outcome-held.png`，等超過原有2秒自動續行區間後仍保留結果；按繼續才前進。

## 保留的失敗與修正

1. `layout1`：build成功，取證工具遇到同 derived 目錄兩份 xctestrun，在啟動UI測試前失敗。刪除本任務 generic build 的重複產品後重跑；Simulator刪除。
2. `layout2`：sheet 與背景有相同 action ID，測試誤選背景按鈕。修正為從 `swipeActionsSheet` 查詢；未更改選擇可行性。
3. `round1`：紙本桌面遮住老師，獨立盲辨判 FAIL。改為分別縮放人物／桌面、保留相同比例與共同地面，讓老師的臉在桌側可見。原失敗圖保留。
4. `round1/round2` 大字版：固定整卡280pt造成 prompt／操作提示截斷。改為文字自然換行、圖像獨立高度、完整按鈕；不能把按鈕可達誤稱閱讀品質通過。
5. 正常分岔入口不經 swipe submit，可能自動離開結果。統一在既有 presentation task 進入結果時暫停，並新增非capture的直接選擇及分岔入口回歸。

最終是否符合 Owner 的遊戲體驗仍待看圖與實玩；Agent 的有限視覺審查不取代 Owner ACCEPT。
