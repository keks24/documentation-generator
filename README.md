# Documentation generator
This repository shall contain a `unifed documentation solution`.

# Usage
## Initialise project
```bash
$ mkdir "project/"
$ docker run \
    --rm \
    --user="root:root" \
    --volume="./project/:/source/" \
    "documentation-generator:latest" \
    init
$ tree -a "project/"
project//
├── docs/
│   ├── example/
│   │   ├── hello.md
│   │   └── img/
│   │       └── .gitkeep
│   ├── img/
│   │   └── .gitkeep
│   └── index.md
└── mkdocs.yml
```

## Generate PDF file from project
```bash
$ docker run \
    --rm \
    --user="root:root"
    --volume="./project/:/source/" \
    "documentation-generator:latest" \
    make-pdf
ERROR   -  Could not load theme handler readthedocs: No module named 'mkdocs_with_pdf.themes.readthedocs'
INFO    -  Cleaning site directory
INFO    -  Building documentation to directory: /tmp/site
INFO    -  Number headings up to level 3.
INFO    -  Generate a table of contents up to heading level 2.
INFO    -  Generate a cover page with "default_cover.html.j2".
INFO    -  Converting <img> alignment(workaround).
INFO    -  Rendering for PDF.
INFO    -  Output a PDF to "/source/pdf/document.pdf".
INFO    -  Converting 2 articles to PDF took 3.5s
INFO    -  Documentation built in 3.59 seconds
```

The generated PDF file `document.pdf` will be saved in `project/pdf/`.

## Use the built-in webserver and work with the project
The default parameter `serve` can also be left out; see [`CMD` in `Dockerfile`](https://codeberg.org/keks24/documentation-generator/src/commit/8156eb716725e983ddc179b43d5a1f61cf9e0b36/Dockerfile#L34).
```bash
$ docker run \
    --rm \
    --volume="./project/:/source/" \
    --publish="127.0.0.1:8000:8000" \
    "documentation-generator:latest" \
    serve
WARNING -  without generate PDF(set environment variable ENABLE_PDF_EXPORT to 1 to enable)
INFO    -  Cleaning site directory
INFO    -  Building documentation to directory: /tmp/site
INFO    -  Documentation built in 0.28 seconds
INFO    -  Building documentation...
WARNING -  without generate PDF(set environment variable ENABLE_PDF_EXPORT to 1 to enable)
INFO    -  Cleaning site directory
INFO    -  Documentation built in 0.10 seconds
INFO    -  [20:10:16] Watching paths for changes: 'source/docs', 'source/mkdocs.yml'
INFO    -  [20:10:16] Serving on http://0.0.0.0:8000/
```

Open the `forwarded port` on the `host system`:
```bash
$ firefox "127.0.0.1:8000"
```

The `running webserver` will return, that the browser `successfully connected` to the webserver:
```no-highlight
INFO    -  [20:12:03] Browser connected: http://127.0.0.1:8000/
```

Files within the directory `project` can now be `added` and `edited`:
```bash
$ cd "project/docs/"
$ touch "test.md"
```

The `running webserver` will `detect` any file changes within the directory `docs/`:
```no-highlight
INFO    -  [20:14:57] Detected file changes
INFO    -  Building documentation...
WARNING -  without generate PDF(set environment variable ENABLE_PDF_EXPORT to 1 to enable)
INFO    -  The following pages exist in the docs directory, but are not included in the "nav" configuration:
  - test.md
INFO    -  [20:14:57] Reloading browsers
INFO    -  [20:14:58] Browser connected: http://127.0.0.1:8000/
```

In order to `generate` and `add` the new page `test` (`test.md`), edit the configuration file `project/mkdocs.yml`:
```bash
$ vi "project/mkdocs.yml"
[...]
nav:
  - home: "index.md"
  - example:
    - hello: "example/hello.md"
  - test: "test.md"
```

The `running webserver` will detect the file change and rebuild the website:
```no-highlight
INFO    -  [20:22:43] Detected file changes
INFO    -  Building documentation...
WARNING -  without generate PDF(set environment variable ENABLE_PDF_EXPORT to 1 to enable)
INFO    -  Documentation built in 4.72 seconds
INFO    -  [20:22:51] Reloading browsers
```

In order to shutdown the `webserver` and its `container`, enter `CTRL+C`:
```no-highlight
^CINFO    -  Shutting down...
```
