# LL-07／LL-08 有界改進交接

> 最新：本地已完成。App D518（ce9只改讀取測試，App tree相同），標準機4/4；SE的D518三個場景／首屏／存檔案例通過＋ce9閱讀補測1/1通過，分批不冒充單次4/4。17台專用裝置delete且inventory查無，自己的QA checkout已封存。維持Draft/HOLD，待新PR遠端CI與產品驗收。以下進度按時間保留，舊失敗／中止不冒充新版全套；最終資料在LL07_DELIVERY.md與artifacts/evidence/ll07/validation.json。推送／遠端CI另核對。

基底固定為 PR #10 `b896e058bf49f61ec8eafec2a4134a35edff6ddc`。這是該輪審查後的有界改進，不重開10小時計畫；PR #10維持Draft/HOLD，不合併、不發布。

## Ownership

- Gameplay A：`CrossroadsView.swift`、`GameStore.swift`、UITests、正式整合與測試清理。分支 `codex/ll07-world-continuity`。
- 既有 Visual B：`LifeWorldScene.swift`及獨立視覺元件；先核對8／13／17歲的實際trace→人物／道具／線索來源。可在其乾淨b896基底分支提供窄patch，A不改Scene檔、不整枝合併B歷史、不另外開Visual Agent。
- `LifeWorldMotion.swift`與純Swift `LifeWorldFrame`／`WorldPlayback`暫凍結；B若需新DTO先以交接文件列明來源及缺口，不自行改引擎或造故事。
- Domain／Data／Persistence／事件與版本不改；不新增角色PNG、骨架或大量圖片。

## 本輪驗收

1. 同一世界固定在事件／結果上方，決策以可捲動抽屜浮在場景下緣；不再由300pt縮到88pt。一般SE場景至少200pt、大字至少150pt，轉換phase時同字級場景高度不變；一般字級首屏至少一個真正可用行動可點，捲抽屜不移走場景。
2. 最大字級的固定播放列只一列觸控高度，次要設定收選單；閱讀區仍可捲至全部選擇、後果與原因。
3. 警告先保留基準：原PR10三筆皆出現在存檔失敗提示案例，包含legacy。定位真正發布堆疊，再驗證三個受影響案例的runtime issues；不能藉關閉診斷／忽略warning宣稱已修。
4. 保持保存失敗原畫面／原檔、成功重試、原局與完整替代線、Seed與存讀一致。至少定向SE及標準機；專用Simulator結束即delete，保留證據。
5. LL-08只使用已提交的8／13／17歲事實。待發生線索與已觸發呼應分開，休息不額外產生幫手；場景新增的物件須標註其trace來源。

LL-09只準備真人試玩操作與記錄方式；沒有真人參與就維持未驗收，不用AI或CI捏造趣味、理解或重玩結果。先完成本地可審查成果；GitHub交付及最終CI另記，不提前宣稱成功。

## 警告根因與窄修正

baseline真實UI1/1但1筆warning。暫時探針抓到先ButtonAction清除非nil，再UIKitDialogBridge.dismiss／reset→Binding.wrappedValue於ViewGraph.updateOutputs把已nil的@Published再次設nil。bbe8657只增加dismissError的nil guard，未改佈局或測試；原三個保存故障案例3/3、runtimeWarnings=[]，兩台專用裝置已delete。探針已移除，不入正式App。下一步由A接固定場景／單列controls並驗真正可見區，不要求B改時鐘或DTO。

## 佈局與Scene驗證分工更新

A的初輪2項原生為1過1失敗：最大字級操作通過；事件→結果的AX高度差1.5pt未過嚴格1pt門檻。固定控制列44pt內容＋8pt邊距，次要速度在大字選單，並移除大字重複說明遮圖後，3項定向重跑中（非正式全套）。B的8／13／17 Scene窄patch仍由B擁有；A會在其來源hash／patch就緒後才跑最終完整回歸，不把初輪layout圖當B最終素材證據。B不需Simulator；14張離線來源對照另標性質，不能當正式App雙機驗收。

## 最後Scene匯入與正式驗證準備

A已窄接B的129ca19 Scene，SHA256 ced164aefaa15ec5fd93c49024dd4124209cc1e8cf261442a9c95dce4af313cb，並保存LL08 handoff／14組離線證據及工具。DTO、Motion、Domain／Data／Persistence／素材保持b896。8歲只顯示當次實際後果，沒有跨年持久StoryFact，不新增或假造。

