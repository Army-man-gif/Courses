import subprocess

modules = [
    "1OS", "altair", "anyio", "appier", "argon2-cffi", "argon2-cffi-bindings", "arrow", "asttokens", "async-lru",
    "attrs", "babel", "beautifulsoup4", "bleach", "blinker", "bs4", "buildozer", "cachetools", "certifi", "cffi",
    "charset-normalizer", "click", "colorama", "comm", "continuous-threading", "contourpy", "cv", "cycler",
    "debugpy", "decorator", "defusedxml", "distlib", "docutils", "Everything-Tkinter", "executing",
    "extended_maths", "fastjsonschema", "filelock", "filetype", "Flask", "fonttools", "fqdn", "gitdb", "GitPython",
    "google-api", "google-api-core", "google-api-python-client", "google-auth", "google-auth-httplib2",
    "google-auth-oauthlib", "googleapis-common-protos", "gspread", "gunicorn", "h11", "httpcore", "httplib2",
    "httpx", "idna", "imageio", "ipykernel", "ipython", "ipython_pygments_lexers", "ipywidgets", "isoduration",
    "itsdangerous", "jedi", "Jinja2", "json5", "jsonpointer", "jsonschema", "jsonschema-specifications", "jupyter",
    "jupyter_client", "jupyter-console", "jupyter_core", "jupyter-events", "jupyter-lsp", "jupyter_server",
    "jupyter_server_terminals", "jupyterlab", "jupyterlab_pygments", "jupyterlab_server", "jupyterlab_widgets",
    "Kivy", "kivy_deps.angle", "kivy_deps.glew", "kivy_deps.sdl2", "Kivy-Garden", "kiwisolver", "lazy_loader",
    "MarkupSafe", "matplotlib", "matplotlib-inline", "mistune", "mplcursors", "narwhals", "nbclient", "nbconvert",
    "nbformat", "nest-asyncio", "networkx", "notebook", "notebook_shim", "npm", "numpy", "oauth2client", "oauthlib",
    "optional-django", "overrides", "packaging", "pandas", "pandocfilters", "parso", "pdfkit", "pexpect", "pillow",
    "pip", "platformdirs", "prometheus_client", "prompt_toolkit", "proto-plus", "protobuf", "psutil", "ptyprocess",
    "pure_eval", "pyarrow", "pyasn1", "pyasn1_modules", "pycparser", "pydeck", "pygame", "Pygments", "pyparsing",
    "PyPDF2", "pypiwin32", "python-dateutil", "python-json-logger", "python-time", "pytz", "pywin32", "pywinpty",
    "PyYAML", "pyzmq", "random2", "referencing", "requests", "requests-oauthlib", "rfc3339-validator",
    "rfc3986-validator", "rpds-py", "rsa", "scikit-image", "scipy", "seaborn", "Send2Trash", "setuptools", "sh",
    "six", "smmap", "sniffio", "soupsieve", "SQLite4", "stack-data", "streamlit", "tenacity", "terminado",
    "tifffile", "tinycss2", "tkcalendar", "toml", "tornado", "traitlets", "types-python-dateutil",
    "typing_extensions", "tzdata", "uri-template", "uritemplate", "urllib3", "virtualenv", "w2re", "watchdog",
    "wcwidth", "webcolors", "webencodings", "websocket-client", "Werkzeug", "widgetsnbextension", "wkhtmltopdf"
]

def run_command(command):
    try:
        subprocess.run(command, check=True)
    except subprocess.CalledProcessError:
        print(f"Failed: {' '.join(command)}")

def install_all():
    for mod in modules:
        run_command(["pip", "install", mod])

def uninstall_all():
    for mod in modules:
        run_command(["pip", "uninstall", "-y", mod])

def install_one():
    mod = input("Enter the name of the module to install: ")
    run_command(["pip", "install", mod])

def uninstall_one():
    mod = input("Enter the name of the module to uninstall: ")
    run_command(["pip", "uninstall", "-y", mod])

def uninstall_selection():
    mods = input("Enter the module names to uninstall (comma-separated): ").split(",")
    for mod in mods:
        run_command(["pip", "uninstall", "-y", mod.strip()])

def install_selection():
    mods = input("Enter the module names to install (comma-separated): ").split(",")
    for mod in mods:
        run_command(["pip", "install", mod.strip()])

def main():
    print("Choose an option:")
    print("1. Uninstall all")
    print("2. Install all")
    print("3. Uninstall one")
    print("4. Install one")
    print("5. Uninstall selection")
    print("6. Install selection")
    choice = input("Enter your choice (1-6): ")

    match choice:
        case "1":
            uninstall_all()
        case "2":
            install_all()
        case "3":
            uninstall_one()
        case "4":
            install_one()
        case "5":
            uninstall_selection()
        case "6":
            install_selection()
        case _:
            print("Invalid choice.")

if __name__ == "__main__":
    main()
