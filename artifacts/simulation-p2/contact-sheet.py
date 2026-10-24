"""Make a review index from unchanged native screenshots; originals remain in their manifest."""
from pathlib import Path
import hashlib,json
from PIL import Image,ImageDraw,ImageFont
out=Path(__file__).resolve().parent
folder=out/'screenshots/narrow-final'
files=['sim-01-initial.png','p2-03-paper-facing-in-scene.png','p2-01-native-paper-inspection.png','p2-02-native-relationships.png','p2-04-origin-team.png','p2-04-origin-help.png','p2-05-largest-past-scene.png','p2-06-largest-present-scene.png','sim-12-largest-last-action.png']
labels=['01 Initial world','02 Folded paper truss','03 Free paper study','04 Real relationships','05 Team origin / opportunity','06 Help origin / opportunity','07 AX5 past record','08 AX5 back to present','09 AX5 last free action']
w,h=300,580
sheet=Image.new('RGB',(w*3,h*3),(239,238,229));draw=ImageDraw.Draw(sheet)
font=ImageFont.truetype('/System/Library/Fonts/Supplemental/Arial.ttf',17)
records=[]
for index,(file,label) in enumerate(zip(files,labels)):
 path=folder/file;shot=Image.open(path).convert('RGB');shot.thumbnail((w-12,h-38))
 x=(index%3)*w+(w-shot.width)//2;y=(index//3)*h+32
 sheet.paste(shot,(x,y));draw.text(((index%3)*w+8,(index//3)*h+7),label,fill=(28,66,62),font=font)
 records.append({'file':str(path.relative_to(out)),'sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
sheet.save(out/'contact-sheet.png')
(out/'contact-sheet-manifest.json').write_text(json.dumps({'source':'Native SE3 screenshots, thumbnails only; no generated or edited character asset','inputs':records,'output_sha256':hashlib.sha256((out/'contact-sheet.png').read_bytes()).hexdigest()},indent=2)+'\n')