A的固定世界新增可讀範圍／單列52pt控制列。僅固定footer沒有消除AX 1.5pt差，後續以iOS17既有contentShape(.accessibility, Rectangle())限定語意邊界，保留原1pt驗收門檻；初／後均240pt且位置一致，1項真實捲動／保存後果案例已過。嘗試UIKit命名accessibilityFrame的SwiftUI編譯失敗已保留，該裝置亦delete；沒有採用private API或UIKit橋接。

目前不再擴充Scene；正式兩機回歸將使用匯入後同一freeze。B後續僅讀正式原生圖／source自查，不啟新Simulator或改renderer，待A產生manifest後再給作者目視。

## 正式原生來源與作者自查入口

最終App／UITests來源凍結 **66845e13b633b65e39356f12a07cb4e0fd2cf8f4**，Scene仍ced164...，沒有新改DTO／Motion。純Swift111、Python30及basic已過。A啟動SE3完整20項，iPhone17跑全部9項world案例（包含新8／13四選項、17呼應、最大字級、恢復、故障／重試、完整分岔）。這兩組數字分開，不冒充標準機20項全套。復用自己已封存的r2工作目錄做標準機，與既有B工作樹不同。

raw進度：主工作目錄 artifacts/governance/ll07/se-full.txt 與 standard-world.txt。完成後原生summary、逐圖manifest與PNG預定寫入 artifacts/evidence/ll07/native/se/ 和 standard/；未生成前不是驗收結果。B僅做最後圖像／來源只讀自查，不再開模擬器、改Scene或生圖。正式兩機由A統一delete後留下收據，無需跨chat回覆。

標準機覆蓋補充：本輪也改了共用首頁／提示接線，A會在既有9個world案例完成後，以同一66845e1來源接跑其餘11個legacy案例。採分批9＋11，不重算成一次20項執行，不重跑已通過的world案例。最終報告會列每批summary／runtime issues與獨立裝置清理；這是補齊受影響共用介面的覆蓋，不新增玩法或美術迭代。

## 66845e1批次結果與安全區修正（不當最終PASS）

標準機9項為7過2失敗，runtimeWarnings=[]；兩項均量得控制列AX範圍86pt（52pt內容/邊距＋34pt系統安全區），Scene固定位置斷言已通過。A已保留summary與原生附件，沒有放寬64pt門檻或移除home-indicator安全間隔。只修Root控制列背景的safe-area延伸／accessibility形狀，不改B Scene。

66845e1的SE完整批次尚未完成，A核對PID7444／owned AAA9C77F及argv後主動INT，避免新版修正前繼續跑過時來源；xcodebuild exit75，wrapper已delete。該中止不算產品20項完成；原log／訊號紀錄保留。標準機711CAA亦已delete。先跑標準機單項固定世界/控制列真實驗證，通過後以新的同一source重跑兩機完整20，取消分批9＋11安排；不改圖或重新開十小時計畫。

### 最後正式凍結：5ab3c977ff035f6772edf0093e8f3325fe069939

標準機單項真實捲動/結果/控制列測試28.541秒通過；初／後場景298.667pt、頁尾52pt，0項此發布warning，專用32A8D536已delete。修正只限制背景的safe-area延伸與AX shape，系統34pt安全間隔保留。

A現在以**5ab3c97同來源兩機各完整20項**執行；raw改為 artifacts/governance/ll07/se-full-final.txt／standard-full-final.txt。Scene仍ced164...，畫面來源與native輸出預定路徑不變。先前668批次7/9與中止維持歷史，不冒充最新全套。B請不再改Scene，待兩機新manifest產生再作最後只讀自查。

### SE新增道具案例失敗保留

5ab完整SE批次的新增8／13道具案例在第一個8歲choice.ask失敗；原log顯示固定0.6 viewport拖曳在上下方向反覆，已附unrevealed-choice.ask。標準機同案例通過。A先等正式bundle完成檢視原圖，再決定是否只修helper的可視區中央短距離／停止慣性；不放寬isHittable／中點門檻、不增加無限重試、不改B Scene。5ab批次仍照實保留，不記為雙機全過。B的b4d8780計數澄清已窄取comparison／index／handoff，圖與來源hash不變。

### iPhone17正式原生圖已就緒

