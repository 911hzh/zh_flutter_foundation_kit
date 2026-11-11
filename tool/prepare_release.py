"""Select a stable release version and update its tracked references."""

import json
import os
from pathlib import Path
import re
import urllib.request


def parse_version(value):
    if not re.fullmatch(r"(?:0|[1-9][0-9]*)(?:\.(?:0|[1-9][0-9]*)){2}", value):
        raise ValueError(f"Expected a version like 0.9.1 or 1.0.0, got {value!r}")
    return tuple(map(int, value.split(".")))


def select_version(current, published, requested):
    current = parse_version(current)
    latest = max(
        parse_version(version)
        for version in published
        if re.fullmatch(r"[0-9]+\.[0-9]+\.[0-9]+", version)
    )
    if requested:
        target = parse_version(requested)
        if target <= latest or target < current:
            raise ValueError("Requested version must be newer than pub.dev and at least the version on main")
    else:
        target = current if current > latest else (*latest[:2], latest[2] + 1)
    return ".".join(map(str, target))


def update_version(current, target):
    references = {
        "pubspec.yaml": ("version: " + current, "version: " + target, 1),
        "tool/create_example_project.py": (
            f'DEFAULT_FOUNDATION_VERSION = "{current}"',
            f'DEFAULT_FOUNDATION_VERSION = "{target}"',
            1,
        ),
        "tool/test_create_example_project.py": (
            f"flutter_foundation_kit: ^{current}",
            f"flutter_foundation_kit: ^{target}",
            1,
        ),
        "FOUNDATION_KIT_DETAIL.md": (f"^{current}", f"^{target}", 1),
        "QUICK_PROJECT_README.md": (f"^{current}", f"^{target}", 2),
        "example/FEATURE_LOG.md": (f"^{current}", f"^{target}", 1),
    }
    updates = {}
    for name, (old, new, count) in references.items():
        path = Path(name)
        contents = path.read_text()
        if contents.count(old) != count:
            raise ValueError(f"Version references in {name} do not match {current}")
        updates[path] = contents.replace(old, new)

    changelog = Path("CHANGELOG.md")
    contents = changelog.read_text()
    if not re.search(rf"^## {re.escape(target)}$", contents, re.MULTILINE):
        heading, body = contents.split("\n\n", 1)
        updates[changelog] = f"{heading}\n\n## {target}\n\n- 发布 {target}。\n\n{body}"

    for path, contents in updates.items():
        path.write_text(contents)


def main():
    pubspec = Path("pubspec.yaml").read_text()
    current = re.search(r"^version:[ \t]*(\S+)", pubspec, re.MULTILINE).group(1)
    requested = os.environ.get("REQUESTED_VERSION", "").strip()
    with urllib.request.urlopen(
        "https://pub.dev/api/packages/flutter_foundation_kit", timeout=30
    ) as response:
        published = [entry["version"] for entry in json.load(response)["versions"]]

    target = select_version(current, published, requested)
    needs_pr = target != current
    if needs_pr:
        update_version(current, target)
    with open(os.environ["GITHUB_OUTPUT"], "a") as output:
        print(f"version={target}", file=output)
        print(f"needs_pr={str(needs_pr).lower()}", file=output)


if __name__ == "__main__":
    main()
