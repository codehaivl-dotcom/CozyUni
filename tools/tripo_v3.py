#!/usr/bin/env python3
"""Minimal stdlib Tripo v3 client for CozyUni asset production.

Security:
- reads TRIPO_API_KEY only from environment
- never prints the key
- billable generation is dry-run unless --execute is passed

Official API authority:
https://developers.tripo3d.ai/en/docs
"""

from __future__ import annotations

import argparse
import json
import mimetypes
import os
import pathlib
import sys
import time
import urllib.error
import urllib.request
import uuid
from typing import Any

BASE_URL = "https://openapi.tripo3d.ai/v3"
MODEL_P1 = "P1-20260311"
PROFILES = {"small": 5000, "common": 10000, "hero": 20000}
TERMINAL = {"success", "failed", "cancelled"}


class TripoError(RuntimeError):
    pass


def _key() -> str:
    value = os.getenv("TRIPO_API_KEY", "").strip()
    if not value:
        raise TripoError("TRIPO_KEY_MISSING: set TRIPO_API_KEY in the local environment")
    return value


def _headers(*, json_body: bool = False) -> dict[str, str]:
    headers = {"Authorization": f"Bearer {_key()}"}
    if json_body:
        headers["Content-Type"] = "application/json"
    return headers


def _decode_response(response: Any) -> dict[str, Any]:
    raw = response.read().decode("utf-8")
    try:
        payload = json.loads(raw)
    except json.JSONDecodeError as exc:
        raise TripoError(f"TRIPO_BAD_RESPONSE: invalid JSON: {exc}") from exc
    if not isinstance(payload, dict):
        raise TripoError("TRIPO_BAD_RESPONSE: top-level response is not an object")
    if int(payload.get("code", -1)) != 0:
        code = payload.get("code")
        message = payload.get("message", "unknown error")
        suggestion = payload.get("suggestion")
        suffix = f"; suggestion={suggestion}" if suggestion else ""
        raise TripoError(f"TRIPO_API_ERROR[{code}]: {message}{suffix}")
    return payload


def _request(
    method: str,
    path: str,
    *,
    data: bytes | None = None,
    headers: dict[str, str] | None = None,
    retries: int = 3,
) -> dict[str, Any]:
    url = f"{BASE_URL}{path}"
    req = urllib.request.Request(url, data=data, headers=headers or _headers(), method=method)
    for attempt in range(retries + 1):
        try:
            with urllib.request.urlopen(req, timeout=120) as response:
                return _decode_response(response)
        except urllib.error.HTTPError as exc:
            body = exc.read().decode("utf-8", errors="replace")
            if exc.code in (429, 500) and attempt < retries:
                time.sleep(2**attempt)
                continue
            try:
                payload = json.loads(body)
            except json.JSONDecodeError:
                payload = {}
            code = payload.get("code", exc.code)
            message = payload.get("message", body[:400] or exc.reason)
            suggestion = payload.get("suggestion")
            suffix = f"; suggestion={suggestion}" if suggestion else ""
            raise TripoError(f"TRIPO_HTTP_ERROR[{exc.code}/{code}]: {message}{suffix}") from exc
        except urllib.error.URLError as exc:
            if attempt < retries:
                time.sleep(2**attempt)
                continue
            raise TripoError(f"TRIPO_NETWORK_ERROR: {exc.reason}") from exc
    raise TripoError("TRIPO_NETWORK_ERROR: retries exhausted")


def balance() -> dict[str, Any]:
    return _request("GET", "/account/balance")


