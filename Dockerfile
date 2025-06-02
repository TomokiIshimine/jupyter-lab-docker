# syntax=docker/dockerfile:1
FROM quay.io/jupyter/base-notebook:x86_64-lab-4.1.5

USER root

##############################################################################
# 必須のPython パッケージ類
##############################################################################
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir \
    "jupyter-server-ydoc==2.0.2" \
    "jupyter-collaboration==4.0.1" && \
    jupyter server extension enable jupyter_collaboration

# 非 root で実行
USER $NB_UID
