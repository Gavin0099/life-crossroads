"""Render structural studies as editable SVG, without generating new artwork."""
from pathlib import Path
from html import escape

BASE = Path(__file__).resolve().parents[2] / 'docs/ui/wireframes'
SPECS = {
    'event-first': [('阿澄・13 歲 / 2027 / 青少年', 60, False), ('[小型事件插圖] 紙橋挑戰', 80, False), ('你會怎麼做？', 45, True), ('和朋友做簡易作品 / 2 格精力', 100, True), ('先找老師想辦法 / 1 格精力', 100, True), ('四項狀態（次要）', 65, False), ('人物 / 人生地圖 / 紀錄', 60, False)],
    'chapter-novel': [('阿澄・13 歲 / 2027 / 青少年', 60, False), ('[大幅章節場景]', 210, True), ('第二章 · 紙橋挑戰', 55, False), ('事件敘述 / 角色對話', 110, True), ('和朋友做簡易作品 / 2 格精力', 80, False), ('先找老師想辦法 / 1 格精力', 80, False)],
    'timeline-map': [('阿澄・13 歲 / 2027 / 青少年', 60, False), ('童年 · 已走過的節點', 70, False), ('青少年 · 目前紙橋挑戰', 100, True), ('青年 · 尚未抵達', 70, False), ('中年 · 尚未抵達', 70, False), ('晚年 · 尚未抵達', 70, False), ('目前事件 / 兩選項與成本', 85, False), ('進入目前岔路 →', 55, True)]
}

def render(key, items):
    parts=['<svg xmlns="http://www.w3.org/2000/svg" width="390" height="844" viewBox="0 0 390 844">', '<rect width="390" height="844" rx="32" fill="#0C141B"/>', '<g font-family="PingFang TC, sans-serif" fill="#EAF1F1">', f'<text x="20" y="34" font-size="15">{key} / 同一事件結構研究</text>']
    y=52
    for label,height,accent in items:
        fill='#F4F6F2' if accent else '#1A2731';ink='#102028' if accent else '#DAE4E7'
        parts.append(f'<rect x="20" y="{y}" width="350" height="{height}" rx="14" fill="{fill}"/>')
        parts.append(f'<text x="34" y="{y+height/2+6}" font-size="16" fill="{ink}">{escape(label)}</text>')
        y+=height+12
    parts.append('<text x="20" y="825" font-size="12" fill="#B8C9D1">靜態線框・非正式美術・內容相同</text></g></svg>')
    return '\n'.join(parts)+'\n'

if __name__ == '__main__':
    BASE.mkdir(parents=True,exist_ok=True)
    for key,items in SPECS.items(): (BASE/f'{key}.svg').write_text(render(key,items))