def upload_file(file_path: pathlib.Path) -> str:
    if not file_path.is_file():
        raise TripoError(f"INPUT_NOT_FOUND: {file_path}")
    size = file_path.stat().st_size
    if size > 20 * 1024 * 1024:
        raise TripoError("INPUT_TOO_LARGE: CozyUni image upload helper is limited to 20 MB")
    suffix = file_path.suffix.lower()
    if suffix not in {".png", ".jpg", ".jpeg"}:
        raise TripoError("UNSUPPORTED_IMAGE_FORMAT: use PNG or JPEG for standard Tripo upload")

    boundary = f"----CozyUniTripo{uuid.uuid4().hex}"
    mime = mimetypes.guess_type(file_path.name)[0] or "application/octet-stream"
    file_bytes = file_path.read_bytes()
    prefix = (
        f"--{boundary}\r\n"
        f'Content-Disposition: form-data; name="file"; filename="{file_path.name}"\r\n'
        f"Content-Type: {mime}\r\n\r\n"
    ).encode("utf-8")
    body = prefix + file_bytes + f"\r\n--{boundary}--\r\n".encode("utf-8")
    headers = _headers()
    headers["Content-Type"] = f"multipart/form-data; boundary={boundary}"
    result = _request("POST", "/files", data=body, headers=headers)
    token = str((result.get("data") or {}).get("file_token", ""))
    if not token.startswith("file_"):
        raise TripoError("TRIPO_BAD_RESPONSE: upload succeeded without documented file_token")
    return token


def create_image_to_model(file_token: str, face_limit: int) -> dict[str, Any]:
    if not file_token.startswith("file_"):
        raise TripoError("INVALID_FILE_TOKEN")
    if not 50 <= face_limit <= 20000:
        raise TripoError("INVALID_FACE_LIMIT: documented P1 range is 50..20000")
    payload = {
        "input": file_token,
        "model": MODEL_P1,
        "face_limit": face_limit,
        "texture": True,
        "pbr": True,
        "texture_quality": "detailed",
        "auto_size": True,
        "export_uv": True,
    }
    data = json.dumps(payload, separators=(",", ":")).encode("utf-8")
    result = _request("POST", "/generation/image-to-model", data=data, headers=_headers(json_body=True))
    task_id = str((result.get("data") or {}).get("task_id", ""))
    if not task_id.startswith("task_"):
        raise TripoError("TRIPO_BAD_RESPONSE: create succeeded without documented task_id")
    return {"task_id": task_id, "request": payload}


def query_task(task_id: str) -> dict[str, Any]:
    if not task_id.startswith("task_"):
        raise TripoError("INVALID_TASK_ID")
    return _request("GET", f"/tasks/{task_id}")


def wait_for_task(task_id: str, *, poll_seconds: float = 3.0, timeout_seconds: float = 900.0) -> dict[str, Any]:
    deadline = time.monotonic() + timeout_seconds
    last_progress = -1
    while True:
        payload = query_task(task_id)
        data = payload.get("data") or {}
        status = str(data.get("status", ""))
        progress = int(data.get("progress", 0) or 0)
        if progress != last_progress:
            print(f"task={task_id} status={status} progress={progress}%", file=sys.stderr)
            last_progress = progress
        if status in TERMINAL:
            if status != "success":
                code = data.get("error_code")
                message = data.get("error_message", status)
                raise TripoError(f"TRIPO_TASK_{status.upper()}[{code}]: {message}")
            return payload
        if time.monotonic() >= deadline:
            raise TripoError(f"TRIPO_TASK_TIMEOUT: {task_id}")
        time.sleep(poll_seconds)


def download_url(url: str, output_path: pathlib.Path) -> None:
    if not url.startswith("https://"):
        raise TripoError("TRIPO_BAD_RESPONSE: model_url is not HTTPS")
    output_path.parent.mkdir(parents=True, exist_ok=True)
    req = urllib.request.Request(url, method="GET")
    try:
        with urllib.request.urlopen(req, timeout=180) as response, output_path.open("wb") as target:
            while True:
                chunk = response.read(1024 * 1024)
                if not chunk:
                    break
                target.write(chunk)
    except urllib.error.URLError as exc:
        raise TripoError(f"MODEL_DOWNLOAD_FAILED: {exc}") from exc


def sanitize_asset_id(asset_id: str) -> str:
    safe = "".join(ch for ch in asset_id if ch.isalnum() or ch in "-_" )
    if not safe or safe != asset_id:
        raise TripoError("INVALID_ASSET_ID: use letters, digits, dash, underscore only")
    return safe


