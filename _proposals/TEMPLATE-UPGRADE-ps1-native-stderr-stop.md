# TEMPLATE-UPGRADE: 修 new-domain-project.ps1 的 PS5.1 native stderr 陷阱

> 类型：L2 领域模板自身建设提案（agent-system-template 自治；脚本可用性修复）。
> Release impact：patch（AI 建议，待维护者确认）——并入 v0.4.1。
> Release strategy：同主题聚合（与 domain-overlay-relocation 同分支同版本）。
> 状态：执行中（2026-07-30，分支 feat/domain-overlay-relocation）。
> 关联：CHANGELOG v0.4.0（ps1 BOM/CRLF 要求）；母模板 issue #293（Start-Process PATH，同类 PS5.1 问题）。

## 1. 动机

`new-domain-project.ps1` 顶部 `$ErrorActionPreference = "Stop"`。PS5.1 下，native command（git/gh）输出 stderr（如 git 的 CRLF warning "LF will be replaced by CRLF"）时，Stop 模式把它当 `NativeCommandError` **中断脚本**。结果：脚本在 `git add -A`（首次触发 CRLF warning）即崩，`new-domain-project.ps1` 在 Windows PowerShell 5.1 下**实际不可用**。

CHANGELOG v0.4.0 已知 ps1 的 PS5.1 敏感性（BOM/CRLF），但未覆盖 stderr 陷阱。本提案补上。

## 2. 拟改

- 新增 helper `Invoke-SafeNative`：临时降 `$ErrorActionPreference='Continue'` 调用 native exe，按 `$LASTEXITCODE` 判成败（非 0 才 `throw`）。
- 把所有「裸调用且无 stderr 重定向」的 native 调用改为经 helper + `2>$null`（丢 stderr 噪音、保 stdout 进度、`$LASTEXITCODE` 兜底检错）：`git archive` / `git add` / `git commit`（含 local-init 身份）/ `sync-domain-template` 子进程 / `gh repo create`。
- 原有 `2>$null` 调用（`git config`、`gh api`、`gh auth switch`）保留不动。

## 3. 不改

- 不改 `$ErrorActionPreference = "Stop"` 全局（仍保护 PowerShell cmdlet 错误）；只在 native 调用处局部放宽。
- 不改 `.sh`（bash 不把 stderr 当致命，无此问题）。
- 不引入 try/catch 包裹整个脚本（范围过大）。

## 4. 验证

- 实跑 `new-domain-project.ps1 -NoRemote` 派生临时 L3：EXIT 0，无 `NativeCommandError` 噪音，`domain-overlay/` 被剥离，overlay 落到 `ai/agent-rules/`，sync commit 产生。
- 两版脚本（ps1 + sh）现均可实跑验证（此前仅 .sh 可跑）。

## 5. 版本影响：patch（并入 v0.4.1）

ps1 是 pre-existing 缺陷修复，不改变同步语义或 L3 形态；v0.4.1 未发布，并入同版本。

## 6. 后续

- 母模板的 PowerShell wrapper（`sync-template.ps1` 等）可能有同类 stderr 陷阱；若确认，另起回流母模板（与 issue #293 同类 PS5.1 问题）。
- 若将来 ps1 增加新 native 调用，统一经 `Invoke-SafeNative` + `2>$null`。
