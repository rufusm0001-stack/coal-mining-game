"""Retry the chosen map/build tutorial transcripts after the YouTube IP block cools down."""
import json, time
from pathlib import Path
from youtube_transcript_api import YouTubeTranscriptApi

OUT = Path(__file__).parent / "map"
OUT.mkdir(exist_ok=True)
WANT = ["nWTcDzQ3llk", "AkF4S405xBg", "-xQBxTYq2m8", "CippiATeZ54", "0inGfrbe24U", "-DoOf32pkPo",
        "t2oQsu9DKhQ", "naOQTjmFNMQ", "YIyir52FiYo", "7vXk_YqxW-c", "I-AB6pJ-y5g", "vkEXLmRAQgs",
        "Y3eUDs3FFGQ", "0_lkryX-CgM", "6dbvvrM45_o", "eRnnjqVOq7c", "UlvSrWHESwA", "v8vby3iOOX4",
        "HjjPZAFaClE", "Y93DRfB-Deo", "YBSsksqfxo0"]
meta = {r["id"]: r for r in json.load(open(Path(__file__).parent / "map_candidates.json", encoding="utf-8"))}
api = YouTubeTranscriptApi()
for attempt in range(4):
    time.sleep(3600 if attempt == 0 else 2400)
    blocked = False
    for vid in WANT:
        if (OUT / f"{vid}.txt").exists():
            continue
        try:
            text = " ".join(s.text for s in api.fetch(vid))
        except Exception as exc:
            print("fail", vid, type(exc).__name__, flush=True)
            if type(exc).__name__ in ("IpBlocked", "RequestBlocked"):
                blocked = True
                break
            continue
        m = meta.get(vid, {})
        (OUT / f"{vid}.txt").write_text(f"TITLE: {m.get('title')}\nCHANNEL: {m.get('channel')}\nVIEWS: {m.get('views')}\nURL: https://www.youtube.com/watch?v={vid}\n\n{text}", encoding="utf-8")
        print("saved", vid, m.get("title"), flush=True)
        time.sleep(45)
    if not blocked:
        break
print("done", len(list(OUT.glob('*.txt'))))
