# Gameplay 公開契約的測試快照

兩份 Swift 檔由 Gameplay Agent 的 `codex/life-loop-01` 工作樹原樣複製，契約版本 `life-world-view-1`，2026-10-24。不是 Visual Agent 開發的第二套時間或人生系統；只在獨立預覽 build support 中編譯，正式 App 不包含此資料夾。正式所有權為 Gameplay 的 `LifeCrossroads/Presentation/`。

保留這份快照，使 Visual 分支可以單獨重現原生預覽，不依賴另一個未提交的工作樹。`source-binding.json` 保存每次實際編譯的兩份檔案 SHA；整合時由 Gameplay 比對正式版本，不把本快照複製回正式 target。使用 `--contract-repo` 可針對更新後的正式工作樹做相容性驗證。
