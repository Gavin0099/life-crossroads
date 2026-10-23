# Domain → View 介面提案，待整合審核

僅為 UI 所需欄位草案，沒有改 Domain API 或宣稱主 Agent 已接受。

```swift
struct EventViewDTO {
    let eventID: String
    let stageLabel: String
    let ageLabel: String
    let title: String
    let narrative: String
    let artworkID: String?
    let options: [OptionViewDTO] // id/title/costLabel/isAvailable/unavailableReason
}
struct OutcomeViewDTO {
    let selectedOptionID: String
    let immediate: [String]
    let triggeredDelayed: [String]
    let factors: [TraceFactorViewDTO] // traceID/kind/evidenceLabel/sourceID
}
```

`VisualDemoModels` 是獨立展示 fixture。UI 不重新計算成本、機率或結果，也不把字串當 trace。
正式版只有已觸發的後果可顯示成事實；未發生的呼應只顯示可能性，或不顯示。
缺因素陣列時顯示空狀態；不得為「四類因素 UI 很完整」硬塞運氣或國家原因。
跨國比較需提供固定條件、變動條件、成本、支持、結果、資料/引擎版本與可比限制。
不支援/不可比時顯示原因，不補假數字。只換國名的結果不變性由 Domain 保證。

接線順序：主 Agent 接受 DTO → 在其整合分支加 adapter → 既有引擎回歸與 UI 流程 → 正式素材核准。
本輪不直接對其他 chat 發送訊息，也未建立整合 PR。
