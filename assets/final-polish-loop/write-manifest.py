"""Write asset evidence only; does not edit any PNG pixels."""
import json
from pathlib import Path
from datetime import datetime, timezone
root=Path(__file__).resolve().parents[2]
audit=json.loads((root/'assets/final-polish-loop/alpha-audit.json').read_text())
items=[]
for idx,(stem,name,age,original,union) in enumerate([
 ('teen13-listening-v1','FPTeen13Listening',13,'exec-903543ba-09b4-4aa8-9ee1-8897b44f550f.png',{'x':114,'y':686,'width':434,'height':501}),
 ('adult32-listening-v1','FPAdult32Listening',32,'exec-7aa15226-0c0a-4672-9a88-f354ac92cf5b.png',{'x':83,'y':656,'width':505,'height':561})]):
 a=dict(audit[idx+2]); a.update({
 'name':name,'kind':'localEditCandidateAtlas','formal_character_id':'mumu','selected_cell_indices':[2],
 'source_original_path':'/Users/macminim4/.codex/generated_images/01a18233-b311-79b1-bace-08cbf9d38e52/'+original,
 'retained_original':a['path'],'byte_identical_to_tool_output':True,
 'prompt_file':'assets/final-polish-loop/prompts/'+stem+'.txt',
 'edit_reference':audit[idx]['path'],'source_commit':'325b69896553fb6c479e415c0c0991e76ef78a26',
 'source_reference_sha256':audit[idx]['sha256'],
 'activity':'requesting/listening unconfirmed help' if age==13 else 'consulting/listening unconfirmed arrangement',
 'age':age,'approved_for_app':False,'draft_integration_allowed':True,
 'approval_scope':'Only bottom-left cell 2 may be considered for Draft integration; no formal Owner art approval. Other generated cells are unreviewed and must not replace current assets.',
 'common_early_late_render_rect_px':union,
 'common_render_rect_coordinate_system':'top-left origin in full 1254x1254 atlas',
 'render_warning':'Original expressing pose and edited listening pose require the SAME fixed crop/transform to avoid independent alpha-trim centering drift. Do not claim native transition PASS before actual capture.',
 'self_review':{'identity':'ACCEPT for candidate: face/round ears/muzzle/tail/clothing retained','props':'ACCEPT: same notebook and stance' if age==13 else 'ACCEPT: same seated stool, paper, shoulder bag','neutral_meaning':'ACCEPT: closed relaxed mouth and lowered hand; no success or agreement shown','native_continuity':'NOT_RUN by asset agent; parent integrates and captures','fine_texture':'PARTIAL: imagegen may alter minor texture or a few edge pixels; not pixel-identical outside edit'}})
 items.append(a)
m={'schema_version':1,'task':'FINAL-POLISH-LOOP','base_commit':'325b69896553fb6c479e415c0c0991e76ef78a26','agent':'/root/final_polish_pose_edits','created_utc':datetime.now(timezone.utc).isoformat(),
 'timebox':{'first_observed_clock_utc':'2026-10-28T11:11:41Z','conservative_start_utc':'2026-10-28T11:10:00Z','maximum_active_wall_minutes':25,'note':'Initial read output was truncated; do not claim conservative start is an exact observed clock.'},
 'generator':{'tool':'image_gen.imagegen','model':'not_returned_by_tool','local_edit_count':2,'targeted_retry_count':0,'fallback_used':False},
 'approval':{'formal_art_approval':False,'human_visual_review':False,'legal_review_complete':False,'rights_note':'Edited existing recorded project AI assets only. No external artwork inputs and no asserted CC license. User authorization covers Draft candidates and integration; formal legal/art release is not claimed.'},
 'provenance':{'references':audit[:2],'external_art_inputs':[],'originals_retained':True,'copy_policy':'Outputs copied byte-for-byte from built-in imagegen. Existing PNG parser used read-only. Runtime fixed source-rectangle cropping is allowed; no pixels edited in Python.'},
 'assets':items,
 'limitations':['Not added to Assets.xcassets by asset agent. Parent owns integration.','No native capture, UI testing, independent Critic, or human approval performed by asset agent.','Only bottom-left selected cells are proposed. The other three generated cells are not adopted.']}
(root/'docs/final-polish-loop/asset-manifest.json').write_text(json.dumps(m,ensure_ascii=False,indent=2)+'\n')
