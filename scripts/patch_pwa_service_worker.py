#!/usr/bin/env python3
"""Write a real PWA service worker into build/web for Android Chrome installability."""

from __future__ import annotations

import re
import sys
from pathlib import Path


def read_cache_version(project_root: Path) -> str:
    pubspec = project_root / "pubspec.yaml"
    text = pubspec.read_text(encoding="utf-8")
    match = re.search(r"^version:\s*(\S+)", text, re.MULTILINE)
    if not match:
        raise SystemExit("Could not read version from pubspec.yaml")
    # Cache name safe segment (e.g. 1.0.0+1 -> 1.0.0-1)
    return re.sub(r"[^a-zA-Z0-9._-]", "-", match.group(1))


def main() -> int:
    project_root = Path(__file__).resolve().parent.parent
    build_web = project_root / "build" / "web"
    template = project_root / "web" / "pwa" / "service_worker.template.js"
    target = build_web / "flutter_service_worker.js"

    if not build_web.is_dir():
        print("build/web not found — run flutter build web first", file=sys.stderr)
        return 1
    if not template.is_file():
        print(f"Missing template: {template}", file=sys.stderr)
        return 1

    version = read_cache_version(project_root)
    content = template.read_text(encoding="utf-8").replace("{{CACHE_VERSION}}", version)
    target.write_text(content, encoding="utf-8", newline="\n")
    print(f"Patched {target} (cache version {version})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
