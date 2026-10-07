"""Search YouTube for Roblox UI / map-building tutorials and save their transcripts as text."""
import json
import subprocess
import sys
import time
from pathlib import Path

from youtube_transcript_api import YouTubeTranscriptApi

OUT = Path(__file__).parent
QUERIES = {
    "ui": [
        "roblox ui design tutorial",
        "roblox simulator ui tutorial",
        "roblox ui figma tutorial",
        "make your roblox ui look better",
        "roblox cartoony ui tutorial",
        "roblox shop ui tutorial",
        "roblox ui designer tips",
        "roblox ui with ai",
    ],
    "map": [
        "roblox map building tutorial",
        "roblox building tips make your game look better",
        "roblox lobby build tutorial",
        "roblox low poly map tutorial",
        "roblox lighting tutorial make your game look good",
        "roblox simulator map build",
        "roblox terrain tutorial beautiful",
        "roblox build with ai studio",
    ],
}
PER_QUERY = 6


def search(query: str) -> list[dict]:
    cmd = [sys.executable, "-m", "yt_dlp", "--flat-playlist", "--no-warnings", "-J", f"ytsearch{PER_QUERY}:{query}"]
    data = json.loads(subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8").stdout)
    return [
        {"id": e["id"], "title": e.get("title"), "channel": e.get("channel") or e.get("uploader"),
         "views": e.get("view_count"), "duration": e.get("duration")}
        for e in data.get("entries", []) if e.get("id")
    ]


def main() -> None:
    api = YouTubeTranscriptApi()
    index = {}
    for topic, queries in QUERIES.items():
        folder = OUT / topic
        folder.mkdir(exist_ok=True)
        for q in queries:
            for v in search(q):
                if v["id"] in index or (v["duration"] and v["duration"] < 90):
                    continue
                try:
                    text = " ".join(s.text for s in api.fetch(v["id"]))
                except Exception as exc:
                    print("no transcript", v["id"], type(exc).__name__, flush=True)
                    continue
                v["topic"], v["query"] = topic, q
                index[v["id"]] = v
                header = f"TITLE: {v['title']}\nCHANNEL: {v['channel']}\nVIEWS: {v['views']}\nURL: https://www.youtube.com/watch?v={v['id']}\n\n"
                (folder / f"{v['id']}.txt").write_text(header + text, encoding="utf-8")
                print("saved", topic, v["views"], v["title"], flush=True)
                time.sleep(1.5)
    (OUT / "index.json").write_text(json.dumps(index, indent=2), encoding="utf-8")
    print("total", len(index))


if __name__ == "__main__":
    main()
