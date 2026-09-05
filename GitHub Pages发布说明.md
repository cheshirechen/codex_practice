# GitHub Pages 发布说明

## 当前状态

Pages 适配已经完成，源码、两个 ONNX 模型、运行库、示例、自动发布流程均已准备。本地已经验证 `/codex_practice/` 路径下的图片识别、相机、离线重新加载等功能。

仓库：`cheshirechen/codex_practice`，分支：`main`。首次发布状态以仓库 Actions 和 Settings → Pages 的结果为准。

已可使用的 Sites 备用入口：https://ican-garbage-camera.lsc0319.chatgpt.site

## 发布设置

1. 检查仓库的现有文件、默认分支和 Pages 配置，再合入本项目。当前流程文件默认 `main`；若默认分支不同应对应调整。
2. 本目录是一个独立项目。如果目标仓库为空，可以放到仓库根目录；如果已有其他网站或代码，应先安排子目录和构建路径，不能直接覆盖。
3. 到仓库 Settings → Pages，将 Source 设置为 GitHub Actions。
4. 提交代码触发 `.github/workflows/pages.yml`，或在 Actions 中手动运行。
5. 等待发布成功，读取 GitHub 返回的实际网址，再生成正式二维码并用 iPhone 验证。

默认网址为 `https://cheshirechen.github.io/codex_practice/`。采用 HTTPS，不使用自定义域名。

GitHub Free 的 Pages 需要公开仓库；私有仓库是否支持取决于账号计划。无需为此先改变仓库可见性。参考：[GitHub 官方 Pages 创建说明](https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site)。

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
