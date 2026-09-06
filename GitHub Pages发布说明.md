# GitHub Pages 发布说明

## 当前状态

Pages 适配已经完成，源码、两个 ONNX 模型、运行库、示例、自动发布流程均已准备。本地已经验证 `/codex_practice/` 路径下的图片识别、相机、离线重新加载等功能。

仓库：`cheshirechen/codex_practice`（公开），分支：`main`。2026-09-06 已启用 GitHub Actions 发布；首次发布成功记录：https://github.com/cheshirechen/codex_practice/actions/runs/33971783711 。

正式公开网址：https://cheshirechen.github.io/codex_practice/ ，无需登录，二维码见 `phone-qr.png`。

已可使用的 Sites 备用入口：https://ican-garbage-camera.lsc0319.chatgpt.site

## 发布设置

1. 项目已放在仓库根目录，Source 已设置为 GitHub Actions。
2. 后续提交到 `main` 会触发 `.github/workflows/pages.yml`，也可在 Actions 中手动运行。
3. 等待 build 和 deploy 均成功，再刷新公开网址；手机的旧缓存可能需要联网重新加载。
4. 首次失败原因为 Pages 未启用（部署接口 404）；测试和构建本身通过。启用 Pages 后重新运行已成功。

默认网址为 `https://cheshirechen.github.io/codex_practice/`。采用 HTTPS，不使用自定义域名。

本次按用户确认使用公开仓库，未购买付费计划或配置自定义域名。

## 本地启动与打包

```powershell
npm.cmd ci
npm.cmd test
npm.cmd run dev
```

电脑访问 `http://localhost:5173/codex_practice/`。

```powershell
npm.cmd run build
npm.cmd run preview -- --port 4174
```

访问 `http://localhost:4174/codex_practice/`。手机开启相机仍需 HTTPS。

修改发布路径时，在构建前设置 `VITE_BASE_PATH`，必须以 `/` 开头和结尾。Actions 根据实际仓库名设置该值。相机、模型、运行库、示例、PWA 和离线缓存均已按这个路径适配。

默认 416、WASM 本机推理；网页不会把相机画面上传到 GitHub。先放塑料瓶，再换纸板，会自动更新检测结果。模型仍可能漏检或误判，真机效果和发热待测。
