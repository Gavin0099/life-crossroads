# P1 體驗補強：獨立完整覆審

Reviewer：`/root/pr14_independent_review`；日期2026-10-27。分支`codex/p1-experience-completion`，基底`317794625dab363a38313bafa4f3d78408fc7aba`。本輪先審核工作樹快照，最後已逐檔綁定implementation commit `28aa189e8c734d7d65aeadf5c34db5842b3bffdd`；不把PR14或中間WIP的CI當這輪證據。

## Verdict

**核心工程可接受（APPROVED）；目前無未解P1/P2程式阻擋。** 初輪兩類內容P2及本輪新發現的記憶覆蓋P2已修正並有獨立反例回歸。此判斷綁定下方最終`life-focus-2`來源；不代表P1整體產品、兒少娛樂／理解、實機或發布通過，不授權合併。

**證據收尾狀態：已完成。** 最後focus2的1024局完整資料、summary及SE原生2例已獨立讀取核對；CI分片補修亦已審閱。Root的最終完整debug Swift因長時間CPU回歸而明確中止，改採與CI相同release重跑；reviewer已讀最後release日誌，四個XCTest target合計140項、0失敗，公開validation與保留日誌SHA一致。106個已審來源與implementation commit逐檔SHA全部一致，公開10項checksums亦全部匹配。遠端CI仍不在本reviewer聲稱範圍，較早focus+1結果沒有替代focus2。

## 已關閉的發現

| 發現 | 可執行證據與最後處置 | 歸因／決策影響 |
| --- | --- | --- |
| P2：無前因正文宣稱已有支持／照顧準備 | JPN-1 Seed0全休息在59歲、Seed4全休息在72歲；初讀正文與nil前因矛盾。現以條件式正文及正確route敘述消除；8項ExperienceCompletion回歸包含實際LifeSession見證。 | 本片新增；已關閉。詳見content-review.md與初讀snapshot。 |
| P2：小澄購買計畫被當成樹老師過往支持 | Seed21、25歲起stability、45歲stagedPlan；曾解鎖52歲teacher returnHelp。購買現寫budget.staged，不能解鎖support互惠；實際來源／選項／人物回歸驗證。 | 本片新增；已關閉。不是僅因NPC名稱不同判缺陷。 |
| P2：再次求助／休息抹掉已確認支持與已試過步調 | 獨立完整人生找到Seed17 confirmHelp21→後續ask→52歲returnHelp消失；Seed63 shortReturn52→rest59→65歲adaptedPlace消失。StoryMemory現在保留原confirmed／paced來源，新的請求／休息仍在決策帳本。 | 本片新增；已關閉，解鎖與來源均修正，沒有只改文案。 |

記憶修補位置：`LifeCrossroads/Domain/StoryMemory.swift:56–69`。新正式回歸`testLaterRequestsAndRestKeepConfirmedSupportAndPracticedPace`驗Seed17/63整局、source fact不被覆蓋、重新讀檔相等。獨立harness在修補後另找到Seed16與Seed28，證明returnHelp／adaptedPlace實際可行、source仍為confirmHelp／shortReturn，restore一致；`independent-continuity-fixed-probe.log`保留完整前史與收據。最後又以focus2 libraries實際選returnHelp／adaptedPlace並走到晚年，狀態分別留下reciprocal／returned，StoryConnections實際accepted=true；見independent-final-accepted-probe.log。這些新正例不冒稱原先兩局的結局仍逐位元相同，因保留前因也會合理改變候選權重。

## 核心判定與正向證據

### 重心：完成區間才改變機會，不重抽或每段自動加點

`LifeFocus.swift`／`LifeState.swift`在時間推進後記錄fromAge/toAge/focus；`EventSelector.swift`從已完成區間產生權重步驟。四種focus各有prepared行動，無前因則不開放；`LifeFocusStoryRules`引用focusSource，不偽造一項過去決策。這是版本化遊戲假設，不是現實機率。

