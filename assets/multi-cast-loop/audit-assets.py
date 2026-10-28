#!/usr/bin/env python3
"""Read-only pixel inspection; source and catalog PNG bytes are never rewritten."""
import hashlib,json,struct
from pathlib import Path
from PIL import Image
ROOT=Path(__file__).resolve().parents[2]
ORIGINAL=Path('/Users/macminim4/.codex/generated_images/01a18119-81ba-7390-ae24-1e14e677b6ee')
core=json.loads((ROOT/'assets/multi-cast-loop/prompts-source.json').read_text())
candidates=json.loads((ROOT/'assets/multi-cast-loop/candidate-prompts.json').read_text())
revisions=json.loads((ROOT/'assets/multi-cast-loop/revision-prompts.json').read_text())
items=[
 ('MCAhe','exec-0a90d334-6f08-4c2a-9ac6-8890ace5dfcd.png',[0,512,1024,1536],[0,484,1024],['childConversation','childHappy','childDisappointed','adultConversation','elderListening','elderPinwheelReunion'],['MCAhe','MCAhe_spacing']),
 ('MCTeacher','exec-6bd232d8-f3b3-4893-9f16-1d14d658403e.png',[0,627,1254],[0,642,1254],['listening','explaining','sharedMaking','encouraging'],['MCTeacher']),
 ('MCCheng','exec-b7c06250-66d1-4ff5-b858-e040e7856b1c.png',[0,512,1024,1536],[0,493,1024],['asking','planning','dividingTask','rejoining','matureListening','maturePinwheelMaking'],['MCCheng']),
 ('MCMumu','exec-4a0cb38b-1b3f-4daa-9678-acd1dc6e6347.png',[0,627,1254],[0,627,1254],['childConversation','teenListening','adultPlanning','elderReunion'],['MCMumu','MCMumu_gaze']),
 ('MCCatCandidate','exec-dbd6fd53-c6f3-4c3a-8816-5bbb0f78b4aa.png',[0,399,766,1201,1653,2011],[0,782],['child','teen','youngAdult','middleAge','elder'],['MCCatCandidate','MCCatCandidate_spacing']),
 ('MCDogCandidate','exec-743acff6-aab4-4c91-8f8b-17d0dc46ee38.png',[0,406,797,1185,1609,1983],[0,793],['child','teen','youngAdult','middleAge','elder'],['MCDogCandidate'])]
prompts=core|candidates|revisions
prompts['MCMumu']+=' IMPORTANT composition: character content only 65% of each cell, large blank transparent band between rows. No artwork within 40px of the horizontal/vertical midpoint.'
prompts['MCDogCandidate']+=' Enlarge empty transparent gutters: each sprite only central65% width of its cell; keep tail IN its cell. Elderly has noticeably silver muzzle and gray eyebrows with round spectacles. Middle-age torso slightly broader than young adult.'
assets=[]
for name,original,xcuts,ycuts,ids,pids in items:
 path=Path('LifeCrossroads/App/Assets.xcassets')/(name+'.imageset')/(name+'.png')
 raw=(ROOT/path).read_bytes();original_raw=(ORIGINAL/original).read_bytes();assert raw==original_raw
 im=Image.open(ROOT/path);assert im.mode=='RGBA';w,h=im.size;assert (xcuts[-1],ycuts[-1])==(w,h)
 alpha=im.getchannel('A');pixels=alpha.load();hist=alpha.histogram();cells=[]
 for row in range(len(ycuts)-1):
  for col in range(len(xcuts)-1):
   x,y=xcuts[col],ycuts[row];cw,ch=xcuts[col+1]-x,ycuts[row+1]-y; index=row*(len(xcuts)-1)+col
   opaque=[(xx,yy) for yy in range(y,y+ch) for xx in range(x,x+cw) if pixels[xx,yy]>12]
   assert opaque
   xs,ys=zip(*opaque);bbox={'x':min(xs),'y':min(ys),'width':max(xs)-min(xs)+1,'height':max(ys)-min(ys)+1}
   cells.append({'index':index,'id':ids[index],'source_rect_px':{'x':x,'y':y,'width':cw,'height':ch},'visible_alpha_bbox_px':bbox})
 vertical=[sum(pixels[x,y]>12 for y in range(h)) for x in xcuts[1:-1]]
 horizontal=[sum(pixels[x,y]>12 for x in range(w)) for y in ycuts[1:-1]]
 assert all(n==0 for n in vertical+horizontal)
 assets.append({'name':name,'kind':'candidateAtlas' if 'Candidate' in name else 'formalCharacterAtlas','path':str(path),'source_original_path':str(ORIGINAL/original),'sha256':hashlib.sha256(raw).hexdigest(),'bytes':len(raw),'dimensions_px':{'width':w,'height':h},'png_color_type':raw[25],'has_alpha_channel':True,'fully_transparent_fraction':hist[0]/(w*h),'byte_identical_to_original':True,'grid':{'columns':len(xcuts)-1,'rows':len(ycuts)-1,'uniform':False,'x_edges_px':xcuts,'y_edges_px':ycuts},'cells':cells,'cut_boundary_alpha_above_12':{'vertical':vertical,'horizontal':horizontal},'prompt_ids':pids,'approved_for_app':False,'approval_scope':'Preview only; no formal story identity or event source' if 'Candidate' in name else 'Authorized Draft integration candidate; formal art approval pending','runtime_note':'Use explicit source_rect_px, never infer equal cells. No pixel editing. Only actual projected events and saved interactions may select a formal story pose.','legal_status':'AI-generated original derivative of repository-recorded AI candidates; external inputs none; legal/content-similarity review not complete; no independent license asserted.'})
