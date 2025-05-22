# JupyterLab 共同作業環境構築 (Docker)

このプロジェクトは、Docker を利用して JupyterLab の共同作業環境を構築するためのものです。

## 概要

`docker-compose.yml` と `Dockerfile` を使用して、必要なライブラリや設定を含んだ JupyterLab 環境をコンテナとして起動します。
リアルタイムでの共同編集機能も有効化されています。

## 特徴

- **JupyterLab の最新バージョン**: `quay.io/jupyter/base-notebook:x86_64-lab-4.1.5` をベースイメージとして使用しています。
- **共同編集機能**: `jupyter-server-ydoc` と `jupyter-collaboration` をインストールし、複数人での同時編集が可能です。
- **日本語対応**: 日本語フォント (Noto Sans CJK JP) をインストールし、matplotlib での日本語表示設定も行っています。
- **主要な Python ライブラリ**: `requirements.txt` に記載された以下のライブラリがプリインストールされています。
    - `matplotlib`
    - `scikit-learn`
    - `pandas`
    - `numpy`
- **データ永続化**: ホストマシンの `./work` ディレクトリがコンテナ内の `/home/jovyan/work` にマウントされるため、作業内容は永続化されます。`.gitignore` により、この `work` ディレクトリ内のファイルは Git の追跡対象外となります。

## 起動方法

1.  **Docker および Docker Compose がインストールされていることを確認してください。**
2.  **このリポジトリをクローンまたはダウンロードします。**
3.  **ターミナルでプロジェクトのルートディレクトリに移動し、以下のコマンドを実行します。**

    ```bash
    docker-compose up -d
    ```

4.  **ブラウザで `http://localhost:8888` を開きます。**
5.  **トークンを求められた場合は、`my-token` を入力してください。**
    (トークンは `docker-compose.yml` ファイル内の `command: start-notebook.py --NotebookApp.token='my-token'` で設定されています。)

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