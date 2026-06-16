#!/usr/bin/env python3

import argparse
import re
import shutil
import sys
from dataclasses import dataclass
from pathlib import Path

DEFAULT_FOUNDATION_VERSION = "0.0.2"
OLD_APP_ID = "com.example.example"

TEXT_SUFFIXES = {
    ".cmake",
    ".cpp",
    ".dart",
    ".h",
    ".html",
    ".java",
    ".json",
    ".kt",
    ".kts",
    ".md",
    ".pbxproj",
    ".plist",
    ".rc",
    ".swift",
    ".txt",
    ".xcconfig",
    ".xml",
    ".yaml",
    ".yml",
}

TEXT_FILE_NAMES = {
    "CMakeLists.txt",
    "Podfile",
}


@dataclass(frozen=True)
class ProjectConfig:
    original_name: str
    package_name: str
    app_id: str
    output_dir: Path
    foundation_version: str = DEFAULT_FOUNDATION_VERSION


def normalize_package_name(project_name: str) -> str:
    name = re.sub(r"(?<=[a-z0-9])(?=[A-Z])", "_", project_name)
    name = re.sub(r"[^A-Za-z0-9]+", "_", name)
    name = re.sub(r"_+", "_", name).strip("_").lower()
    if not re.fullmatch(r"[a-z][a-z0-9_]*", name):
        raise ValueError(
            f"Project name '{project_name}' cannot be converted to a valid Dart package name."
        )
    if "__" in name:
        raise ValueError(f"Generated Dart package name '{name}' contains consecutive underscores.")
    return name


def validate_app_id(app_id: str) -> str:
    if not re.fullmatch(r"[a-zA-Z][a-zA-Z0-9]*(\.[a-zA-Z][a-zA-Z0-9]*)+", app_id):
        raise ValueError(
            f"Bundle id '{app_id}' must use reverse-domain format, e.g. com.company.app."
        )
    return app_id


def normalize_app_id(project_name: str, bundle_id: str = None) -> str:
    if bundle_id:
        return validate_app_id(bundle_id)
    slug = re.sub(r"[^A-Za-z0-9]+", "", project_name).lower()
    if not slug:
        raise ValueError(f"Project name '{project_name}' cannot be converted to an app id.")
    return f"com.example.{slug}"


def copy_template(template_dir: Path, output_dir: Path) -> None:
    if not template_dir.is_dir():
        raise FileNotFoundError(f"Template directory not found: {template_dir}")
    if output_dir.exists():
        raise FileExistsError(f"Target directory already exists: {output_dir}")
    shutil.copytree(
        template_dir,
        output_dir,
        ignore=shutil.ignore_patterns("build", ".dart_tool"),
    )


def rewrite_pubspec(content: str, package_name: str, foundation_version: str) -> str:
    content = re.sub(
        r"^name:\s+example\s*$",
        f"name: {package_name}",
        content,
        flags=re.MULTILINE,
    )
    return re.sub(
        r"(?m)^  flutter_foundation_kit:\n    path: \.\./\n",
        f"  flutter_foundation_kit: ^{foundation_version}\n",
        content,
    )


def rewrite_package_imports(content: str, package_name: str) -> str:
    content = content.replace("package:example/getIt/", f"package:{package_name}/module/getIt/")
    content = content.replace("package:example/route/", f"package:{package_name}/module/route/")
    return content.replace("package:example/", f"package:{package_name}/")


def rewrite_text(content: str, config: ProjectConfig, relative_path: Path) -> str:
    if relative_path.as_posix() == "pubspec.yaml":
        content = rewrite_pubspec(content, config.package_name, config.foundation_version)
    content = rewrite_package_imports(content, config.package_name)
    content = content.replace(OLD_APP_ID, config.app_id)
    return content


def is_text_file(path: Path) -> bool:
    return path.suffix in TEXT_SUFFIXES or path.name in TEXT_FILE_NAMES


def rewrite_project_files(config: ProjectConfig) -> None:
    for path in config.output_dir.rglob("*"):
        if not path.is_file() or not is_text_file(path):
            continue
        try:
            original = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        relative_path = path.relative_to(config.output_dir)
        rewritten = rewrite_text(original, config, relative_path)
        if rewritten != original:
            path.write_text(rewritten, encoding="utf-8")
    move_android_kotlin_package(config.output_dir, config.app_id)