最終scope內平衡修訂取消每段+1；`LifeFocusSelection.currentVersion=life-focus-2`，benefit為zero。獨立證明反覆改focus不改眼前event／selection／選項，選擇本身不產生活動記憶，最後選取只完成一次8→10區間，留下2倍候選權重且restore相等；對照無focus同樣實選rest，資源完全相等且requested/actual皆zero。四種focus prepared／無前因／balanced、偽造紀錄與長短區間另由最終定向測試覆蓋。

### 非數位鏈是實際機會與行動差異

獨立實走JPN-1/KEN-1同模板、同Seed：care Seed4實選先前預備後，各自可執行reviewVisit/reviewShared；offlineTools Seed1實際練習後，各自可執行benchWork/mobileRepair。兩組均15決策完整人生、來源trace相符且restore相等，保留完整trace於`independent-environment-chain-probe.log`。這組見證執行於focus2前、沒有選focus，最終相關規則靜態核對未改行為；不冒稱它是focus2批次重跑。

前輪同家庭同Seed投影還實見TWN unknown時無特殊管道，但保留詢問、手動入門與休息；不存在把未知變0的來源值。電力路線不讀網路指標，照顧成本與資格共用CarePreparation；家庭材料／支持與國家統計分開記錄，國名不挑路線。最終receipt只列真正參與判定的家庭inputs。現有門檻測試含20/40、95邊界、zero-support、missing、改顯示國名／網路數值對離線路線不影響。

完整人生後續允許各自選擇，不能把全生命差異單歸國籍／單一資料值。預設7個可配對家庭的所有實際條件相等，錯模板被拒；進階兩家庭存讀後保留jpn-1與ken-2身份，未把UI預設冒充persisted選擇。

### 原人生、重播、真實磁碟與版本拒絕

最終41項獨立assertions包含固定Seed0/1/34/UInt64.max的候選亂數配對與創作可行性；相同Seed+實際決策完成重播bytes相同；平行、重新分岔及存讀不改原人生bytes。

真實檔案系統chmod使atomic replacement失敗，驗證原檔bytes未變、load仍為已提交人生；恢復權限retry後等於pending且原局不變。把已存檔engine改成PR14舊引擎，load拒絕且不改檔；另外保留當前engine、只將實際focus2檔改成life-focus-1，load同樣拒絕且保留原bytes。未宣稱舊規則自動遷移。

### StoryConnections分開「機會」與「接受」

`StoryConnections.swift`先核對實際前因，再重建decision checkpoint，僅保留真正可行的continuation；accepted由當回合實選choice是否屬於該集合決定。不是只看title／variant或資源加點。focus來源必須存在已完成history，事件來源必須對得上較早的實際trace。

`ExperienceAuditTests.testRecoveryIsAnAvailableStoryNotAClaimOfAcceptedHelp`實走恢復重心＋全rest；有可行的恢復延續，但每項accepted=false、沒有support鏈。summary裡livesWithOpportunity與livesAccepting分開；livesWithTwoDistinctLinkedRules也是可行連結數，不能改稱「已完成兩條故事」。原七鏈批次保留歷史用途；本片策略會選focus及優先準備行動，不可與舊策略輸出冒稱同條件提升。

### 52事件與整合呈現

獨立catalog解析52唯一ID，產生器build()與bundled JSON結構完全相等；新增12個不是只換名，具不同的focus前因、求助確認／互惠、恢復步調、照顧安排與工具路線。詳細分組及語意審閱見content-review.md。最終完整批次逐局event記錄重算52／52 observed、無unobserved；每個新增事件至少有真實入選見證。數量與程式正確性不等同內容好玩，也不等同每種延續行動都被接受。

主／全文敘事使用同一真實事件；world memory由story facts與focusHistory投影，提供支持約定、休息空白、實試短時參與、工具桌／手動箱的分別視覺標記。後果／完整比較區分機會與實選，不新增虛構獲得支持。原生畫面與操作證據由Root在最後版本產出；本reviewer直接讀取SE xcresult summary並親看3張新截圖，核對選前休息空白→選後試過短時參與、focus2生活安排receipt。這是標準字級SE Simulator證據；不能替代所有新內容最大字級、實體iPhone或人工VoiceOver。本reviewer未啟動Simulator。

