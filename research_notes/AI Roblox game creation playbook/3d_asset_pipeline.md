# AI-assisted 3D asset pipeline for Roblox (generate, clean in Blender, auto-import via Open Cloud)

Research date: 2026-10-07. All prices and limits are as read from live pages on that date unless marked otherwise. Items marked "(unverified)" or placed under Inferences come from reasoning or general knowledge, not a fetched source.

## Q1. Text-to-3D vs image-to-3D: which tools, what they cost, what settings, how to keep a consistent style

### Takeaway
Meshy and Tripo both have documented, credit-priced REST APIs with game-relevant controls (remesh/face limits, quad output, low-poly modes, PBR toggles), which makes them the easiest to drive from an agent. Rodin/Hyper3D is reachable mainly through third-party resellers or Blender MCP; its first-party API pricing was not confirmed. Image-to-3D costs more per call than text-to-3D on both platforms, but for a consistent house style it is the better route: generate 2D concept images in one locked style first, then convert each image to 3D.

### Cited Findings
**Meshy (API, credit system)**
- Meshy API credit costs: Text to 3D Preview 20 credits (mesh only). Text to 3D Refine (texturing) 10 credits at 2K/4K, 15 credits at 8K. Image to 3D 20 credits mesh-only or 30 credits with 2K textures. Multi-Image to 3D 20/30 credits. Retexture 10 (2K/4K) or 15 (8K). Remesh 5. UV Unwrap 5. Auto-rigging 5 per request. Animation 3 per action (up to 10 actions per request). Ultra geometry surcharge +5 credits on meshy-7.1 at 2K/4K — [Meshy API pricing](https://docs.meshy.ai/en/api/pricing)
- Model versions listed: meshy-7.1 (latest), meshy-6, meshy-6-lite, meshy-t2. "meshy-5" retires Oct 10, 2026 and the "lowpoly" model retires Oct 30, 2026. Do not build the pipeline on either retiring model — [Meshy API pricing](https://docs.meshy.ai/en/api/pricing)
- Credits are prepaid: "Purchase API credits from your subscription settings before making API requests." The page gives no dollar price per credit — [Meshy API pricing](https://docs.meshy.ai/en/api/pricing)

**Tripo (H3.1 model, API)**
- Tripo H3.1 costs: Text to 3D is 10 credits with no texture, 20 with standard texture, 30 with detailed texture. Image to 3D and Multiview to 3D are 20, 30 and 40 credits for the same tiers. Modifiers: detailed geometry +20, quad mesh +5, smart low-poly +10, generate in parts +20 — [Tripo H3.1 docs](https://developers.tripo3d.com/en/models/v3-1)
- Game-relevant parameters: `face_limit` ("Adaptive limit for output mesh polygons"), `quad` ("Quad mesh output (forces FBX format)"), `smart_low_poly`, `texture_quality` (standard or detailed), `pbr` ("Enable PBR materials (default: true)"), `geometry_quality` (standard or detailed/Ultra). Concurrency limit: "3 parallel tasks" — [Tripo H3.1 docs](https://developers.tripo3d.com/en/models/v3-1)
- Third-party price: $1 per 100 credits, with 2,000 free credits for new API users. The same source says Smart Mesh costs 30 credits, which conflicts with the official "+10" for smart low-poly. These may be different features (a standalone Smart Mesh task vs a low-poly flag), but treat the third-party number as unconfirmed — [Costbench/Tripo summary via search](https://www.costbench.com/software/ai-3d-generation/tripo-ai/); contradicted by [Tripo H3.1 docs](https://developers.tripo3d.com/en/models/v3-1)

**Rodin / Hyper3D**
- Reseller price for Hyper3D Gen2: $0.80 per request, pay as you go — [EmpirioLabs](https://empiriolabs.ai/models/hyper3d-gen2). Layer.ai lists 30 credits per generation — [Layer.ai](https://www.layer.ai/models/hyper3d-rodin-gen-2). Both are resellers, not Hyper3D itself.
- Blender MCP (ahujasid) has a `generate_3d` tool that imports models from Tripo, Hunyuan3D or Hyper3D Rodin straight into the open Blender scene, so the generate and clean steps can run in one agent session — [blender-mcp GitHub](https://github.com/ahujasid/blender-mcp)

**Roblox Cube (first-party)**
- GenerationService uses Roblox's Cube 3D model to generate objects from text prompts in-experience. `GenerateModelAsync` takes `inputs` (a `TextPrompt` plus an optional `Image` for conditioning) and a `schema` (a predefined "Car5" or "Body1", or a custom `SchemaDefinition`). `GenerateMeshAsync` is deprecated. It requires the "DynamicGeneration" capability — [GenerationService API](https://create.roblox.com/docs/reference/engine/classes/GenerationService)
- `GenerateModelAsync` must be called from server scripts. An optional max triangle count is available, but no number is published — [Model generation guide](https://create.roblox.com/docs/parts/model-generation); [search summary of GenerationService docs](https://create.roblox.com/docs/reference/engine/classes/GenerationService/GenerateModelAsync)

### Inferences
- **Recommended route for a consistent style (e.g. colourful stud/brick toy style):**
  1. Write one locked style prompt block for every asset, for example: "chunky toy brick style, flat saturated primary colours, bevelled edges, visible round studs on top faces, no fine detail, no text, plain white background, 3/4 view, single object centred."
  2. Make one 2D master reference sheet with an image model, then generate each asset image from that reference, using image-to-image or a reference image so the palette and shapes stay the same across the set.
  3. Run image-to-3D (Tripo or Meshy) on each image. Use Multi-Image or Multiview when front and side views are available, since that improves the shape.
  - This costs about 20 to 40 credits per asset, against 10 to 30 for text-to-3D, but text-to-3D drifts in style from asset to asset.
- **Settings for stylised toy assets:**
  - Turn PBR off (Tripo `pbr=false`) or ignore the metal and roughness maps, and use base colour only. Flat colours read better on Roblox and avoid extra texture memory.
  - Request low poly: Tripo `smart_low_poly` or `face_limit` of about 2k to 8k, Meshy Remesh to a target count.
  - Quad output only matters if a human will edit or rig the model. Roblox triangulates on import, so triangles are fine for static props.
- **Cheaper alternative to textures for a brick style:** flat colours can be done with vertex colours or a small palette-atlas texture (for example 256 px), and the studs can be a separate reusable mesh or a texture. This keeps unique texture memory very low.
- **Cost per asset:** Tripo at the third-party rate of $1 per 100 credits works out to roughly $0.20 to $0.70 per asset (image-to-3D, textured, low-poly). Rodin through a reseller is about $0.80.

### Gaps
- No official dollar price per credit for Meshy API credits was found (the pricing page gives credits only), and no official Hyper3D first-party API price.
- No independent 2025-2026 quality benchmark comparing stylised game-ready output across Meshy, Tripo, Rodin and Cube was fetched. Quality rankings would need a hands-on test with the same 5 prompts on each tool.
- No published Cube triangle cap, quota or cost, and no confirmation that Cube outputs can be saved as permanent assets.
- Tripo's free-credit and price-per-credit figures come only from a third-party aggregator.

## Q2. Roblox mesh import limits and common import problems

### Takeaway
The hard cap is 20,000 triangles per individual mesh. Textures render at up to 4096x4096, but a UV texture space is limited to 1024x1024, so plan for 1024. FBX and glTF both carry multi-mesh hierarchies, PBR textures and vertex colours. The importer defaults to importing a single Model with the pivot set to scene origin.

### Cited Findings
- "Individual meshes can not exceed 20,000 triangles." Avatar items have separate budgets — [Mesh specifications](https://create.roblox.com/docs/art/modeling/specifications)
- Geometry rules:
  - Geometry must be watertight "without exposed holes or backfaces".
  - "Meshes must be in quads where possible" (no n-gons).
  - Meshes need some volume, so no zero-thickness geometry.
  - Rigging allows at most 4 bone influences per vertex, and the root joint must sit at 0,0,0.
  - "Only a single animation track can be exported with a mesh or model".
  - Source: [Mesh specifications](https://create.roblox.com/docs/art/modeling/specifications)
- Texture limits: "Roblox supports up to 4096×4096 pixel texture resolutions (4K)" but "supports up to 1024×1024 pixel spaces for texture maps." Recommended sizes scale with object size, from 256×256 for small (5×5 stud) objects to 1024×1024 for 20×20 stud objects. The engine streams lower-quality mips first and ramps up based on device resources — [Texture specifications](https://create.roblox.com/docs/art/modeling/texture-specifications)
- SurfaceAppearance PBR maps: Albedo (RGB), Normal (RGB, "Roblox only supports OpenGL format - Tangent Space normal maps"), Roughness, Metalness and Emissive Mask (8-bit grayscale each). Watch the normal-map convention, because some AI tools and bakers default to DirectX — [Texture specifications](https://create.roblox.com/docs/art/modeling/texture-specifications)
- DevForum reports of blurry MeshPart textures relate to textures above 1024 being downscaled — [DevForum: mesh part texture blurry](https://devforum.roblox.com/t/issue-with-mesh-part-texture-being-too-blurry/3868724) (search snippet only; not fully read)
- 3D Importer:
  - Formats: .fbx, .obj and .gltf. ".fbx and .gltf formats support multiple mesh objects and hierarchies, basic and PBR textures, cage mesh objects, rigs, avatar components, animation data, and vertex colors."
  - "Import Only As Model" is on by default (one asset even with many children). Turning it off imports each descendant as an individual asset.
  - "Merge Meshes" combines all MeshParts into one.
  - "Scale Unit" defaults to Studs. "World Forward" and "World Up" are configurable.
  - "Set Pivot to Scene Origin" is on by default. Each object has a "Use Imported Pivot" setting.
  - Each object has an "Ignore Vertex Colors" toggle, off by default.
  - Common warnings include cage mismatches and missing textures.
  - Source: [3D Importer](https://create.roblox.com/docs/art/modeling/3d-importer)

### Inferences
- **Per-asset budget:** keep each MeshPart well under 20k triangles. Toy-style props need about 500 to 5k. Split anything larger into several meshes.
- **Choosing between textures and vertex colours:**
  - Use TextureID (a single colour map) for flat-colour assets.
  - Use SurfaceAppearance only when you need normal, roughness or metal maps. It costs more memory and draw complexity.
  - Vertex colours survive FBX and glTF import (because "Ignore Vertex Colors" is off by default), which makes them a zero-texture option for the brick style.
- **Scale:** export from Blender in metres and set the importer Scale Unit to Metres, or pre-scale the model to studs. A 1-unit mismatch is the most common "giant or tiny model" problem.
- **Pivot:** put the Blender origin at the base centre of each prop so it places cleanly on the ground.

### Gaps
- No primary source fetched on a maximum FBX/GLB file size for the Studio importer itself. The Open Cloud limit is 20 MB (see Q3).
- No official list of importer error strings beyond cage and missing-texture warnings.

## Q3. Open Cloud Assets API, permissions, the 403 problem, and other automatic import routes

### Takeaway
`POST https://apis.roblox.com/assets/v1/assets` with an API key (Assets API: read and write) accepts .fbx, .gltf, .glb, .rbxm and .rbxmx files as **Model** assets up to 20 MB, and images up to 8000x8000 as Decal/Image. You then poll `GET /assets/v1/operations/{id}`. You cannot upload a raw "Mesh" asset type from a file, so 3D content always goes up as a Model. Most 403 errors come from three causes:
- the key is missing the right scope or operations;
- the creator in the request does not match the key owner (user key vs group key);
- the IP allowlist blocks the caller.

### Cited Findings
- Endpoint and request:
  - `POST https://apis.roblox.com/assets/v1/assets`, sent as multipart form data.
  - A `request` field holds JSON with `assetType`, `displayName`, `description` and `creationContext.creator.userId` or `creator.groupId`.
  - A `fileContent` field holds the binary file with the right content-type.
  - Auth header: `x-api-key`. OAuth scopes: `asset:read` and `asset:write`.
  - Source: [Assets API usage guide](https://create.roblox.com/docs/cloud/guides/usage-assets)
- Asset types:
  - **Model** accepts .fbx, .gltf, .glb, .rbxm and .rbxmx (`model/fbx`, `model/gltf+json`, `model/gltf-binary`, `model/x-rbxm`). It "Imports custom 3D models as a Model container."
  - **Mesh** is "Roblox only": "Only content downloaded from Asset delivery API is accepted". No updating.
  - **Decal/Image** accepts .png, .jpeg, .bmp and .tga, "smaller than 8000x8000 pixels". No updating.
  - **Audio** is limited to 7 minutes and 100 uploads per month for ID-verified users (10 per month unverified).
  - General file limit: "file size up to 20 MB".
  - Source: [Assets API usage guide](https://create.roblox.com/docs/cloud/guides/usage-assets)
- Polling: the create call returns an operation ID. Poll `GET https://apis.roblox.com/assets/v1/operations/{operationId}`. The response includes asset metadata and a `moderationState` field — [Assets API usage guide](https://create.roblox.com/docs/cloud/guides/usage-assets). A DevForum contributor notes the first response does not include the full operation data, so you need a separate GET — [DevForum: OpenCloud Assets API](https://devforum.roblox.com/t/opencloud-assets-api/2298007)
- Common errors from the DevForum tutorial thread:
  - 415: add the multipart form-data headers (`bodyFormData.getHeaders()`).
  - 400 with valid params: the asset name was filtered. Names fully flagged by the text filter are rejected; partly flagged names upload with "#" replacements.
  - Use `groupId` or `userId`, never both.
  - The IP allowlist can be `0.0.0.0/0` (open to all, "not recommended").
  - Source: [DevForum: OpenCloud Assets API](https://devforum.roblox.com/t/opencloud-assets-api/2298007)
- Uploading to a group needs "an API key owned by the Group with read and write Asset API permissions". Authentication errors arise if the key is invalid, lacks upload access, "or is from an invalid IP address" — [rblx-open-cloud docs (group)](https://rblx-open-cloud.readthedocs.io/en/latest/guides/group.html)
- A separate "Scope not authorized" case was fixed by giving the key the endpoint's exact scope (`creator-store-product:read`, not `asset:read`). Lesson: scopes are per endpoint — [DevForum: Scope not authorized](https://devforum.roblox.com/t/open-cloud-returns-scope-not-authorized/3949672)
- In-engine upload: AssetService has `CreateAssetAsync(object, assetType, requestParameters)` and `CreateAssetVersionAsync(...)`, both needing the "AssetCreateUpdate" capability. `CreateEditableMeshAsync` and `CreateEditableImageAsync` need "AssetRead". `CreateMeshPartAsync(meshContent, options)` needs "Basic" — [AssetService API](https://create.roblox.com/docs/reference/engine/classes/AssetService)
- Studio MCP tools available in this local environment (from the tool list, not a web source): `insert_asset`, `search_asset`, `upload_image`, `store_image`, `generate_mesh`, `generate_procedural_model`, `generate_texture`, `generate_material`, `segment_mesh` and `execute_luau`. An agent can therefore insert an uploaded asset ID into the open place, or generate meshes in Studio directly, without manual clicking.

### Inferences
- **Recommended automatic import route:**
  1. Blender exports an FBX or GLB.
  2. A script calls `POST /assets/v1/assets` with `assetType: "Model"`.
  3. Poll the operation until `done` and read the `assetId`.
  4. Studio MCP `insert_asset(assetId)`, or `execute_luau` running `InsertService:LoadAsset(assetId)` in Studio.
  5. Re-parent the result into the map and save.
  - This avoids the 3D Importer UI entirely. Uploading as Model also handles multi-mesh files in one call.
- **Checklist for the "User not authenticated" / 403 error (unverified as a single root cause; built from the sources above):**
  1. The key has the Assets API with both read and write operations ticked.
  2. The key owner matches the creator. A user key needs `creator.userId` set to that user's ID. A group key must be created by the group, under the group's API Keys, and needs `creator.groupId`.
  3. The calling IP is in the key's allowlist. Use your public IP, or `0.0.0.0/0` while testing.
  4. The key has not expired or been auto-revoked. Roblox revokes keys that are exposed publicly or unused for long periods (unverified).
  5. The header is exactly `x-api-key`.
- **Moderation:** assets are usable once `moderationState` is approved. The pipeline should poll and not insert assets that are still pending in published builds. No official moderation-delay SLA was found.

### Gaps
- No primary source fetched names the exact string "User not authenticated" with its official cause. The checklist above is a synthesis.
- `CreateAssetAsync` docs fetched did not list the supported `Enum.AssetType` values, or whether it works from a Studio plugin or edit-mode command bar vs live servers. Check this hands-on before relying on it.
- No moderation-time figures and no Open Cloud asset upload rate limits were found.
- "Bulk Import" and packages were not researched within the tool budget.

## Q4. Blender MCP and Blender Python automation for cleanup

### Takeaway
ahujasid's blender-mcp (30k+ stars) exposes `execute_blender_code`, `get_scene_info`, a viewport `look` tool and `generate_3d` (Tripo/Hunyuan3D/Rodin), so an agent can generate, clean and export in one loop. This machine also has a separate Blender MCP server (the `mcp__Blender__*` tools: `execute_blender_code`, viewport screenshots and bundled API/manual docs).

### Cited Findings
- blender-mcp tools:
  - `execute_blender_code` runs Python in live Blender.
  - `look` gives multi-viewport views in solid, material, rendered, wireframe or x-ray mode.
  - `get_scene_info` returns a scene summary.
  - `generate_3d` covers Tripo, Hunyuan3D and Hyper3D Rodin.
  - `search_assets` and `import_asset` cover Poly Haven, Sketchfab and Poly Pizza.
  - Requirements: Blender 3.0+, Python 3.10+ and `uv`. Install the add-on with `uvx mcp-for-blender install-addon`.
  - Source: [blender-mcp GitHub](https://github.com/ahujasid/blender-mcp)
- Known issues:
  - Arbitrary code execution is "potentially dangerous".
  - The UI freezes during asset downloads on the main thread.
  - The socket server has no authentication, so keep it on localhost.
  - `BLENDER_MCP_SAFE_MODE=1` validates scripts before running them.
  - Complex operations need multi-step breakdowns.
  - Source: [blender-mcp GitHub](https://github.com/ahujasid/blender-mcp)

### Inferences
- **Cleanup recipe** (standard bpy operators; not taken from a fetched Roblox source, so verify on the first asset):
  1. Import the GLB with `bpy.ops.import_scene.gltf`.
  2. Join the parts that belong together with `bpy.ops.object.join()`.
  3. Merge by distance with `bpy.ops.mesh.remove_doubles(threshold=0.0001)`.
  4. Recalculate normals outside with `bpy.ops.mesh.normals_make_consistent(inside=False)`.
  5. Add a Decimate modifier (`ratio` chosen so the triangle count is at most your budget, e.g. 5k) and apply it. Check `sum(len(p.vertices)-2 for p in mesh.polygons)` for the triangle count.
  6. Set the origin to the base centre: move the 3D cursor to the bounding-box bottom centre, then `origin_set(type='ORIGIN_CURSOR')`.
  7. Apply scale and rotation with `transform_apply(location=False, rotation=True, scale=True)`.
  8. Optionally bake to a 1024 or 512 base-colour texture (Cycles bake type DIFFUSE, colour only) or convert to a palette.
  9. Export with `bpy.ops.export_scene.fbx(use_selection=True, apply_unit_scale=True, apply_scale_options='FBX_SCALE_ALL', axis_forward='-Z', axis_up='Y', path_mode='COPY', embed_textures=True)`, or export GLB. GLB embeds textures more reliably.
- **Agent QA loop:** after cleanup, use `look`/screenshot plus a triangle-count check, and reject the asset if it is over budget or has holes.

### Gaps
- No fetched source gives Roblox-specific Blender export settings with exact values. The FBX settings above should be verified on the first import.
- The release version and date of blender-mcp were not stated on the page fetched.

## Q5. EditableMesh/EditableImage and Roblox's own generation tools vs external tools

### Takeaway
Roblox Cube (GenerationService) generates text-prompted meshes in-experience from server scripts, with predefined schemas ("Car5", "Body1") or custom part schemas, plus optional image conditioning. It suits runtime or user-generated content. For a curated, style-consistent asset library, external tools plus Blender plus Open Cloud give more control.

### Cited Findings
- GenerationService has `GenerateModelAsync`, `LoadGeneratedMeshAsync` and `SegmentMeshAsync`, needs the "DynamicGeneration" capability, and `GenerateMeshAsync` is deprecated — [GenerationService API](https://create.roblox.com/docs/reference/engine/classes/GenerationService)
- `LoadGeneratedMeshAsync` returns a MeshPart containing an EditableMesh. Articulated objects (such as a car with 4 wheels needing at least 5 MeshParts) use schemas — [GenerationService docs via search](https://create.roblox.com/docs/en-us/reference/engine/classes/GenerationService.md)
- Texture quality was improved: "more coherent and detailed, with less graininess and less pronounced baked-in lighting." The only documented controls are text prompts and bounding boxes, plus an optional max triangle count — [Model generation guide](https://create.roblox.com/docs/parts/model-generation)
- `AssetService:CreateEditableMeshAsync` and `CreateEditableImageAsync` need "AssetRead". `CreateMeshPartAsync` turns mesh content into a MeshPart — [AssetService API](https://create.roblox.com/docs/reference/engine/classes/AssetService)

### Inferences
- Use Cube or Studio MCP `generate_mesh` for quick placeholders and runtime variety.
- Use external tools for hero props that must share one art style, because they accept reference images and offer exact face limits.
- EditableMesh is best for runtime deformation or procedural variation. It is not a substitute for uploaded static assets.

### Gaps
- No documented triangle cap, rate limit, quota, cost or persistence (save-as-asset) behaviour for Cube outputs was found.
- EditableMesh memory limits and publishing rules were not fetched.

## Q6. Performance: mobile-friendly mesh and triangle budgets; unions vs meshes vs parts

### Takeaway
No official Roblox number for total triangles or unique meshes per mobile map was found. The only hard numbers are 20k triangles per mesh and the texture limits. Budgets must be set by profiling.

### Cited Findings
- Per-mesh cap of 20,000 triangles — [Mesh specifications](https://create.roblox.com/docs/art/modeling/specifications)
- The texture streaming engine starts low and ramps up by device. Recommended texture sizes run from 256 to 1024 depending on object size — [Texture specifications](https://create.roblox.com/docs/art/modeling/texture-specifications)

### Inferences
- **Starting budgets (unsourced; general Roblox practice):**
  - Reuse the same MeshId many times rather than many unique meshes, because instances of the same mesh and texture batch and share memory.
  - Aim for small props of 300 to 2k triangles and buildings of 2k to 10k.
  - Keep unique textures at 512 or below, or share one palette atlas across the whole set.
  - Use MeshParts instead of unions for imported art. Unions are CSG (solid modelling) results with their own collision and render cost.
  - Set CollisionFidelity to Box or Hull for decorative props, and use StreamingEnabled.
- **Validation:** test on a low-end phone with the Studio MicroProfiler and the Developer Console memory tab.

### Gaps
- No official or DevForum-sourced numbers were fetched for total scene triangles, draw calls or unique mesh counts on mobile, or for union vs MeshPart cost. This is the biggest remaining gap and needs a targeted follow-up search (e.g. Roblox "performance optimization" docs and DevForum mobile triangle-budget threads).