refs=[]
for p in sorted((ROOT/'assets/multi-cast-loop/references').iterdir()):
 raw=p.read_bytes();refs.append({'path':str(p.relative_to(ROOT)),'source_branch':'origin/codex/lc-visual-design','source_commit':'2b62a192ad43e23c806d029b353d49da61576ae2','sha256':hashlib.sha256(raw).hexdigest(),'approval':'unapproved historical concept; not a formal story actor'})
rejected=[]
for name,reason in [('MCAhe-v1-cross-row.png','No empty horizontal boundary between top feet and bottom ears at alpha>12.'),('MCAhe-v3-cross-column.png','Square re-layout fixed row spacing but brought adult tail across equal column boundary; final uses v2 explicit rectangles.'),('MCCatCandidate-v1-overlapping-tail.png','Teen tail extended into adjacent young-adult region; revised compact vertical tails.'),('MCMumu-r1-upward-gaze.png','Round1 independent Critic found upward gaze prevented eye contact. One bounded imagegen face/head correction; body poses retained.')]:
 p=ROOT/'assets/multi-cast-loop/rejected'/name; rejected.append({'path':str(p.relative_to(ROOT)),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'reason':reason,'used_in_app':False})
manifest={'schema_version':1,'task':'MULTI-CAST-LOOP','issue':18,'base_commit':'30d60007ca43431a740c093f17c75a5e75dc0fb6','created_utc':'2026-10-28','agent':'/root/multicast_assets','started_utc':'2026-10-28T06:01:42Z','completed_utc':'2026-10-28T06:30:57Z','observed_elapsed_seconds':1701,'observed_work_intervals':[{'start':'2026-10-28T06:01:42Z','end':'2026-10-28T06:24:31Z','seconds':1369},{'start':'2026-10-28T06:25:25Z','end':'2026-10-28T06:30:57Z','seconds':332}],'generator':{'tool':'image_gen.imagegen','model':'not_returned_by_tool','generation_count':10,'fallback_used':False},'approval':{'formal_art_approval':False,'human_visual_review':False,'legal_review_complete':False},'provenance':{'identity_references':['LifeCrossroads/App/Assets.xcassets/StoryCast.imageset/story-cast.png','LifeCrossroads/App/Assets.xcassets/VL2Companions.imageset/VL2Companions.png'],'external_art_inputs':[],'originals_retained':True,'copy_policy':'All PNG files are byte-identical copies of tool output. PIL was used ONLY for read-only alpha/dimension inspection. Runtime may crop source rectangles.'},'assets':assets,'historical_references':refs,'rejected_attempts':rejected,'known_limitations':['Candidate cat ear-notch and dog anatomical ear-side anchors require independent/Owner confirmation; not identity-lock approved.','Cheng mature visual variant is not an assertion of a documented birth year.','Source-asset inspection does not prove native composition, accessibility or child comprehension.']}
(ROOT/'docs/multi-cast-loop/asset-manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
text=['# MULTI-CAST-LOOP 生成提示','', '工具：內建 image_gen.imagegen；所有提示均為原創，僅使用 repo 舊素材作參照。', '','十次生成／修正，六張 final 圖集；四個未採用候選保留於 rejected。','']
for key,prompt in prompts.items():text+=['## '+key,'','```text',prompt,'```','']
(ROOT/'docs/multi-cast-loop/prompts.md').write_text('\n'.join(text))
print(json.dumps({'assets':len(assets),'cells':sum(len(a['cells']) for a in assets),'source_bytes_identical':True,'all_internal_cut_boundaries_empty_above_alpha12':True,'rejected_preserved':len(rejected)},indent=2))
