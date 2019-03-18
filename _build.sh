#!/bin/sh

Rscript -e "bookdown::render_book(input = './index.Rmd', output_format = 'bookdown::gitbook', new_session = TRUE)"
# Rscript -e "bookdown::render_book(input = './index.Rmd', output_format = 'bookdown::pdf_book', new_session = TRUE)"
