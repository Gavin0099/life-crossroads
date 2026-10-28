# MULTI-CAST-LOOP 原生 Before／After

Before是PR17相同引擎的真實存檔畫面，After會指向本輪凍結的第三輪原生畫面。所有圖均來自正式SwiftUI App與實際SaveRepository檔案；scene圖是XCTest原生element screenshot，沒有合成mockup、移動人物或修補截圖像素。

基底為 `30d60007ca43431a740c093f17c75a5e75dc0fb6`。完整畫面、場景裁切、來源SHA與保存checksum均在 `artifacts/evidence/multi-cast-loop`。共用場景是虛構舞台，不能從家具／物種推論國家事實。下表以SE3確保小螢幕可比較，標準機的相應圖在各輪 `iPhone-17` 目錄。

| 組 | 真實保存狀態 | Before | After（第三輪） | 實際改變 |
|---|---|---|---|---|
| 1 | 10歲友情 invest | [原生](../../artifacts/evidence/multi-cast-loop/baseline/iPhone-SE-3rd-generation/10-friend-normal-screen.png) | [原生](../../artifacts/evidence/multi-cast-loop/round3/iPhone-SE-3rd-generation/10-friend-normal-screen.png) | 童年沐沐與阿禾面對面交談；不是預演晚年重逢 |
| 2 | 13歲提出需要 ask | [原生](../../artifacts/evidence/multi-cast-loop/baseline/iPhone-SE-3rd-generation/13-ask-normal-screen.png) | [原生](../../artifacts/evidence/multi-cast-loop/round3/iPhone-SE-3rd-generation/13-ask-normal-screen.png) | 攤掌說出需要與老師聆聽；未畫成已接受協助 |
| 3 | 13歲紙本練習 offline | [原生](../../artifacts/evidence/multi-cast-loop/baseline/iPhone-SE-3rd-generation/13-paper-normal-screen.png) | [原生](../../artifacts/evidence/multi-cast-loop/round3/iPhone-SE-3rd-generation/13-paper-normal-screen.png) | 原本單人作畫加入本次真實老師互動與紙本講解 |
| 4 | 17歲遠距／共作 | [遠距](../../artifacts/evidence/multi-cast-loop/baseline/iPhone-SE-3rd-generation/17-remote-normal-screen.png)／[共作](../../artifacts/evidence/multi-cast-loop/baseline/iPhone-SE-3rd-generation/17-collective-normal-screen.png) | [遠距](../../artifacts/evidence/multi-cast-loop/round3/iPhone-SE-3rd-generation/17-remote-normal-screen.png)／[共作](../../artifacts/evidence/multi-cast-loop/round3/iPhone-SE-3rd-generation/17-collective-normal-screen.png) | 螢幕裡的樹老師與面對面工作桌分開；沒有因人名相同而畫相同活動 |
| 5 | 25歲在地共作 cooperate | [原生](../../artifacts/evidence/multi-cast-loop/baseline/iPhone-SE-3rd-generation/25-collective-normal-screen.png) | [原生](../../artifacts/evidence/multi-cast-loop/round3/iPhone-SE-3rd-generation/25-collective-normal-screen.png) | 依真正teacher關係紀錄共作，不擅自替換成小澄 |
| 6 | 32歲求助／短時參與 | [求助](../../artifacts/evidence/multi-cast-loop/baseline/iPhone-SE-3rd-generation/32-ask-normal-screen.png)／[參與](../../artifacts/evidence/multi-cast-loop/baseline/iPhone-SE-3rd-generation/32-participating-normal-screen.png) | [求助](../../artifacts/evidence/multi-cast-loop/round3/iPhone-SE-3rd-generation/32-ask-normal-screen.png)／[參與](../../artifacts/evidence/multi-cast-loop/round3/iPhone-SE-3rd-generation/32-participating-normal-screen.png) | 說出需要與已做一小段工作使用不同姿勢、工具與人物安排 |
| 7 | 72歲阿禾風車重聚 | [原生](../../artifacts/evidence/multi-cast-loop/baseline/iPhone-SE-3rd-generation/72-ahe-normal-screen.png) | [原生](../../artifacts/evidence/multi-cast-loop/round3/iPhone-SE-3rd-generation/72-ahe-normal-screen.png) | 從單人畫面改為兩位年老角色，實際延續童年友誼 |
| 8 | 72歲小澄社區新連結 | [原生](../../artifacts/evidence/multi-cast-loop/baseline/iPhone-SE-3rd-generation/72-neighbor-normal-screen.png) | [原生](../../artifacts/evidence/multi-cast-loop/round3/iPhone-SE-3rd-generation/72-neighbor-normal-screen.png) | 沒有維持聯絡時呈現小澄；不冒充阿禾重逢 |

另外，32歲與阿禾記錄植物是新補見證：第一輪仍走舊通用站姿／文字標牌，第二輪開始改為成年角色與觀察紀錄。它的Before取自第一輪，**不能冒稱PR17獨立基準截圖**。

每輪失敗及Critic原判保留在[CRITIC](CRITIC.md)。身分辨識、活動辨識、精確年齡及真人理解是不同驗收，不以圖數或盲評比例當作遊戲完成百分比。
