# 数智清道夫：iPhone 网页垃圾识别

这是 GitHub Pages 版本，仓库为 `cheshirechen/codex_practice`。发布配置见 `GitHub Pages发布说明.md`。

手机入口（首次部署成功后可用）：https://cheshirechen.github.io/codex_practice/

无需登录；使用 iPhone Safari，允许相机访问后即可连续识别。

使用已训练的 **Keremberke YOLOv5n-garbage**，未重新训练、未替换模型。React + Vite + ONNX Runtime Web，推理在浏览器 Worker 内执行。

## 手机使用

Sites 备用地址：https://ican-garbage-camera.lsc0319.chatgpt.site

该入口使用 Sites 私人访问控制，可能要求登录站点所有者对应的 ChatGPT 账号。访问结果以部署记录为准。二维码在 `phone-qr.png`。

1. iPhone 15 用 Safari 打开，首次联网等待模型准备完成。
2. 点击「选择照片」，或「开启相机」并允许访问相机。
3. 默认均衡 416、置信度 25%。对准单件物体，保持短暂稳定；可切换精细 640 对照。
   你要的用法已经支持：先放塑料瓶，显示「塑料」；拿走再放另一类物品，会自动更新结果，不必再次点击识别。
4. 「保存画面」保存最近一次识别的画面及检测框。iPhone 使用系统分享菜单，可选择保存图像。照片保存最长边为 1920 像素，避免大照片占用过多内存。
5. 「停止相机」释放摄像头。进入后台后停止相机，回来点击开启继续。
6. 在性能设置中检查缓存，再断网重开验证。只保证本设备缓存仍存在时可离线使用。首次下载可能较慢，运行库与模型合计需要数十 MB。
7. Safari 分享菜单 → 添加到主屏幕。

类别：可降解垃圾、纸板、玻璃、金属、纸张、塑料。模型识别物体材质/类别，无法判断一个完好物品是否已被丢弃，也不是生活垃圾四分类规则引擎。

## 已完成与仍需真机验证

- 已导出 FP32、静态单张输入 416 和 640 模型，每个约 7 MB。
- 36 组原模型/ONNX 对照（每尺寸 18 张），包含 10 张公开标注测试图、作者示例拼图、纯色负样例、6 张项目中的道路照片；全部通过检测框和分数对照。
- 浏览器解析与 Python NMS 对照、横竖图坐标映射、RGB 归一化、类别内重复框过滤均有自动测试。
- 浏览器功能和连续运行测试见 `validation/browser-validation.json`；这是 Windows Edge/Chromium 测试，不是 iPhone 测试。
- 桌面模拟视频流连续运行 600 秒通过；塑料瓶画面切换为纸板画面后自动更新类别通过，见 `validation/bottle-switch.json`。这是软件链路验证，不代替实体物品和真实相机测试。
- **iPhone 15 的 Safari 兼容性、真实帧率、10 分钟稳定性、发热、真实垃圾与无垃圾画面的误检，尚需用户实测。** 不预先承诺每秒 5 次更新。

模型效果存在明显局限。公开 test.zip 没有玻璃类标注；部分被选样例是花盆、摆放中的日用品等，不等同于路面垃圾。`quality-subset.json` 的小样本匹配统计只用于暴露问题，不是整体准确率。详见 `validation/说明.md`。

## 本机启动

已验证 Node.js 22.18.0。直接运行 `启动网页.ps1`，或在本目录执行：

```powershell
npm.cmd ci
npm.cmd run dev
```

电脑打开 http://localhost:5173/codex_practice/。手机访问普通局域网 HTTP 地址无法正常开启相机，应使用上方 HTTPS 入口。

生产版本：

```powershell
npm.cmd test
npm.cmd run build
npm.cmd run preview
```

`dist` 可部署到支持 HTTPS 的静态托管平台。不要仅双击 index.html。模型与运行库都从同一个站点加载，不依赖推理服务器、API 密钥或摄像头图像上传。站点访问认证和文件下载本身仍涉及联网。

## 模型与转换复现

原权重：`artifacts/best.pt`。转换后模型：`public/models/garbage-416.onnx` 和 `garbage-640.onnx`。模型校验值和类别顺序见同目录 `manifest.json`。

源模型版本：`257276b8c4ce530f48dff415e36761f9d1af4e69`。
转换代码 YOLOv5 v7.0：`915bbf294bb74c859f0b41f1c23bc395014ea679`。

当前机器独立 Python 环境位于 `%TEMP%\ican-garbage-py312`。临时目录可能被清理；可用 Python 3.12 在项目内重新创建环境：

```powershell
py -3.12 -m venv .venv
.\.venv\Scripts\python.exe -m pip install torch==2.5.1+cpu torchvision==0.20.1+cpu --index-url https://download.pytorch.org/whl/cpu
.\.venv\Scripts\python.exe -m pip install -r requirements-model.txt
.\.venv\Scripts\python.exe scripts/prepare_model.py
.\.venv\Scripts\python.exe scripts/summarize-validation.py
npm.cmd test
```

实际安装版本完整记录在 `requirements-model-lock.txt`。首次执行需要网络下载原权重、固定版本源码和公开测试集；`artifacts/acquisition.json` 记录下载版本与哈希。原权重采用 PyTorch 序列化，脚本只处理这个固定来源的模型，不应改为加载任意未知权重。

浏览器预处理为 RGB / 255、缩放补边 114、CHW；模型输出 `[1,10647,11]` 或 `[1,25200,11]`，置信度=目标分数×类别概率，类别内 NMS=0.45，先抑制后裁剪框。浏览器 Canvas 与 OpenCV 缩放插值略有差异，少量接近阈值的结果可以不同。

## 文件导航

| 内容 | 位置 |
|---|---|
| 网页界面、相机与保存 | `src/main.jsx` |
| 独立推理、下载校验、后端回退 | `src/inference.worker.js` |
| 坐标还原及 NMS | `src/detection.mjs` |
| 模型准备及对照验证 | `scripts/prepare_model.py` |
| 桌面浏览器自动测试 | `scripts/browser-check.cjs` |
| 原始数据/模型/带框样例 | `artifacts/`（本地保留） |
| 验证结果与手机记录表 | `validation/` |
| 模型/公开测试样例/运行库 | `public/` |

## 来源

- [模型与模型卡](https://huggingface.co/keremberke/yolov5n-garbage)
- [公开数据集](https://huggingface.co/datasets/keremberke/garbage-object-detection)：Material Identification / Roboflow，CC BY 4.0；网页公开样例来自其 test 分割，文件映射在 `public/samples/index.json`，图像未改动，网页添加检测框。
- [YOLOv5 v7.0](https://github.com/ultralytics/yolov5/tree/v7.0)：转换依赖其 GPL-3.0 代码，下载副本及许可在 `artifacts/vendor/yolov5`。
- [ONNX Runtime Web](https://onnxruntime.ai/docs/tutorials/web/)：1.22.0，MIT。

原模型卡未明确列出独立的权重许可证；本交付为个人实验验证，若后续公开商业分发需先核对权重授权。项目中的个人道路照片仅用于本机验证，没有放入网站资源。