## 最終獨立驗證

| 項目 | 結果與來源 |
| --- | --- |
| focus2定向Swift | **23項PASS**；LifeExperience6、ExperienceCompletion8、ExperienceAudit1、SaveRepository6、WorldPersistence2。`independent-focus2-targeted.log`。 |
| focus2獨立不變式 | **41 assertions PASS**，含實體磁碟失敗／retry、原局、配對、版本、no-reroll與無加點；`independent-focus2-invariant-probe.swift/.log`。 |
| Python內容 | **2項PASS**；`independent-focus2-python.log`。 |
| 生成資料一致 | build() == bundled JSON、52唯一ID；`independent-focus2-catalog-check.json`。 |
| 前一修補階段 | 17定向PASS與獨立支持／恢復前因harness PASS；保留`independent-postfix-targeted.log`、`independent-continuity-fixed-probe.log`。不是focus2完整套件的替代。 |
| 早期全套 | 初始139測試中137首次PASS；reviewer的/tmp快照漏帶3個既有JSON fixture造成2項missing-file。補齊後兩項各自PASS。原始失敗與定向補驗日誌保留；這不是產品失敗，亦不列成最終focus2全套PASS。 |

所有獨立Swift均在隔離snapshot編譯，不使用共享.build的舊binary。初讀及補修前source有tar.gz／manifest，避免並行修改改寫歷史證據。harness最初有Swift try位置及一次snapshot工作路徑錯誤，已修正，未當產品缺陷；只採成功編譯後的指定binary結果。沒有刪掉不利產品反例：修前Seed17/63仍完整留存。

重現命令：snapshot中`swift test -c release --filter 'LifeExperienceTests|ExperienceCompletionTests|ExperienceAuditTests|SaveRepositoryTests|WorldPersistenceTests'`；`python3 -m unittest discover -s Tests -p 'test_experience_content.py'`。獨立probe以snapshot的release libraries編譯，使用`-I <snapshot>/.build/release -L <snapshot>/.build/release -lLifeDomain -lLifeData -lLifePersistence -lLifePresentation`，並傳入snapshot的Data/Resources絕對路徑。實際snapshot位置保留於final-source-manifest.json；腳本與日誌位於本報告同目錄。

## 最終量測、原生及CI證據覆核

- `independent-final-audit-check.json`獨立重算完整笛卡兒集合：16家庭×4策略×Seed0…15＝1024唯一局；64個家庭／策略組各16局、120個Seed配對，共7680對。每局15選擇、focus記錄全為life-focus-2。rawSHA與catalogSHA均對上；所有52事件計數從逐局events重新累加後與report／summary一致。
- 所有策略每組256局，四項最終資源100的個數全部為0。這不是所有Seed永不飽和；前一focus1不利結果沒有被刪除。restFirst有224／256局出現可行連結、總288條未接受連結，實際接受0；summary的機會／接受計數已逐cohort重算。
- 正式矩陣仍有returnHelp=0、adaptedPlace=0；不能把52個事件入選說成兩項行動已完成。這是有限Seed／策略樣本缺口，獨立Seed16/28已實選並完成全局提供專項正例，沒有擅自改策略或事件率去墊高矩陣數字。
- summary中兩組完整配對已核對所有實際家庭欄位相等（只有ID／國碼／顯示名不同）、同Seed／策略、同節點年齡、真實前因與applied。工具Seed2是poweredBench→benchWork對portableKit→mobileRepair；照顧Seed11是reserveVisit→reviewVisit對sharedPlan→reviewShared。trace沒有把後續所有差異歸因單一指標。
- 額外在隔離最終source重新執行16局公開資料：每個家庭取一局Seed0，輪流覆蓋4策略；依公開實際focus與choice序列重播，event／variant／focus／finalResources／connections／environmentReceipts全部相等。這是16局獨立重播，不冒稱又獨立重跑1024局；日誌`independent-audit-replay.log`。
- 原始資料在審查期間由audit.json轉為audit.json.gz；解壓bytes未改，SHA256=`57083823bf7106b97dd725829b6b15d5c874de7f5401d28eefa42ec96de65dd5`。reviewer先讀完資料，後續replay曾因路徑搬移找不到檔；固定已驗SHA的解壓輸入後完成重播，不是模型失敗。
- 直接`xcresulttool get test-results summary`確認`LC02-20261027T083556Z.xcresult`的SE3兩例Passed、0 failed、0 skipped；attachment manifest對應恢復參與前後與focus存續/no-reroll。舊3/1/1例另列版本階段，未合計冒稱同一輪全過。Root報告專用device已delete；reviewer未建立／操作任何Simulator。
- 新增審查`.github/workflows/governance-drift.yml`及`Tests/test_ios_shards.py`：6 shards各5例，共30例恰一次；45分鐘上限、fail-fast=false及ios-app聚合成功門檻均保留。新增128局experience audit是較小CI樣本，不替代完整1024資料。5個shard回歸及basic6均由reviewer實跑PASS。分片調整可降低每job工作量，但不能預先宣告新遠端CI或45分鐘完成已通過。
- `README.md`、`docs/p1-experience-delivery.md`、`docs/opportunity-playtest.md`及公開comparison.md沒有把工程率說成兒少娛樂性90–95%，明列0…15樣本未接受兩項行動、策略差異、台灣／真人／美術Gate。最終完整Swift收據初讀時標RUNNING，沒有預填PASS；debug中止後另跑的release最終140項PASS已獨立讀取日誌核對，詳見提交綁定紀錄。公開validation的sourceBinding已補coreDigest／CI digest與106檔SHA，reviewer逐項核對無差異。