def move_android_kotlin_package(output_dir: Path, app_id: str) -> None:
    old_dir = output_dir / "android/app/src/main/kotlin/com/example/example"
    if not old_dir.exists():
        return
    new_dir = output_dir / "android/app/src/main/kotlin" / Path(*app_id.split("."))
    new_dir.parent.mkdir(parents=True, exist_ok=True)
    if new_dir.exists():
        shutil.rmtree(new_dir)
    shutil.move(str(old_dir), str(new_dir))
    cleanup_empty_parents(output_dir / "android/app/src/main/kotlin/com/example")


def cleanup_empty_parents(path: Path) -> None:
    while path.exists() and path.name != "kotlin":
        try:
            path.rmdir()
        except OSError:
            return
        path = path.parent


def clean_generated_project(output_dir: Path) -> None:
    for relative_path in [
        ".dart_tool",
        "build",
        ".flutter-plugins",
        ".flutter-plugins-dependencies",
        "ios/Flutter/ephemeral",
        "ios/Pods",
        "ios/Podfile.lock",
        "linux/flutter/ephemeral",
        "macos/Flutter/ephemeral",
        "macos/Pods",
        "macos/Podfile.lock",
        "windows/flutter/ephemeral",
        "docs/superpowers",
        "pubspec.lock",
    ]:
        path = output_dir / relative_path
        if path.is_dir():
            shutil.rmtree(path)
        elif path.exists():
            path.unlink()


def reset_feature_log(output_dir: Path) -> None:
    feature_log = output_dir / "FEATURE_LOG.md"
    if not feature_log.exists():
        return
    feature_log.write_text(
        "# 功能记录\n"
        "\n"
        "本文档用于记录当前项目新增或调整的功能。\n"
        "\n"
        "## 使用规则\n"
        "\n"
        "每次新增功能、调整功能入口、接入第三方 SDK、增加页面或新增共享能力后，"
        "都建议在本文档追加一条记录。\n"
        "\n"
        "## 功能列表\n",
        encoding="utf-8",
    )


def generate_project(
    project_name: str,
    template_dir: Path,
    output_root: Path,
    app_id: str = None,
    foundation_version: str = DEFAULT_FOUNDATION_VERSION,
) -> ProjectConfig:
    package_name = normalize_package_name(project_name)
    app_id = normalize_app_id(project_name, app_id)
    output_dir = output_root / project_name
    config = ProjectConfig(
        original_name=project_name,
        package_name=package_name,
        app_id=app_id,
        output_dir=output_dir,
        foundation_version=foundation_version,
    )
    copy_template(template_dir, output_dir)
    rewrite_project_files(config)
    clean_generated_project(output_dir)
    reset_feature_log(output_dir)
    return config


def parse_args(argv):
    parser = argparse.ArgumentParser(
        description="Create a Flutter project from the example template.",
    )
    parser.add_argument("project_name", help="Output project directory name, e.g. helloworldProject")
    parser.add_argument(
        "--bundle-id",
        help="Optional app bundle id, e.g. com.company.helloworld",
    )
    parser.add_argument(
        "--output",
        help="Optional output parent directory. Defaults to the repository parent directory.",
    )
    parser.add_argument(
        "--foundation-version",
        default=DEFAULT_FOUNDATION_VERSION,
        help="flutter_foundation_kit pub version without leading ^",
    )
    return parser.parse_args(argv)


def resolve_output_root(repo_root: Path, output: str = None) -> Path:
    if not output:
        return repo_root.parent
    output_path = Path(output).expanduser()
    if not output_path.is_absolute():
        output_path = repo_root / output_path
    return output_path.resolve()


def main(argv=None) -> int:
    args = parse_args(argv or sys.argv[1:])
    repo_root = Path(__file__).resolve().parents[1]
    try:
        config = generate_project(
            project_name=args.project_name,
            template_dir=repo_root / "example",
            output_root=resolve_output_root(repo_root, args.output),
            app_id=args.bundle_id,
            foundation_version=args.foundation_version,
        )
    except (FileExistsError, FileNotFoundError, OSError, ValueError) as error:
        print(f"Error: {error}", file=sys.stderr)
        return 1

    print(f"Created Flutter project: {config.output_dir}")
    print(f"Dart package name: {config.package_name}")
    print(f"App id: {config.app_id}")
    print("")
    print("Next steps:")
    print(f"  cd {config.output_dir}")
    print("  flutter pub get")
    print("")
    print(
        "Note: flutter pub get requires flutter_foundation_kit to be available "
        "from your configured pub source."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
