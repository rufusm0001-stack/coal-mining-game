"""Generate stud-voxel reference images with Gemini. Keys are read from outside the repo."""
import base64
import json
import re
import sys
from pathlib import Path

import requests

KEY_FILE = Path(r"C:\Users\rmcd9\Desktop\IdleMedievalArt\api.txt")
OUT = Path(__file__).parent / "refs"
MODEL = "gemini-2.5-flash-image"

STYLE = (
    "chunky voxel toy style built from small cube blocks with little round studs on the top "
    "surfaces like a building-brick toy, bright saturated colours, simple bold shapes, "
    "3/4 front view, centred with generous margin around it, plain flat light grey background, "
    "soft even lighting, no text, no letters, no ground, no shadow, no other objects"
)

JOBS = {
    "style_pickaxe_stone": "A single stone pickaxe standing upright, chunky grey stone head and a warm brown wooden handle",
    "style_cart_coal": "A single small wooden mine cart on four chunky wheels, heaped full of dark charcoal-blue coal lumps with a few gold flecks, a short pull handle at the front",
    "style_great_furnace": "A single giant cheerful furnace machine for a mine: big round brick-red body with a glowing orange fire mouth, two short chimneys puffing white steam, copper pipes coming out of the back",
    "style_miner_npc": "A single friendly old miner character standing in a relaxed pose, yellow hard hat with a lamp, bushy grey moustache, blue overalls, brown boots",
}


def read_key(provider: str) -> str:
    for line in KEY_FILE.read_text(encoding="utf-8").splitlines():
        if provider in line.lower():
            return re.split(r"\s+-\s+", line.strip())[0].strip()
    sys.exit(f"no {provider} key found")


def gemini_key() -> str:
    return read_key("gemini")


def generate_openai(key: str, name: str, subject: str) -> Path:
    r = requests.post(
        "https://api.openai.com/v1/images/generations",
        headers={"Authorization": f"Bearer {key}"},
        json={"model": "gpt-image-1-mini", "prompt": f"{subject}, {STYLE}.", "size": "1024x1024", "quality": "low"},
        timeout=180,
    )
    if r.status_code != 200:
        raise RuntimeError(f"{name}: HTTP {r.status_code} {r.text[:300]}")
    path = OUT / f"{name}.png"
    path.write_bytes(base64.b64decode(r.json()["data"][0]["b64_json"]))
    return path


def generate(key: str, name: str, subject: str) -> Path:
    url = f"https://generativelanguage.googleapis.com/v1beta/models/{MODEL}:generateContent"
    body = {"contents": [{"parts": [{"text": f"{subject}, {STYLE}."}]}]}
    r = requests.post(url, headers={"x-goog-api-key": key, "Content-Type": "application/json"}, json=body, timeout=180)
    if r.status_code != 200:
        raise RuntimeError(f"{name}: HTTP {r.status_code} {r.text[:300]}")
    for part in r.json()["candidates"][0]["content"]["parts"]:
        data = part.get("inlineData") or part.get("inline_data")
        if data:
            path = OUT / f"{name}.png"
            path.write_bytes(base64.b64decode(data["data"]))
            return path
    raise RuntimeError(f"{name}: no image in response")


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    args = sys.argv[1:]
    use_openai = "--openai" in args
    names = [a for a in args if not a.startswith("--")] or list(JOBS)
    key = read_key("open ai") if use_openai else gemini_key()
    gen = generate_openai if use_openai else generate
    for name in names:
        try:
            print("saved", gen(key, name, JOBS[name]))
        except Exception as exc:  # report and continue with the rest of the batch
            print("FAILED", exc)


if __name__ == "__main__":
    main()
