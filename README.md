# Best practices in bioinformatics - A FAIR example?

Requirements:

- git
- uv
- GNU Make (optional)

To reproduce this repository, follow these steps:

1. **Clone the Repository**:

   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Set Up the Virtual Environment**:

   ```bash
   uv venv --python 3.12
   source .venv/bin/activate
   ```

3. **Initialize and Add Jupyter Book**:

   ```bash
   uv init
   uv add jupyter-book
   ```

4. **Build the Project**:

   ```bash
   make
   ```

5. **Access the Website**:
   The website is hosted at <https://best-practices-in-bioinformatics.netlify.app>.

The `_build/html` directory was manually uploaded to Netlify.app to host the website, available at <https://best-practices-in-bioinformatics.netlify.app>