5ab3c97標準機完整20/20、runtimeWarnings=[]，owned F27219E0已delete。原始bundle複製主工作目錄artifacts/ios/LL07-standard-5ab3c97.xcresult；16張原生圖及逐圖來源／SHA／test manifest位於artifacts/evidence/ll07/native/standard/。B可只讀檢視此gallery；SE仍有原道具案例的捲動手勢失敗待bundle完成後定位，不把標準機過關當SE過關。App及Scene仍未改。

### 全文可達性補修與來源更新：3aa85b56f5a02ba8a1fe99aa515c918c6f0013fb

B起初誤判新摘要沒有全文入口、A未看完下方即採納；隨後獨立Reviewer核對5ab約499行已存在『完整故事與問題』DisclosureGroup，撤回零入口P1判斷並保留更正。實際是全文入口在選項下方的P2導覽問題。A保留已做好的有界便利入口，在事件標題旁加『閱讀全文』，原生sheet逐段呈現完整storyText與storyQuestion，加入worldSuspended；開關不寫存檔，不縮Scene。新案例用8／13歲兩段審閱過的末段／問題literal，在normal與最大字級讀到底、關閉後比對存檔／事件／場景。不是以摘要取代全文。

5ab SE全套實際18/20，失敗為choice.ask與whyResult的固定捲動來回；summary／原圖見artifacts/evidence/ll07/history/。A只改UI測試helper：按目標/viewport實際frame朝中央短拖、slow且停0.2再放手，保留32上限、isHittable與中點門檻；不改Scene、事件或可行性。已刪5ab專用250CEEEE裝置。

3aa同來源兩機現在各跑6個受影響world案例：四選項真實道具、normal/AX全文、不變Scene、大字、冷恢復/提示取消、保存故障與重試。這是定向6，不冒充兩機全21；原標準5ab完整20與SE18/20另列。raw為se-followup.txt與standard-followup.txt，成功後新圖預定native/se/和native/standard-followup/，原standard/仍為5ab完整20來源。A再次暫時恢復自己的已封存QA checkout做並行，不是B工作目錄；完成後保留raw再封存。

更正界線：5ab全文從未被刪除，新readFullEvent不是修補遺失內容。A已向使用者更正；這次保留是降低找到全文的成本及增加normal/AX可讀回歸，不以錯誤P1描述舊版或要求再跑大範圍全套。

### 27c5084測試邊界修正；App仍與3aa相同

3aa SE定向6實際1過5敗，屬修helper過程，未當完成；標準機3aa仍執行。frame記錄顯示helper以worldPause按鈕而非整列背景估邊界，允許中點落在頁尾背景上，tap不能作用；A改讀worldPlaybackControls整列frame並留8pt內縮，保留所有原斷言及32上限，輸出target/visible/controls供核對。27c5084只改UITests，App tree與3aa一致；現重跑SE同6，raw為se-final-targeted.txt。Scene仍不改，不再開新視覺線。

已保存5ab iPhone17的獨立16圖覆核native/standard-5ab-independent-review.json；P0/P1=0、三P2，明示5ab已有全文DisclosureGroup。它不是3aa/27c的最終兩機覆核。待新se/與standard-followup/產生，可由同一Reviewer作增量只讀覆核，不開Simulator或改renderer。

### 3aa標準機新圖已就緒；SE道具已回歸

標準機3aa六項定向6/6、runtimeWarnings=[]，B40A562D已delete；15張新增/更新原生圖與summary/逐圖SHA manifest在artifacts/evidence/ll07/native/standard-followup/，含一般/最大字級的8與13歲全文末段及問題。App tree與27c完全同為f61e36003c7ddc44dfe2ff905809a5a77ac12827，差異僅測試helper正確footer邊界；完整橋接在source-boundary.json。原5ab standard/仍是其自己的20項歷史，不混標。

SE27c四選項真實道具案例197.290秒已過，正繼續其餘5項，完成後native/se/再就緒。B與同一Reviewer可先只讀standard-followup/增量核對全文入口、頁尾/Scene遮擋與來源，等SE新圖再補SE，不開Simulator、不改Scene；先前全文P1誤判已撤回。

### 最終雙機定向完成；SE圖已就緒