def generate(args: argparse.Namespace) -> int:
    asset_id = sanitize_asset_id(args.asset_id)
    image_path = pathlib.Path(args.file).expanduser().resolve()
    face_limit = PROFILES[args.profile]
    planned = {
        "asset_id": asset_id,
        "input_file": str(image_path),
        "endpoint": f"{BASE_URL}/generation/image-to-model",
        "model": MODEL_P1,
        "profile": args.profile,
        "face_limit": face_limit,
        "texture": True,
        "pbr": True,
        "texture_quality": "detailed",
        "auto_size": True,
        "export_uv": True,
        "billable": True,
    }
    if not image_path.is_file():
        raise TripoError(f"INPUT_NOT_FOUND: {image_path}")
    if image_path.stat().st_size > 20 * 1024 * 1024:
        raise TripoError("INPUT_TOO_LARGE: use an approved upload workflow")

    if not args.execute:
        print(json.dumps({"dry_run": True, "plan": planned}, indent=2))
        print("No Tripo generation task created. Re-run with --execute after the active MVP step admits this render.")
        return 0

    _key()  # fail before upload if the key is absent
    file_token = upload_file(image_path)
    created = create_image_to_model(file_token, face_limit)
    task_id = created["task_id"]
    task_payload = wait_for_task(task_id, poll_seconds=args.poll_seconds, timeout_seconds=args.timeout)
    task_data = task_payload.get("data") or {}
    output = task_data.get("output") or {}
    model_url = str(output.get("model_url", ""))
    if not model_url:
        raise TripoError("TRIPO_BAD_RESPONSE: successful task has no output.model_url")

    output_dir = pathlib.Path(args.output_dir) / asset_id
    output_dir.mkdir(parents=True, exist_ok=True)
    model_path = output_dir / f"{asset_id}_{task_id}.glb"
    download_url(model_url, model_path)

    log = {
        "asset_id": asset_id,
        "source_image": str(image_path),
        "api_base": BASE_URL,
        "endpoint": "/generation/image-to-model",
        "model": MODEL_P1,
        "profile": args.profile,
        "face_limit": face_limit,
        "request": created["request"],
        "task_id": task_id,
        "status": task_data.get("status"),
        "credits_consumed": task_data.get("credits_consumed"),
        "created_at": task_data.get("created_at"),
        "completed_at": task_data.get("completed_at"),
        "downloaded_model": str(model_path),
    }
    log_path = output_dir / f"{asset_id}_{task_id}.json"
    log_path.write_text(json.dumps(log, indent=2), encoding="utf-8")
    print(json.dumps(log, indent=2))
    return 0


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="CozyUni Tripo v3 helper")
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("balance", help="Query Tripo credit balance")

    upload = sub.add_parser("upload", help="Upload one PNG/JPEG and print file_token")
    upload.add_argument("--file", required=True)

    task = sub.add_parser("task", help="Query one Tripo task")
    task.add_argument("--task-id", required=True)

    gen = sub.add_parser("generate", help="Image-to-3D; dry-run unless --execute")
    gen.add_argument("--asset-id", required=True)
    gen.add_argument("--file", required=True)
    gen.add_argument("--profile", choices=sorted(PROFILES), default="common")
    gen.add_argument("--output-dir", default="generated/tripo")
    gen.add_argument("--poll-seconds", type=float, default=3.0)
    gen.add_argument("--timeout", type=float, default=900.0)
    gen.add_argument("--execute", action="store_true", help="Actually create a billable Tripo task")
    return parser


def main() -> int:
    args = _parser().parse_args()
    try:
        if args.command == "balance":
            print(json.dumps(balance(), indent=2))
            return 0
        if args.command == "upload":
            token = upload_file(pathlib.Path(args.file).expanduser().resolve())
            print(json.dumps({"file_token": token}, indent=2))
            return 0
        if args.command == "task":
            print(json.dumps(query_task(args.task_id), indent=2))
            return 0
        if args.command == "generate":
            return generate(args)
        raise TripoError(f"UNKNOWN_COMMAND: {args.command}")
    except TripoError as exc:
        print(str(exc), file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
