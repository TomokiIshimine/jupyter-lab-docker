# JupyterLab MCP Server Environment Setup (Docker)

This project is designed to build a JupyterLab MCP (Model Context Protocol) server environment using Docker. You can operate Jupyter Notebooks on this JupyterLab through MCP server from Claude Desktop.

## Overview

Using `docker-compose.yml` and `Dockerfile`, this project launches a JupyterLab environment as a container that can integrate with the `tonlab/jupyter-mcp-server` MCP server. It enables execution and operation of Jupyter Notebooks from Claude Desktop through the MCP protocol.

## Features

- **MCP Server Integration**: Enables Jupyter Notebook operation from Claude Desktop using `tonlab/jupyter-mcp-server`
- **Latest JupyterLab Version**: Uses `quay.io/jupyter/base-notebook:x86_64-lab-4.1.5` as the base image
- **Collaborative Editing**: Installs `jupyter-server-ydoc` and `jupyter-collaboration` for multi-user simultaneous editing
- **Japanese Language Support**: Installs Japanese fonts (Noto Sans CJK JP) and configures matplotlib for Japanese text display
- **Essential Python Libraries**: Pre-installs the following libraries listed in `requirements.txt`:
    - `matplotlib`
    - `scikit-learn`
    - `pandas`
    - `numpy`
- **Data Persistence**: The host machine's `./work` directory is mounted to `/home/jovyan/work` in the container for persistent work content

## Getting Started

1.  **Ensure Docker and Docker Compose are installed.**

2.  **Clone the GitHub repository.**

    ```bash
    git clone https://github.com/TomokiIshimine/jupyter-lab-docker.git
    ```

3.  **Navigate to the project directory.**

    ```bash
    cd jupyter-lab-docker
    ```

4.  **Start JupyterLab using Docker Compose.**

    ```bash
    docker-compose up -d
    ```

5.  **Open `http://localhost:8888` in your browser.**

6.  **If prompted for a token, enter `my-token`.**

## Claude Desktop Integration Setup

After starting JupyterLab, configure `claude_desktop_config.json` as follows to operate Jupyter Notebooks from Claude Desktop through the MCP server.

### claude_desktop_config.json Configuration

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

### Configuration Parameters

- `SERVER_URL`: JupyterLab server URL (typically `http://host.docker.internal:8888`)
- `TOKEN`: JupyterLab access token (default is `my-token`)
- `NOTEBOOK_PATH`: Target Jupyter Notebook file name
- `TIMEOUT`: Timeout duration (seconds)

## Configuration

- **Port**: Host port `8888` is forwarded to container port `8888`. Modify the `ports` setting in `docker-compose.yml` as needed.
- **JupyterLab UI**: Lab UI is enabled by default (`JUPYTER_ENABLE_LAB: "yes"`).
- **Token**: Default token is `my-token`. For security considerations, modify the `command` in `docker-compose.yml` as needed.

## Directory Structure

```
.
├── Dockerfile               # Docker image build instructions
├── docker-compose.yml       # Docker Compose configuration file
├── requirements.txt         # Python libraries list
├── .gitignore               # Git ignore file specification
└── work/                    # JupyterLab working directory (shared with host)
```

## Notes

- Files in the `work/` directory are excluded from Git management. It is recommended to separately backup or version control important notebooks.
- When using the MCP server, ensure JupyterLab is running before performing operations from Claude Desktop. 