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

    RUN groupadd \
            --gid="1000" \
            www-mkdocs && \
        useradd \
            --uid="1000" \
            --gid="1000" \
            --create-home \
            --home-dir="/home/www-mkdocs" \
            --shell="/sbin/nologin" \
            www-mkdocs

    RUN mkdir "/source/"

    VOLUME "/source/"

    COPY "./template/" "/template/"

    COPY "./entrypoint.sh" "/"

    RUN chmod +x "/entrypoint.sh"

    USER www-mkdocs

    # install "mkdocs" in an isolated environment via "pipx" (even as user "root")!
    # the executable will be available under "/home/www-mkdocs/.local/bin/".
    RUN pipx install --include-deps mkdocs-with-pdf && \
        # ensure, that "/home/www-mkdocs/.local/bin/" is available in "${PATH}";
        # see "/home/www-mkdocs/.bashrc".
        pipx ensurepath

    ENTRYPOINT ["/entrypoint.sh"]

    CMD ["serve"]

    EXPOSE 8000/tcp
