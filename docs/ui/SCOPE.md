# UI-00｜本輪範圍

目的：建立有邊界、可獨立 review 的第一版事件主導 UI。

本輪交付：方向/範圍、資訊架構、三方向 low-fi、首頁 v1、可點流程、可編譯 DTO、空狀態、兩尺寸 Simulator 證據與驗收表。
為避免接線混亂，順帶落地 StageHeader/EventHeroCard/ChoiceCard/OutcomeCard/ReasonCard/StatusStrip/FooterActions；不把它宣稱為完整 UI-07～09。

採用既有 `style-B/scene.png` 候選場景。沒有新增 AI 圖片、下載模型、鎖定正式角色或改素材審核。
舊 A/B 原型與四角色五階段圖保留；新分支不把它們移除或重寫。

不做：完整引擎接線、八國全事件、正式美術、存檔、即時時間控制、後端、帳號、資料蒐集與發布。
這輪不要求把 UI-00～10 全部標成完成；UI-03 競品查核與 UI-10 人類方向驗證仍待後續。

時間顯示由 DTO 提供；目前是手動決策回合，因此顯示「等待你的選擇」。不創造無規格的自動年份、播放速度或暫停引擎。
驗收：新 target 無 LifeDomain/LifeData dependency；與主工作線並行，提交及推送只包含本輪變更。
