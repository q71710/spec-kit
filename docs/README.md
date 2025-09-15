````markdown
# 文件

此資料夾包含使用 [DocFX](https://dotnet.github.io/docfx/) 建置的 Spec Kit 文件原始檔。

## 本地建置

要在本地建置文件：

1. 安裝 DocFX：
   ```bash
   dotnet tool install -g docfx
   ```

2. 建置文件：
   ```bash
   cd docs
   docfx docfx.json --serve
   ```

3. 在瀏覽器中開啟 `http://localhost:8080` 以檢視文件。

## 結構

- `docfx.json` - DocFX 設定檔
- `index.md` - 主要文件首頁
- `toc.yml` - 目錄設定
- `installation.md` - 安裝指南
- `quickstart.md` - 快速入門指南
- `_site/` - 產生的文件輸出 (由 git 忽略)

## 部署

當變更被推送到 `main` 分支時，文件會自動建置並部署到 GitHub Pages。工作流程定義在 `.github/workflows/docs.yml` 中。

````