## 來源綁定

- CI兩檔digest：`fabac1ee15a2e7710779532c96493de8902fd97b931042c3b140518086559523`，完整路徑與SHA亦在manifest。
- Core digest：`3328ecc383d45b0cf5a533dc31c05f6acaec2dc925fa737a004f2e9704712661`。
- 定義：對manifest所有LifeCrossroads/與scripts/路徑→SHA字典，sorted keys、compact JSON後取SHA256。`final-source-manifest.json`逐檔記錄全部snapshot輸入；其中既有未改檔是驗證輸入，不表示本輪逐行重新審查了所有舊碼。
- 最終來源再次比對沒有差異；公開validation.json的sourceBinding也匹配106檔。最後以`git show 28aa189e8c734d7d65aeadf5c34db5842b3bffdd:<path>`讀取106個提交內檔案並逐一計算SHA256，缺少0、不同0，公開sourceBinding同樣106檔一致。tracked diff在final-tracked-diff.patch；新檔內容由snapshot及manifest綁定，不能只看git diff --stat漏掉untracked實作。

| 關鍵已審檔案 | SHA256 |
| --- | --- |
| `LifeCrossroads/Domain/LifeFocus.swift` | `2ee82f5088723fd8b338402237d24505f22e90473bbf0203e6a99ed9825235c7` |
| `LifeCrossroads/Domain/StoryMemory.swift` | `35201f12747df3f2faa005c35ee0c1ff4d7c8089fe13339852f54651c92fa91c` |
| `LifeCrossroads/Domain/EnvironmentOpportunity.swift` | `8741863d34008bc2bded72ef4ee2927578e1f968f7c78c359c2cc71df94e40b8` |
| `LifeCrossroads/Analysis/StoryConnections.swift` | `f48e805d81d792b6740ae8e990d7c7565121f7e204c4881b15e1374dc03fecd7` |
| `LifeCrossroads/Analysis/ExperienceAudit.swift` | `af416bf5a75b0fab0f980b76e017e6eaf3ec6afc174678fd097c3b2bca068d84` |
| `LifeCrossroads/Presentation/LifeStoryComparison.swift` | `3e7835a8bb5804357242b96f3ec4f067b13754527532beb510583ec70411e182` |
| `LifeCrossroads/Presentation/LifeWorldFrame.swift` | `b1e2e034bdaebab9f604d35ecc987286dbac8d04a9120ec6854e53b71476fb6c` |
| `LifeCrossroads/App/CrossroadsView.swift` | `b73e8679843fe2be4b09a4f14a7ce6bc522c9c139f625d571b26db3af004581b` |
| `LifeCrossroads/App/LifeWorldScene.swift` | `12bd2718a8fedf808a53493c76d3736786e9eb477b1b9e147b8645bc62fd86dd` |
| `LifeCrossroads/Data/Resources/catalog.json` | `9370a4264d0bf49c655f26364cfb10a5713e329e99c234532c1351912602fc77` |
| `scripts/experience_content.py` | `85d8e84fff24a069ca8288d9eddfc1c1134a56f25e4308f3874990946c91c87b` |
| `scripts/summarize-experience.py` | `837a91ca6f860bb2b7a604fd6e3842079a169a3bef5526ab526fc70152f9ca36` |

