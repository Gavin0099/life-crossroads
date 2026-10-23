# UI-02｜三種結構研究

目的：以同一角色、年齡、紙橋事件和選項成本，比較操作焦點。
這三種是版型研究，與前輪 A/B 美術風格比較不同。

| 事件卡主導 A | 章節敘事 B | 人生時間軸 C |
|---|---|---|
| ![事件卡主導](event-first.svg) | ![章節敘事](chapter-novel.svg) | ![人生時間軸](timeline-map.svg) |

- [A 規格](event-first.md)：選項是主動作，預設實作方向。
- [B 規格](chapter-novel.md)：強調場景與對話，只保留部分節奏。
- [C 規格](timeline-map.md)：強調人生位置，採用為輔助頁。

SVG 是可編輯靜態線框，可用 `python tools/ui/write-wireframes.py` 重建。
原生研究截圖與可點首頁見 [review](../review.md)。沒有宣稱線框按鈕可點。
另外兩版的 `#Preview` 與 launch arguments 是靜態研究入口；主遊玩流程只有一版。

驗收：可辨識三版焦點差異；沒有用不同事件、美術品質或不同成本誘導比較。
