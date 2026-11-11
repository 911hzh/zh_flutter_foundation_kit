# 从 main 手动发布

在 GitHub Actions 手动运行 **Release from main**。工作流根据输入选择版本，
更新版本文件并提交 PR。版本 PR 合入 `main` 后再次运行，工作流校验该版本，
创建 tag 并自动触发 GitHub OIDC 发布到 pub.dev，最后创建 GitHub Release。

## 一次性配置

1. 打开 [flutter_foundation_kit 管理页](https://pub.dev/packages/flutter_foundation_kit/admin)。
2. 在 **Publishing from GitHub Actions** 中填写并保存。

   | 字段 | 值 |
   | --- | --- |
   | Enable publishing from GitHub Actions | 勾选 |
   | Repository | `911hzh/zh_flutter_foundation_kit` |
   | Tag pattern | `v{{version}}` |
   | Enable publishing from push events | 取消勾选 |
   | Enable publishing from workflow_dispatch events | 勾选 |
   | Require GitHub Actions environment | 保持不勾选 |

3. 将 `release.yml` 合入 `main` 和仓库默认分支。如果默认分支就是 `main`，
   合入一次即可。工作流使用内置 `GITHUB_TOKEN` 创建 tag、分发后续运行和创建
   Release，并由 GitHub 签发临时 OIDC token。

4. 如需工作流自动开 PR，在 GitHub **Settings → Actions → General → Workflow permissions**
   勾选 **Allow GitHub Actions to create and approve pull requests**。如果仓库策略禁止
   自动开 PR，可以用运行摘要里的链接从已推送的版本分支手动开 PR。
   机器人创建的 PR 如果显示工作流待批准，请在 PR 页面批准运行。

## 每次发布

1. 打开 **Actions → Release from main → Run workflow**，选择 `main`。
   - `version` 留空时，按 pub.dev 最新稳定版递增补丁号，例如 `0.9.0 → 0.9.1 → 0.9.2`。
   - 自定义版本填写完整三段版本号，例如 `0.10.0` 或 `1.0.0`。目标版本必须高于
     pub.dev 最新稳定版，且至少等于 `main` 上的版本。
2. 工作流在运行摘要里给出版本 PR 链接。检查生成的 `CHANGELOG.md` 条目，
   按需补充发布内容，审核并合入 `main`。版本 PR 会同步 package、模板和 example 锁文件。
3. 再次对 `main` 运行 **Release from main**，`version` 留空即可沿用已经合入但尚未
   发布的版本。之后在 Actions 查看自动触发的 `v<版本号>` 运行，并确认 pub.dev
   版本和 GitHub Release。

如果 tag 已创建而 pub.dev 尚未发布，可以重跑原来的 `main` 运行，同一提交
会沿用原 tag。若 pub.dev 已发布而 GitHub Release 创建失败，可为原 tag 补建
Release。已指向其他提交的 tag 会被保留，需要提升版本后再次发布。

参考 [pub.dev 对 tag ref 的要求](https://github.com/dart-lang/pub-dev/issues/8507)
和 [GitHub 的工作流触发规则](https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run/trigger-a-workflow)。
