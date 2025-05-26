# JupyterLab MCP サーバー環境構築 (Docker)

このプロジェクトは、Docker を利用して JupyterLab の MCP（Model Context Protocol）サーバー環境を構築するためのものです。Claude Desktop から MCP サーバーを通して、この JupyterLab 上の Jupyter Notebook を操作することができます。

## 概要

`docker-compose.yml` と `Dockerfile` を使用して、`tonlab/jupyter-mcp-server` MCP サーバーと連携可能な JupyterLab 環境をコンテナとして起動します。Claude Desktop から MCP プロトコルを通じて Jupyter Notebook の実行や操作が可能になります。

## 特徴

- **MCP サーバー連携**: `tonlab/jupyter-mcp-server` を使用して Claude Desktop から Jupyter Notebook を操作可能
- **JupyterLab の最新バージョン**: `quay.io/jupyter/base-notebook:x86_64-lab-4.1.5` をベースイメージとして使用
- **共同編集機能**: `jupyter-server-ydoc` と `jupyter-collaboration` をインストールし、複数人での同時編集が可能
- **日本語対応**: 日本語フォント (Noto Sans CJK JP) をインストールし、matplotlib での日本語表示設定も対応
- **主要な Python ライブラリ**: `requirements.txt` に記載された以下のライブラリがプリインストール
    - `matplotlib`
    - `scikit-learn`
    - `pandas`
    - `numpy`
- **データ永続化**: ホストマシンの `./work` ディレクトリがコンテナ内の `/home/jovyan/work` にマウントされ、作業内容が永続化

## 起動方法

1.  **Docker および Docker Compose がインストールされていることを確認してください。**
2.  **このリポジトリをクローンまたはダウンロードします。**
3.  **ターミナルでプロジェクトのルートディレクトリに移動し、以下のコマンドを実行します。**

    ```bash
    docker-compose up -d
    ```

4.  **ブラウザで `http://localhost:8888` を開きます。**
5.  **トークンを求められた場合は、`my-token` を入力してください。**

## Claude Desktop との連携設定

JupyterLab を起動した後、Claude Desktop から MCP サーバーを通して Jupyter Notebook を操作するために、以下のように `claude_desktop_config.json` を設定してください。

### claude_desktop_config.json の設定

```json
{
  "mcpServers": {
    "jupyter": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e", "SERVER_URL=http://host.docker.internal:8888",
        "-e", "TOKEN=my-token",
        "-e", "NOTEBOOK_PATH=test.ipynb",
        "-e", "TIMEOUT=30",
        "tonlab/jupyter-mcp-server"
      ]
    }
  }
}
```

### 設定パラメータの説明

- `SERVER_URL`: JupyterLab サーバーの URL（通常は `http://host.docker.internal:8888`）
- `TOKEN`: JupyterLab のアクセストークン（デフォルトは `my-token`）
- `NOTEBOOK_PATH`: 操作対象の Jupyter Notebook ファイル名
- `TIMEOUT`: タイムアウト時間（秒）

## 設定

- **ポート**: ホスト側の `8888` ポートがコンテナの `8888` ポートにフォワードされます。必要に応じて `docker-compose.yml` の `ports` 設定を変更してください。
- **JupyterLab UI**: デフォルトで Lab UI が有効になっています (`JUPYTER_ENABLE_LAB: "yes"`)。
- **トークン**: デフォルトのトークンは `my-token` です。セキュリティを考慮し、必要に応じて `docker-compose.yml` の `command` を変更してください。

## ディレクトリ構成

```
.
├── Dockerfile               # Dockerイメージのビルド手順
├── docker-compose.yml       # Docker Composeの設定ファイル
├── requirements.txt         # Pythonライブラリのリスト
├── .gitignore               # Gitの追跡対象外ファイルを指定
└── work/                    # JupyterLabの作業ディレクトリ (ホストと共有)
```

## 注意点

- `work/` ディレクトリ内のファイルは Git の管理対象外です。重要なノートブックなどは別途バックアップやバージョン管理を行うことを推奨します。
- MCP サーバーを使用する際は、JupyterLab が起動していることを確認してから Claude Desktop で操作を行ってください。 