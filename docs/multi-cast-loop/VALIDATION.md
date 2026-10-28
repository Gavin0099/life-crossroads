# MULTI-CAST-LOOP 驗收與限制

Issue #18；精確基底 PR17 `30d60007ca43431a740c093f17c75a5e75dc0fb6`。主分支 `codex/multi-cast-loop`，獨立 Draft／HOLD，不合併、不發布。範圍是讓既有故事人物在實際事件中互動，不增加事件、國家資料或人生規則。

## 交付與判定

| 項目 | 判定 | 證據／限制 |
|---|---|---|
| 完整角色盤點 | ACCEPT | CAST_MATRIX找回四正式人物、貓狗五階段候選及不同身份的早期野兔 |
| 阿禾童年／成年／晚年 | ACCEPT（機制及原生整合） | 10歲friend、32歲植物紀錄、72歲有前史風車路線均有真實存檔；沒有維繫友情則呈現小澄 |
| 老師／小澄真實互動 | ACCEPT（機制及原生整合） | 13求助／紙本、17遠端／共作、25teacher合作、32cheng求助／短時工作均依actor／trace投影 |
| 未出現、邀請、未確認求助、休息 | ACCEPT（自動測試） | inviter、recipient、interacted、participant分開；unknown／candidate人物不進正式casting；沒有角色證據就不畫同伴 |
| 保存失敗不提前演出 | ACCEPT（兩尺寸各1/1） | 原本30UI範圍保留，本輪另測10歲朋友選項保存失敗、原checksum／邀請不變及重試成功 |
| 遮字活動與人物辨識 | PARTIAL | 三輪獨立報告保留；對視、提問、遠端老師、工作桌與休息改善，但不能從靜態畫面單獨推論多年友情歷史 |
| 五階段外觀與角色一致性 | PARTIAL | 主角原五階段保留、新增童年／成年／晚年姿勢；部分青少年／青年輪廓仍模糊，小澄無已知出生年；未宣稱所有活動皆有五齡動畫 |
| 貓狗五階段透明素材及SwiftUI Preview | ACCEPT（候選資產） | 兩套各五階段，僅Debug Preview；無正式人物ID或事件來源。細部耳側／缺口一致性PARTIAL，未核准正式使用 |
| Seed、完整重播、原人生／分岔與存讀 | ACCEPT（工程） | 完整152 Swift保留原145範圍、新增7 casting／反例測試；17保存見證重播、存讀與再存bytes一致 |
| PNG來源／SHA／裁切透明度 | ACCEPT（工程） | 44 Python含原41範圍與3新增實際PNG解碼測試；六圖集明確sourceRects、不切耳尾、原圖bytes不改 |
| 大字、Reduced Motion、VoiceOver語意 | PARTIAL | 兩尺寸一般／最大字級／App減少動態的原生場景與可行控制；標籤由真實casting生成。沒有人工VoiceOver焦點／完整實機驗收 |
| 原30項UI回歸 | 保留並核對遠端結果 | 原UI檔與CI分片均無修改；最新HEAD遠端結果見本PR Checks與結案摘要，不能用capture替代 |
| Basic治理 | FAIL（既有） | session_envelope入冊91日超過90日；5項基本檢查PASS，不關Gate、不更改框架、不宣稱CI全綠 |
| 真人娛樂與啟發／正式美術／發布 | HOLD | 尚無10～15歲試玩、主動重玩、生活因果理解與正式選稿證據；不推算90–95%完成度 |

## 可重跑驗證

```sh
swift test -c release
python3 -m unittest discover -s Tests -p 'test_*.py'
source .venv/bin/activate
bash scripts/governance-check.sh --profile basic
python3 tools/multi-cast-loop/make-fixtures.py
bash tools/multi-cast-loop/capture.sh new-label iPhone-SE-3rd-generation normal,large,reduced
bash tools/multi-cast-loop/capture.sh new-label iPhone-17 normal,large,reduced
python3 tools/multi-cast-loop/verify-evidence.py new-label
```

拍攝必須使用新label，避免蓋掉原證據；每次專用Simulator均由EXIT／INT／TERM trap shutdown後delete，不刪其他裝置或runtime。`VISUAL_LOOP_CAPTURE`僅編入測試版，正式App沒有fixture入口。每份save先經正式catalog-backed replay驗證，沒有強制事件或改造trace。

原始測試來源及摘要：[local-tests.json](../../artifacts/evidence/multi-cast-loop/validation/local-tests.json)。原生來源、PNG SHA、checksum、控制可達性與裝置刪除核對：[verification.json](../../artifacts/evidence/multi-cast-loop/verification.json)。失敗與修正：[CRITIC](CRITIC.md)。八組實際比較：[BEFORE_AFTER](BEFORE_AFTER.md)。工程獨立審查原P2及結案：[ENGINEERING_REVIEW](ENGINEERING_REVIEW.md)。

## 與產品目標比對

本輪改善的是「同伴真正參與、選擇後人物做不同的事」：求助保留等待回應的姿態，共作呈現桌面行動，晚年根據真實友誼前史顯示不同人物。原有環境、選擇與後果引擎完全保留。

它沒有增加國家處境差異或新的長期故事，因此不能用這輪美術成果補稱八國統計完整，也不能證明孩子覺得好玩。角色細部一致性、部分年齡辨識與真正的肢體動畫仍有缺口；新增的是可選真實姿勢與角色圖層，不是完整骨架動畫。

下一步是Owner檢視Draft與原生對照，再使用既有LL-09試玩表記錄年齡組、完成時間、主動重玩及能否說出選擇／環境各一個作用。這些人類驗收不由AI Critic或CI代答。


最終本機凍結驗證：152 Swift、44 Python通過；第三輪兩機各31狀態，共62狀態的來源SHA、存檔checksum、控制可達性與runtime warning檢查通過；保存失敗／重試兩機各1/1通過。全部11台本輪專用Simulator已delete，沒有刪使用者原裝置或runtime。原30 UI等待本PR最新HEAD遠端結果，與這些定向capture分開計數。
