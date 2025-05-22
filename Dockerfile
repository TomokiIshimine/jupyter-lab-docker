# syntax=docker/dockerfile:1
FROM quay.io/jupyter/base-notebook:x86_64-lab-4.1.5

##############################################################################
# 1) 日本語フォントをインストール
# 2) フォントキャッシュを更新
# 3) matplotlibrc を専用ディレクトリに置き、そこを最優先に読むよう
#    MPLCONFIGDIR を指定
##############################################################################
USER root

# 日本語フォント + キャッシュ再生成
RUN apt-get update && \
    apt-get install -y --no-install-recommends fonts-noto-cjk fontconfig && \
    fc-cache -f -v && \
    rm -rf /var/lib/apt/lists/*

##############################################################################
# 必須のPython パッケージ類
##############################################################################
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && \
      pip install --no-cache-dir \
      "jupyter-server-ydoc>=0.9" \
      "jupyter-collaboration>=4.0" && \
    jupyter server extension enable --py jupyter_collaboration

# 非 root で実行
USER $NB_UID

##############################################################################
# matplotlib のユーザー設定
# $HOME/.config/matplotlib を設定ディレクトリとし、
# そこに matplotlibrc を配置する。
##############################################################################
RUN mkdir -p "$HOME/.config/matplotlib" && \
    printf "font.family : sans-serif\n\
font.sans-serif : Noto Sans CJK JP, DejaVu Sans, Bitstream Vera Sans, Lucida Grande, Verdana, Geneva, Lucid, Arial, Helvetica, Avant Garde, sans-serif\n\
axes.unicode_minus : False\n" \
          > "$HOME/.config/matplotlib/matplotlibrc"

ENV MPLCONFIGDIR="$HOME/.config/matplotlib"
