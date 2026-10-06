"""Generate stud-voxel reference images for Meshy. Keys are read from outside the repo.

Usage: python gen_refs.py [--gemini] [--quality low|medium|high] [job ...]
Defaults to OpenAI gpt-image-2 at medium quality (Gemini prepaid credit ran out 2026-10-06).
"""
import base64
import re
import sys
from pathlib import Path

import requests

KEY_FILE = Path(r"C:\Users\rmcd9\Desktop\IdleMedievalArt\api.txt")
OUT = Path(__file__).parent / "refs"

STYLE = (
    "Style: a toy built entirely from small plastic building bricks, every surface covered in a "
    "grid of little round studs, chunky blocky voxel shapes, bright saturated glossy colours, "
    "cheerful and simple like a kids' building-brick set. Single object only, shown whole with a "
    "generous empty margin on every side, 3/4 front view from slightly above, centred, plain flat "
    "light grey background, soft even studio lighting. No text, no letters, no logos, no ground, "
    "no shadow, no base, no other objects."
)

JOBS = {
    "pickaxe_starter": "A classic miner's pickaxe standing perfectly upright: a long straight brown wooden "
    "handle, and on top a curved grey stone pick head shaped like a wide crescent, with two pointed tips "
    "that curve downward on the left and right. It must clearly read as a pickaxe, not a hammer",
    "coal_node": "A chunky lump of coal rock for a mining game: a cluster of dark charcoal-blue stud blocks "
    "stacked into a craggy boulder about as wide as it is tall, with a few small shiny gold blocks embedded "
    "in the surface",
    "minecart": "A small wooden mine cart on four chunky dark wheels with a short pull handle at the front, "
    "heaped full of dark charcoal-blue coal blocks with a few gold blocks",
    "great_furnace": "A giant cheerful furnace machine: a big square brick-red body on short legs, a glowing "
    "orange fire opening at the front, two short round chimneys on top puffing white steam clouds, and "
    "copper pipes curling out of the back",
    "tree_oak": "A round leafy oak tree: a thick brown trunk and a big fluffy rounded canopy made of bright "
    "green blocks in two shades",
    "tree_pine": "A tall pine tree: a brown trunk and three stacked cone-shaped tiers of dark green blocks "
    "getting smaller towards the pointed top",
    "bush": "A small round green bush made of bright green blocks in two shades, with a few red berries",
    "rock_mossy": "A small chunky grey boulder with patches of bright green moss on top",
    "flower_patch": "A small low patch of flowers: short green stems and leaves with bright pink, yellow "
    "and white blossoms",
}


def read_key(provider: str) -> str:
    for line in KEY_FILE.read_text(encoding="utf-8").splitlines():
        if provider in line.lower():
            return re.split(r"\s+-\s+", line.strip())[0].strip()
    sys.exit(f"no {provider} key found")


def generate_gemini(key: str, name: str, subject: str, quality: str) -> Path:
    url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generateContent"
    body = {"contents": [{"parts": [{"text": f"{subject}. {STYLE}"}]}]}
    r = requests.post(url, headers={"x-goog-api-key": key}, json=body, timeout=180)
    if r.status_code != 200:
        raise RuntimeError(f"{name}: HTTP {r.status_code} {r.text[:300]}")
    for part in r.json()["candidates"][0]["content"]["parts"]:
        data = part.get("inlineData") or part.get("inline_data")
        if data:
            path = OUT / f"{name}.png"
            path.write_bytes(base64.b64decode(data["data"]))
            return path
    raise RuntimeError(f"{name}: no image in response")


def generate_openai(key: str, name: str, subject: str, quality: str) -> Path:
    r = requests.post(
        "https://api.openai.com/v1/images/generations",
        headers={"Authorization": f"Bearer {key}"},
        json={"model": "gpt-image-2", "prompt": f"{subject}. {STYLE}", "size": "1024x1024", "quality": quality},
        timeout=300,
    )
    if r.status_code != 200:
        raise RuntimeError(f"{name}: HTTP {r.status_code} {r.text[:300]}")
    path = OUT / f"{name}.png"
    path.write_bytes(base64.b64decode(r.json()["data"][0]["b64_json"]))
    return path


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    args = sys.argv[1:]
    quality = "medium"
    if "--quality" in args:
        quality = args[args.index("--quality") + 1]
    use_gemini = "--gemini" in args
    names = [a for a in args if not a.startswith("--") and a not in ("low", "medium", "high")] or list(JOBS)
    key = read_key("gemini") if use_gemini else read_key("open ai")
    gen = generate_gemini if use_gemini else generate_openai
    for name in names:
        try:
            print("saved", gen(key, name, JOBS[name], quality), flush=True)
        except Exception as exc:  # report and continue with the rest of the batch
            print("FAILED", exc, flush=True)


if __name__ == "__main__":
    main()
