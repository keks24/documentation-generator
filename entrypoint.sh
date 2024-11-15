#!/usr/bin/env bash
############################################################################
# Copyright 2024 Ramon Fischer                                             #
#                                                                          #
# Licensed under the Apache License, Version 2.0 (the "License");          #
# you may not use this file except in compliance with the License.         #
# You may obtain a copy of the License at                                  #
#                                                                          #
#     http://www.apache.org/licenses/LICENSE-2.0                           #
#                                                                          #
# Unless required by applicable law or agreed to in writing, software      #
# distributed under the License is distributed on an "AS IS" BASIS,        #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. #
# See the License for the specific language governing permissions and      #
# limitations under the License.                                           #
############################################################################
set -e

command="${1}"

if [[ "${command}" == "init" ]]
then
    if [[ ! -f "/source/mkdocs.yml" ]]
    then
        /bin/cp --archive "/template/"* "/source/"
        exit 0
    else
        echo -e "\e[01;31mSkipped copying template: 'mkdocs.yml' already exists.\e[0m" >&2
        exit 1
    fi
elif [[ "${command}" == "make-pdf" ]]
then
    # generate pdf file "document.pdf" in "/source/pdf/".
    # the executable "/root/.local/bin/mkdocs" was made available via "pipx ensurepath";
    # see "/root/.bashrc".
    # the environment variable "ENABLE_PDF_EXPORT" comes from "mkdocs-with-pdf";
    # see "/source/mkdocs.yml"
    # in order to get rid of the error:
    # Could not load theme handler readthedocs: No module named 'mkdocs_with_pdf.themes.readthedocs'
    # the theme "mkdocs-material" need to be installed along with "mkdocs-with-pdf":
    # pipx inject mkdocs-with-pdf mkdocs-material
    ENABLE_PDF_EXPORT="1" /root/.local/bin/mkdocs build \
        --config-file="/source/mkdocs.yml" \
        --site-dir="/tmp/site/"
elif [[ "${command}" == "serve" ]]
then
    # generate website
    /root/.local/bin/mkdocs build \
        --config-file "/source/mkdocs.yml" \
        --site-dir "/tmp/site/"

    # run "mkdocs serve" in foreground. use "exec", in order to catch signals like "SIGTERM".
    exec /root/.local/bin/mkdocs serve \
        --dev-addr="0.0.0.0:8000" \
        --config-file="/source/mkdocs.yml"
fi