## 剩餘產品驗收缺口與非主張

- 兒少尚未試玩：8–10位方向性樣本、10–12與13–15分齡、自由首局10–15分鐘、5秒處境理解、未受提示的自發重玩、自己的話理解環境／家庭／選擇／他人與運氣仍待真人。不能把沒有資料當通過，也不能把它任意算成最後5%。
- 當前完整實機與人工VoiceOver仍待驗。Simulator與純Swift不能替代；新正式美術／自然角色表演亦沿原工作線驗收。
- 台灣可比全人口數位／電力、直接自付來源缺口仍在。unknown是誠實fallback，不是完整八國資料Gate通過；沒有新增外部來源研究或捏造統計。
- 52事件／有限策略多Seed可支持內容量與模型可達，不證明各局的情感／策略變化、娛樂性或教育效果。任何最終資源100比例亦需如實列，不能只挑有利策略。
- 本輪沒有合併、發布、GitHub review或commit/push；reviewer只寫ignored證據及隔離/tmp檔。Root的共享dirty memory與程式保持原狀。整體Draft/HOLD不因工程APPROVED而解除。

## 封裝收尾紀錄

初次報告封裝時comparison.md剛改用「每段自動加點」的精確描述，checksums.json該一項尚未刷新；此歷史狀態不列程式P2。最終提交內已刷新，reviewer直接讀提交內checksums及各對應檔案驗證10項全部一致，包含comparison.md；4張截圖亦已對上。此封裝缺口已關閉。


## 最終提交與完整release收據綁定（2026-10-27）

- Implementation commit：`28aa189e8c734d7d65aeadf5c34db5842b3bffdd`。讀取提交內容，不以當前dirty工作樹代替；106個已審來源全部匹配`final-source-manifest.json`，missing=0、mismatch=0。公開validation.sourceBinding亦為106檔且逐檔相同，coreDigest與ciSourceDigest和上表一致。
- 公開`artifacts/evidence/p1-experience/checksums.json`的10個檔案均以同一提交內bytes重算，mismatch=0。機器可讀核對結果：`implementation-binding.json`。
- Root執行的最終`swift test -c release`日誌已由reviewer獨立讀取：LifePresentationTests 15、LifePersistenceTests 27、LifeDomainTests 91、LifeAnalysisTests 7，共140個XCTest，全部0 failures；不是把尾端Swift Testing的0 tests當成全套結果。四個target均明確顯示All tests passed。
- 最終日誌`final-release-swift.log`與`/tmp/lc-experience-final-release-swift.log`的SHA256均為`c5d9e20c992e94d5abc42687393dc5700c645948c13c105f74540d3c84987416`，與提交內validation的release收據一致。reviewer此最後步驟只核對收據，沒有再次執行全套；前述23項定向、41項獨立assertions與其他獨立驗證仍依各自範圍列示。
- 最終判定不變：**此提交的核心工程與CI接線可接受，無未解P1/P2；整體產品仍Draft/HOLD，真人、實機／VoiceOver、台灣可比資料及美術Gate未通過，不能據此宣稱娛樂性90–95%或合併／發布通過。** 最新遠端CI由root另查；之後memory companion commit未自動納入本來源審核，也不因此改寫本工程判定。
- Reviewer最後步驟只更新ignored報告與來源／綁定證據；未修改tracked檔、未commit/push/GitHub review／merge，亦未使用Simulator。
