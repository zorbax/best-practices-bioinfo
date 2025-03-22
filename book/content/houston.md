# Houston we have a problem

```{figure} static/python_environment.png
---
width: 70%
align: center
---
But **we can use Conda** Right? Right?
```

## Conda

An article has has [recently been going around](https://www.theregister.com/2024/08/08/anaconda_puts_the_squeeze_on/)  about Anaconda — the creators of Conda — deciding that not-for-profit organizations (such as universities) must now pay to use their tools. Unfortunately there is **no community consensus** about the right tool to use to manage Python versions and environments. Instead, we are stuck with at least five different popular tools, one of which is Conda.

## The alternatives

 Python distribution and environment management is currently in a problematic state, which likely explains why a for-profit company still holds relevance in the open-source Python ecosystem in 2024. In the broader Python software development community, there are numerous tools available to manage your Python installation, such as:

- [Pip](https://github.com/pypa/pip)
- [Pipenv](https://github.com/pypa/pipenv)
- [setuptools](https://github.com/pypa/setuptools)
- [Poetry](https://github.com/python-poetry/poetry)
- [Hatch](https://github.com/pypa/hatch)
- [PDM](https://github.com/pdm-project/pdm)
- [Rye](https://github.com/astral-sh/rye)

Each has varying levels of features. A persistent issue in Python is the lack of a standard for defining a development environment, which means many environments are incompatible with each other.

The Conda ecosystem confines you to using Conda. Installing packages with `pip` while using Conda risks breaking the Conda environment, preventing access to most packages on the official Python repository, PyPI. Very common when you are usine the `bioconda` channel.

Additionally, Conda is a very bloated tool that requires many gigabytes of storage space per environment, making it impractical for machines with limited disk space (such as a small user account on an HPC cluster). The 'solution' in the Conda world is to use _yet another alternative tool_ (😭) like mamba, micromamba, miniforge… the list goes on.

**Homebrew's Python**

While Homebrew is a powerful package manager for macOS, its approach to Python version management can sometimes lead to unexpected behavior.

**Key Issues with Homebrew's Python:**

1. **Automatic Upgrades:** Homebrew automatically upgrades Python versions and their dependencies. This can disrupt your development environment if you rely on specific Python versions for different projects.
2. **Deletion of Old Versions:** After 30 days, Homebrew automatically removes older Python versions, potentially causing issues if you need to revert to a previous version.

## venv: the easiest solution

Is already included as a module:

```bash
python -m venv venv

source venv/bin/activate

pip install PACKAGE

deactivate
```

## pyenv: a simple solution

**[pyenv](https://github.com/pyenv/pyenv) is a simple tool for installing multiple Python versions.** pyenv is lightweight, and just uses a clever shell script and shim approach to manage Python for you.
You also don’t need to have Python installed already to install pyenv with.

Then, once you set up pyenv, you can install packages in the environment of your choice with pip.

*The instructions below work for Linux or Mac; Windows users should follow instructions in the [Windows-compatible fork](https://github.com/pyenv-win/pyenv-win) instead.*

**Installation:**

```bash
curl https://pyenv.run | bash
```

**Adding pyenv to your shell configuration:** Follow the instructions provided after installation to add pyenv to your shell configuration (e.g., `.bashrc`, `.zshrc`).

**Using pyenv:**

- **List Available Python Versions:**

```bash
pyenv install --list
```

- **Install a Specific Python Version:**

```bash
pyenv install 3.11.3
```

- **Set the Global Python Version:**

```bash
pyenv global 3.11.3
```

- **Set a Local Python Version for a Specific Directory:**

```bash
cd my_project
pyenv local 3.9.13
```

- **List Installed Python Versions:**

```bash
pyenv versions
```

## uv: the all-in-one solution

[uv](https://github.com/astral-sh/uv) is a next-generation Python package installer and manager that is 10-100x faster than pip, and also makes it easy to install Python and manage projects. With `uv`, creating a virtual environment is as easy as `uv venv`.

**Installation**

```bash
# On macOS and Linux.

curl -LsSf https://astral.sh/uv/install.sh | sh
```

```bash
# On Windows.

powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

You can install `uv` using PowerShell, but for a more integrated and efficient development environment, consider using [Windows Subsystem for Linux (WSL)](https://ubuntu.com/desktop/wsl). WSL enables you to run a full Linux distribution alongside your Windows system, allowing you to access a wide range of Linux tools and libraries, including `uv`. This eliminates the need for complex virtual machine setups or dual-booting.

## Setting a work environment

**Create a Virtual Environment:**

```bash
uv venv --python 3.12
```

**Activate the Environment:**

```bash
source .venv/bin/activate
```

**Pin the Python Version (optional):**

If you are creating multiple environments in your current directory, so the next time you don't need to specify the python version`

```bash
uv python pin 3.12
```

**Initialize an `uv` project**

`uv init` creates a new Python project with a pyproject.toml file and, a lockfile.

```bash
uv init
```

**Install Packages:**

Generally, using `uv add` is recommended as it provides better project management and reproducibility. It automatically manages package versions and ensures consistent installations across different environments.

However, if you need to quickly install a package without modifying your `pyproject.toml` file, you can use `uv pip install`.

```bash
uv add jupyterlab jupyter-book jupyterlab-tour \
       ipython pandas numpy seaborn
```

### Pre-commit hooks

A pre-commit hook is a script that runs automatically before a commit is made.

```bash
pip install pre-commit

# uv add pre-commit

```bash
Then create a file named `.pre-commit-config.yaml`
- you can generate a very basic configuration using [`pre-commit sample-config`](https://pre-commit.com/#pre-commit-sample-config)
- the full set of options for the configuration are listed [here](https://pre-commit.com/#plugins)

```yaml
repos:
  - repo: local
    hooks:
      - id: jupyter-nb-clear-output
        name: jupyter-nb-clear-output
        files: \.ipynb$
        stages: [commit]
        language: python
        entry: jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace
        additional_dependencies: [jupyter]
```

Install the git hook scripts:

- run `pre-commit install` to set up the git hook scripts

```bash
pre-commit install
```

### Code formatting for notebooks

```bash
pip install -U "nbqa[toolchain]"
# uv add "nbqa[toolchain]"

nbqa black my_notebook.ipynb

nbqa isort my_notebook.ipynb
```

## Jupyter Book

Jupyter Book is a powerful tool for creating beautiful and interactive books and documents from Jupyter Notebooks. It's perfect for sharing your data science projects, tutorials, documentation.

**Key Features:**

- **Interactive Content:** Embed interactive visualizations and code cells directly into your book.
- **Easy Deployment:** Deploy your book to the web with a single command.

**Basic Usage:**

1. **Create a Jupyter Book Project:** Initialize a new Jupyter Book project in your desired directory:

```bash
jupyter-book init my_book
```

2. **Write Your Content:** Create Jupyter Notebooks with your content, including text, code, and visualizations.

3. **Build Your Book:** Build your book into static HTML files:

```bash
jupyter-book build my_book
```

4. **Clean the Build:** Remove any temporary files generated during the build process:

```bash
jupyter-book clean my_book --all
```

5. **Serve Locally:** Serve your book locally to view it in a web browser:

```bash
jupyter-book serve my_book
```

## Where can I deploy my book?

For me, the best options is a **Static Hosting Platform:** like:

- **(Netlify)[https://www.netlify.com]:** Known for its ease of use and integration with GitHub.
- **(GitHub Pages)[https://pages.github.com]:** Free hosting for GitHub repositories, suitable for simple projects.
