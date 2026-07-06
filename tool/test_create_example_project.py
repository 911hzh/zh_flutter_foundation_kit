import shutil
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from create_example_project import (  # noqa: E402
    ProjectConfig,
    clean_generated_project,
    copy_template,
    generate_project,
    normalize_app_id,
    normalize_package_name,
    parse_args,
    resolve_output_root,
    rewrite_project_files,
    validate_app_id,
)


class CreateExampleProjectTests(unittest.TestCase):
    def setUp(self):
        self.temp_dir = Path(tempfile.mkdtemp())
        self.template_dir = self.temp_dir / "example"
        self.output_root = self.temp_dir / "out"
        self.template_dir.mkdir()
        self.output_root.mkdir()

    def tearDown(self):
        shutil.rmtree(self.temp_dir)

    def write_template_file(self, relative_path, content):
        path = self.template_dir / relative_path
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")
        return path

    def test_normalize_package_name_converts_camel_case(self):
        self.assertEqual(
            normalize_package_name("helloworldProject"),
            "helloworld_project",
        )
        self.assertEqual(
            normalize_package_name("Hello-World Project"),
            "hello_world_project",
        )

    def test_normalize_package_name_rejects_invalid_name(self):
        with self.assertRaises(ValueError):
            normalize_package_name("123")
        with self.assertRaises(ValueError):
            normalize_package_name("___")

    def test_normalize_app_id_uses_lowercase_project_slug(self):
        self.assertEqual(
            normalize_app_id("helloworldProject"),
            "com.example.helloworldproject",
        )

    def test_validate_app_id_accepts_custom_bundle_id(self):
        self.assertEqual(
            validate_app_id("com.company.helloworld"),
            "com.company.helloworld",
        )

    def test_validate_app_id_rejects_invalid_bundle_id(self):
        with self.assertRaises(ValueError):
            validate_app_id("com")
        with self.assertRaises(ValueError):
            validate_app_id("com.company.hello-world")

    def test_parse_args_accepts_optional_bundle_id_and_output(self):
        args = parse_args(
            [
                "helloworldProject",
                "--bundle-id",
                "com.company.helloworld",
                "--output",
                "../apps",
            ]
        )

        self.assertEqual(args.project_name, "helloworldProject")
        self.assertEqual(args.bundle_id, "com.company.helloworld")
        self.assertEqual(args.output, "../apps")

    def test_resolve_output_root_uses_repo_parent_by_default(self):
        repo_root = self.temp_dir / "repo"
        repo_root.mkdir()

        self.assertEqual(resolve_output_root(repo_root, None), self.temp_dir)

    def test_resolve_output_root_accepts_custom_output_path(self):
        repo_root = self.temp_dir / "repo"
        repo_root.mkdir()

        self.assertEqual(
            resolve_output_root(repo_root, "../apps"),
            (self.temp_dir / "apps").resolve(),
        )

    def test_copy_template_fails_when_target_exists(self):
        target = self.output_root / "helloworldProject"
        target.mkdir()
        with self.assertRaises(FileExistsError):
            copy_template(self.template_dir, target)

    def test_rewrite_project_files_updates_package_dependency_imports_and_app_id(self):
        target = self.output_root / "helloworldProject"
        shutil.copytree(self.template_dir, target)
        (target / "lib").mkdir()
        (target / "lib" / "main.dart").write_text(
            "import 'package:example/App.dart';\n"
            "import 'package:example/module/getIt/Injection.dart';\n"
            "import 'package:example/route/RouteConfig.dart';\n",
            encoding="utf-8",
        )
        (target / "pubspec.yaml").write_text(
            "name: example\n"
            "dependencies:\n"
            "  flutter_foundation_kit:\n"
            "    path: ../\n",
            encoding="utf-8",
        )
        android = target / "android/app/build.gradle.kts"
        android.parent.mkdir(parents=True)
        android.write_text(
            'namespace = "com.example.example"\n'
            'applicationId = "com.example.example"\n',
            encoding="utf-8",
        )

        config = ProjectConfig(
            original_name="helloworldProject",
            package_name="helloworld_project",
            app_id="com.example.helloworldproject",
            output_dir=target,
        )
        rewrite_project_files(config)

        pubspec = (target / "pubspec.yaml").read_text(encoding="utf-8")
        main_dart = (target / "lib/main.dart").read_text(encoding="utf-8")
        self.assertIn("name: helloworld_project", pubspec)
        self.assertIn("flutter_foundation_kit: ^0.9.0", pubspec)
        self.assertNotIn("path: ../", pubspec)
        self.assertIn("package:helloworld_project/App.dart", main_dart)
        self.assertIn(
            "package:helloworld_project/module/getIt/Injection.dart",
            main_dart,
        )
        self.assertIn(
            "package:helloworld_project/module/route/RouteConfig.dart",
            main_dart,
        )
        self.assertIn("com.example.helloworldproject", android.read_text())

    def test_clean_generated_project_removes_local_artifacts(self):
        target = self.output_root / "helloworldProject"
        target.mkdir()
        for relative_path in [
            ".dart_tool/cache.txt",
            "build/output.txt",
            "ios/Pods/Manifest.lock",
            "ios/Flutter/ephemeral/flutter_lldbinit",
            "ios/Podfile.lock",
            "macos/Flutter/ephemeral/Flutter-Generated.xcconfig",
            "macos/Pods/Manifest.lock",
            "macos/Podfile.lock",
            "linux/flutter/ephemeral/plugin/example/pubspec.yaml",
            "windows/flutter/ephemeral/plugin/example/pubspec.yaml",
            "docs/superpowers/specs/template-design.md",
            "pubspec.lock",
            ".flutter-plugins",
            ".flutter-plugins-dependencies",
        ]:
            file_path = target / relative_path
            file_path.parent.mkdir(parents=True, exist_ok=True)
            file_path.write_text("cache", encoding="utf-8")

        clean_generated_project(target)

        self.assertFalse((target / ".dart_tool").exists())
        self.assertFalse((target / "build").exists())
        self.assertFalse((target / "ios/Pods").exists())
        self.assertFalse((target / "ios/Flutter/ephemeral").exists())
        self.assertFalse((target / "ios/Podfile.lock").exists())
        self.assertFalse((target / "macos/Flutter/ephemeral").exists())
        self.assertFalse((target / "macos/Pods").exists())
        self.assertFalse((target / "macos/Podfile.lock").exists())
        self.assertFalse((target / "linux/flutter/ephemeral").exists())
        self.assertFalse((target / "windows/flutter/ephemeral").exists())
        self.assertFalse((target / "docs/superpowers").exists())
        self.assertFalse((target / "pubspec.lock").exists())
        self.assertFalse((target / ".flutter-plugins").exists())
        self.assertFalse((target / ".flutter-plugins-dependencies").exists())

    def test_generate_project_copies_rewrites_moves_kotlin_package_and_cleans(self):
        self.write_template_file(
            "pubspec.yaml",
            "name: example\n"
            "dependencies:\n"
            "  flutter_foundation_kit:\n"
            "    path: ../\n",
        )
        self.write_template_file("lib/main.dart", "import 'package:example/App.dart';\n")
        self.write_template_file(
            "FEATURE_LOG.md",
            "历史记录中包含 `path: ../`，生成项目不应该带走。\n",
        )
        self.write_template_file(
            "android/app/build.gradle.kts",
            'namespace = "com.example.example"\n'
            'applicationId = "com.example.example"\n',
        )
        self.write_template_file(
            "android/app/src/main/kotlin/com/example/example/MainActivity.kt",
            "package com.example.example\n",
        )
        self.write_template_file(
            "docs/superpowers/specs/template-design.md",
            "`path: ../` should not be copied to generated projects.\n",
        )
        self.write_template_file(
            "linux/flutter/ephemeral/plugin/example/pubspec.yaml",
            "dependency:\n  path: ../\n",
        )
        self.write_template_file("pubspec.lock", "lock")

        config = generate_project(
            project_name="helloworldProject",
            template_dir=self.template_dir,
            output_root=self.output_root,
            app_id="com.company.helloworld",
            foundation_version="1.2.3",
        )

        generated = self.output_root / "helloworldProject"
        self.assertEqual(config.package_name, "helloworld_project")
        self.assertEqual(config.app_id, "com.company.helloworld")
        self.assertTrue(generated.exists())
        self.assertIn(
            "name: helloworld_project",
            (generated / "pubspec.yaml").read_text(encoding="utf-8"),
        )
        self.assertIn(
            "package:helloworld_project/App.dart",
            (generated / "lib/main.dart").read_text(encoding="utf-8"),
        )
        self.assertFalse((generated / "pubspec.lock").exists())
        self.assertFalse((generated / "docs/superpowers").exists())
        self.assertFalse((generated / "linux/flutter/ephemeral").exists())
        self.assertNotIn(
            "path: ../",
            (generated / "FEATURE_LOG.md").read_text(encoding="utf-8"),
        )
        self.assertIn(
            "## 功能列表",
            (generated / "FEATURE_LOG.md").read_text(encoding="utf-8"),
        )
        self.assertFalse(
            (
                generated
                / "android/app/src/main/kotlin/com/example/example/MainActivity.kt"
            ).exists()
        )
        self.assertTrue(
            (
                generated
                / "android/app/src/main/kotlin/com/company/helloworld/MainActivity.kt"
            ).exists()
        )


if __name__ == "__main__":
    unittest.main()
