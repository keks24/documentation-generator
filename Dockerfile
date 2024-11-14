FROM debian:bookworm-slim

    ARG DEBIAN_FRONTEND="noninteractive"

    RUN apt-get update && \
        apt-get install --no-install-recommends --assume-yes \
            # required for "weasyprint" from "mkdocs-with-pdf",
            # in order to generate a pdf file.
            libglib2.0-0 \
            libpango-1.0-0 \
            libpangoft2-1.0-0 \
            ###
            pipx && \
        rm --recursive --force "/var/lib/apt/lists/"

    # install "mkdocs" in an isolated environment via "pipx" even as user "root"!
    # the executable will be available under "/root/.local/bin/".
    RUN pipx install mkdocs-with-pdf --include-deps && \
        # ensure, that "/root/.local/bin/" is available in "${PATH}"; see "/root/.bashrc".
        pipx ensurepath

    RUN mkdir "/source/"

    VOLUME "/source/"

    COPY "./template/" "/template/"

    COPY "./entrypoint.sh" "/"

    RUN chmod +x "/entrypoint.sh"

    ENTRYPOINT ["/entrypoint.sh"]

    CMD ["serve"]

    EXPOSE 8000/tcp