SE27c六項6/6、runtimeWarnings=[]，0ACDEC92已delete。15張原生PNG／summary／逐圖manifest已在artifacts/evidence/ll07/native/se/；標準機3aa15張在standard-followup/，App tree相同的橋接見source-boundary.json。所有原批次、失敗、中止與最終成功分開記錄validation.json；不是聲稱兩機最新21項全套。14台本輪root專用Simulator均delete且inventory查無，runtime/他任裝置未動。自己的QA checkout raw已全保留，再次封存；B工作樹不動。

既有B／同一Reviewer請對standard-followup及se的最終圖增量只讀覆核，特別是全文入口、最大字級、Scene/頁尾遮擋及不造幫手/因果；不新開Simulator或改renderer。可把有界native覆核JSON留在原B證據分支或/tmp供A納入，不需跨chat回覆。A本地工程已完成，下一步只整理證據、記憶及獨立Draft交付，不再擴充美術或App功能。

### 目視P1與有界回歸：d518c3bf1d0e9fb14d59906a0b7359a6324354a4

30張3aa/27c原生圖的獨立覆核PARTIAL：SE13歲線上／紙本／求助的左上說明badge碰頭頂／上耳輪廓，眼嘴雖可見仍列P1。A已採納，以57178c5將非各國實景文字改在圖片外上方一行；Scene、角色尺寸、PNG／Motion與引擎都不改。最大字級原本已有Scene spoken label，因此不加入重複說明行。原30圖與報告原地保留，不覆寫；綜合報告native/followup-review-before-caption.json。

另P2：舊13歲AX全文截圖只證明問題node可達及完整label，末行未拍全，不能叫同張完整全文。d518只加UI證據檢查：問題maxY捲進sheet可視底邊再截圖，不縮字、不改文案。相同來源雙機各4項：四選項8/13真實道具、normal/AX全文末行、固定Scene/首屏行動、保存故障/重試。新圖預定native/se-caption-final/與standard-caption-final/，raw se-caption-final.txt／standard-caption-final.txt。B與同一Reviewer等新圖後只做最後增量目視；不新開Simulator或改renderer。

### 圖片外說明的原生圖就緒；閱讀假設更正

D518標準機4/4、runtimeWarnings=[]、90432已delete；15張新圖在native/standard-caption-final/。D518 SE原批3/4：四選項、固定世界及保存故障/首屏三案例通過，11張在native/se-caption-final/，原summary仍明示1個閱讀失敗，未當4/4。原新圖目錄沒有覆寫舊批次。

閱讀失敗是測試額外假設app底部要扣24pt，要求maxY<=635；SE沒有home inset，實際Scroll可視至667、問題底邊647本已完整在畫面內，不能解讀為永久截斷。ce9只改測試以actual Scroll/app viewport再留8pt驗證；App tree與D518完全相同。只重跑SE該1案例，含8/13正常/AX末行，再輸出native/se-reading-final/四圖；不重跑已通過三案例、不改內容/字級。

B／同Reviewer可先讀standard-caption-final15與se-caption-final11，檢查說明確實在圖片外且人物頭部完整，等se-reading-final4再確認13歲AX完整末行。最新App來源D518，UI補測ce9只改讀取邊界；不把不同批次改標單次SE4/4，不新增Scene變更。

### 最終補測與目視入口

SE ce9閱讀補測1/1、runtimeWarnings=[]，1BCA439C已delete；四張新圖／summary／manifest在native/se-reading-final/，13歲AX問題末行已捲入actual viewport。D518標準15圖在standard-caption-final/，D518 SE三個已過案例11圖在se-caption-final/；原4項batch的3/4與固定24pt假設失敗summary原樣保留，沒有標成單次4/4。

最終App D518與ce9的App tree相同，只改測試實際可視範圍；Scene仍ced164...。B／同一Reviewer最後可只讀上述15＋11＋4圖共30圖，確認說明在圖片外、13歲三路頭部無badge遮擋、最大文字問題末行完整及來源hash。這是最後增量覆核，不再開Simulator／改Scene。Root的17台本輪專用裝置均delete、QA raw保留後封存；不合併或發布。

### 最終目視收束

已窄取same Reviewer的final-incremental-independent-review.json，Root重算11張原圖hash均吻合。11張最新差異＋先前30張歷史範圍：遮頭P1與問題末行缺口關閉，無新P0/P1，三P2保留；不當全產品美術或最新雙21全套。App/Scene不再改，17台delete已完成；接下來僅證據／記憶companion與獨立Draft／當前HEAD CI，不合併發布。
