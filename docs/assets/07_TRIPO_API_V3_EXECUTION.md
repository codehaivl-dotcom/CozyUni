# CozyUni — Tripo API v3 Image-to-3D Execution v1.0

Status: **IMPLEMENTATION AUTHORITY / BILLABLE EXTERNAL SERVICE / EXPLICIT EXECUTION ONLY**

Official documentation authority: `https://developers.tripo3d.ai/en/docs`

This file defines the exact Tripo API path allowed for CozyUni MVP asset conversion. It exists so an agent can clone the repository, receive a user-provided API key locally, and execute image -> 3D without inventing endpoints, fields, versions, retry behavior, or secret handling.

## 1. Security contract

The API key is never committed to Git.

Required environment variable:

```text
TRIPO_API_KEY
```

Local setup examples:

```bash
# bash/zsh
export TRIPO_API_KEY="..."

# PowerShell
$env:TRIPO_API_KEY="..."
```

Rules:
- do not write the key into source, JSON, markdown, screenshots, logs, commits, issue text, or generated task manifests;
- do not pass the key as a CLI argument because shell history may persist it;
- `.env` files remain ignored;
- if the key is missing, STOP with `TRIPO_KEY_MISSING`;
- if authentication fails, STOP with the returned API error; do not ask the agent to fabricate another credential.

## 2. Locked API base and authentication

Current official API version used by this repository:

```text
Base URL: https://openapi.tripo3d.ai/v3
Authorization: Bearer ${TRIPO_API_KEY}
```

Success responses use `code: 0`. Non-zero API codes are errors even if HTTP transport succeeded.

## 3. MVP generation route

For approved CozyUni concept images, the default production route is the official P-Series Image-to-3D endpoint:

```text
POST /v3/generation/image-to-model
```

Pinned model for the MVP pipeline:

```text
P1-20260311
```

Reason: official Tripo documentation identifies P Series/P1 as optimized for low-poly output and game pipelines. Do not silently change this pin because a newer model exists. A model change requires a documented pipeline revision and A/B validation in the canonical Godot camera.

## 4. Input upload

For local concept images <= 20 MB, upload with:

```text
POST /v3/files
Content-Type: multipart/form-data
field name: file
```

Accepted image formats for the standard upload route are PNG/JPEG according to the current file-upload documentation.

The response must provide:

```text
data.file_token
```

Use that token as the `input` for image-to-model.

For large-file workflows, Tripo also documents `POST /v3/files/presign`, but CozyUni concept images should normally stay below the normal image limit. Agents must not switch upload workflows without a real need.

## 5. Image-to-model request

Default MVP request fields:

```json
{
  "input": "file_...",
  "model": "P1-20260311",
  "face_limit": 10000,
  "texture": true,
  "pbr": true,
  "texture_quality": "detailed",
  "auto_size": true,
  "export_uv": true
}
```

`face_limit` profiles used by the repository tool:
- `small` = 5,000 faces
- `common` = 10,000 faces
- `hero` = 20,000 faces

20,000 is the documented maximum for P1. The profile is an output budget, not an instruction to consume maximum geometry.

Do not use `extreme` texture quality in MVP automation. It generates 8K textures and costs additional credits; mobile runtime assets require evidence before such a setting is justified.

Optional fields such as `model_seed`, `texture_seed`, `enable_image_autofix`, `texture_alignment`, or `orientation` may only be used when the exact task requires them and they are logged. Do not invent undocumented values.

## 6. Async task lifecycle

Generation returns:

```text
data.task_id
```

Poll only with the documented endpoint:

```text
GET /v3/tasks/{task_id}
```

Recognized statuses:
- `queued`
- `running`
- `success`
- `failed`
- `cancelled`

On `failed`, preserve `error_code` / `error_message` and STOP. Do not automatically create another billable task unless the current MVP step explicitly authorizes a retry.

## 7. Download immediately

On `success`, read:

```text
data.output.model_url
```

Download the model immediately. The official Quick Start states generated model URLs expire after about five minutes.

The repository helper therefore downloads the GLB as part of the same `generate` command after a successful task.

Do not treat a temporary CDN URL as a persistent production asset reference.

## 8. Credit / cost control

Before a render batch, the agent may check:

```text
GET /v3/account/balance
```

The tool defaults to dry-run for billable generation. A real image-to-3D request requires explicit `--execute`.

In addition, the agent must obey:

```text
docs/MVP_EXECUTION_PLAYBOOK.md
docs/data/mvp_execution_v1.json
```

A valid API key does **not** authorize bulk rendering.

Only assets currently classified `RENDER_NOW` / explicitly admitted by the active MVP step may be submitted.

If the requested generation exceeds the active step budget, STOP with:

```text
RENDER_BUDGET_EXCEEDED
```

## 9. Error handling

Current documented handling:
- HTTP 429 / documented rate limit: exponential retry allowed;
- HTTP 500 service error: bounded retry allowed;
- 400/401/403: do not blindly retry;
- API code `2010`: insufficient credits -> STOP;
- API code `2002`: unsupported parameter -> STOP and compare with current official docs;
- deprecated/unknown model or request field -> `TRIPO_DOC_MISMATCH`.

The repository helper uses bounded retry for transport/rate-limit class errors only.

## 10. Local command authority

Repository helper:

```text
tools/tripo_v3.py
```

Supported commands:

```bash
python tools/tripo_v3.py balance
python tools/tripo_v3.py upload --file path/to/image.png
python tools/tripo_v3.py task --task-id task_...
python tools/tripo_v3.py generate --asset-id AST-071 --file path/to/image.png --profile common
python tools/tripo_v3.py generate --asset-id AST-071 --file path/to/image.png --profile common --execute
```

Without `--execute`, `generate` performs validation and prints the planned billable request but does not create a generation task.

## 11. Output convention

Unaccepted Tripo output is local working data and is not canonical asset truth.

Default local output:

```text
generated/tripo/<ASSET_ID>/
```

The helper stores:
- downloaded `.glb` after success;
- sanitized task log JSON without API key;
- request settings used;
- task ID;
- credits consumed when returned.

Only after mesh/material/scale/performance/Godot-camera QA may an accepted result be copied into a production asset path.

## 12. Required per-asset evidence

Each accepted 3D conversion must record:

```text
Asset ID
Concept image path
Canonical generation source
Tripo docs route
Model pin
Face profile
Request settings
Task ID
Credits consumed
Downloaded GLB path
Mesh QA
Texture/PBR QA
Godot import QA
Scale/pivot QA
Canonical-camera screenshot
PASS / RETRY / REJECT
```

No generation log = not accepted.

## 13. Hard stop rules

STOP instead of improvising when:
- `TRIPO_API_KEY` missing;
- asset is not admitted by current MVP step;
- render budget exhausted;
- concept image/reference has not passed approval;
- required request behavior differs from current official Tripo docs;
- response lacks documented task/output fields;
- output is poor and retry has not been explicitly admitted.

The API is an execution tool, not permission to render the entire asset inventory.
