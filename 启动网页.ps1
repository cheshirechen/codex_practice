$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot
if (-not (Test-Path -LiteralPath 'node_modules')) {
    npm.cmd ci
    if ($LASTEXITCODE -ne 0) { throw '网页依赖安装失败，请检查网络。' }
}
Write-Host '电脑访问 http://localhost:5173/codex_practice/；手机开启相机请使用 README 中的 HTTPS 地址。'
npm.cmd run dev
