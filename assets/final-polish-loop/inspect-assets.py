"""Read-only PNG audit of local edit candidates. Never writes image pixels."""
import sys, hashlib, json, struct
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[2] / 'Tests'))
from test_multicast_assets import rgba_rows
root=Path(__file__).resolve().parents[2]
paths=[
 'LifeCrossroads/App/Assets.xcassets/VL2Teen13.imageset/VL2Teen13.png',
 'LifeCrossroads/App/Assets.xcassets/MCMumu.imageset/MCMumu.png',
 'assets/final-polish-loop/originals/teen13-listening-v1.png',
 'assets/final-polish-loop/originals/adult32-listening-v1.png']
result=[]
for path in paths:
 raw=(root/path).read_bytes(); w,h,rows=rgba_rows(raw); mx,my=w//2,h//2
 pts=[(x,y) for y in range(my,h) for x in range(mx) if rows[y][x*4+3]>12]
 x0=min(p[0] for p in pts); x1=max(p[0] for p in pts)+1
 y0=min(p[1] for p in pts); y1=max(p[1] for p in pts)+1
 alpha=[row[x*4+3] for row in rows for x in range(w)]
 result.append({'path':path,'sha256':hashlib.sha256(raw).hexdigest(),'bytes':len(raw),'dimensions_px':{'width':w,'height':h},'png_bit_depth':8,'png_color_type':6,'alpha_min':min(alpha),'alpha_max':max(alpha),'fully_transparent_fraction':alpha.count(0)/len(alpha),'grid':{'columns':2,'rows':2,'x_edges_px':[0,mx,w],'y_edges_px':[0,my,h]},'selected_cell':{'index':2,'source_rect_px':{'x':0,'y':my,'width':mx,'height':h-my},'visible_alpha_bbox_px':{'x':x0,'y':y0,'width':x1-x0,'height':y1-y0}},'visible_pixels_on_split_lines':sum(rows[y][mx*4+3]>12 for y in range(h))+sum(rows[my][x*4+3]>12 for x in range(w)),'alpha_threshold':12})
print(json.dumps(result,ensure_ascii=False,indent=2))
