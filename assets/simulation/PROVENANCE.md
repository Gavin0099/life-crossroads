# 候選美術來源與GS-05編修紀錄

這些是review候選，`approved_for_app=false`、`production_approval=false`。複用來自既有Visual分支的本專案原創候選，不代表正式選稿或商用權利審核完成。逐檔來源與SHA-256見`manifest.json`；原圖沒有覆寫。

GS-05僅編修初始構圖：以內建`image_gen.imagegen`的edit模式，參照既有`characters-atlas-v2.png`與`va-materials-table-v1.png`，輸出1536×1024透明PNG。沒有使用付費CLI/API後備，也未新增表情或姿勢套件。

本次生成規格摘要（非逐字prompt存檔）：保留原水獺阿澄、野兔阿禾及老師的衣服、比例、配色；三人頭部、視線與自然靠在工作桌邊的手部共同朝向桌上尚未完成的紙材。保留耳、尾與腳的完整輪廓；不畫已完成的紙橋、獎盃或成功符號；透明背景供原生場景合成。

實際生成回傳檔名、輸入名稱、輸出雜湊已記錄在manifest。逐字prompt未另存，因此不宣稱可逐字重現生成。生成圖需再經原生合成截圖與獨立美術審查；單張原圖不是GS-05通過證據。
