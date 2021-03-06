#!/usr/bin/env Rscript
# Create CV automatically
# Author: Shixiang Wang
# License: MIT
template_path <- commandArgs(trailingOnly = TRUE)[1]
if (is.na(template_path)) {
    template_path <- "template"
}

library(data.table)
library(pagedown)
library(tidyverse)

just_copy <- function(input_file, out_file, append = TRUE) {
  message("Copying contents of ", input_file, " to ", out_file)
  fl_content <- readLines(input_file)
  write_lines(fl_content, out_file, append = TRUE)
}

position_path <- "positions.csv"
profile_path <- "profile.csv"
aside_md <- "aside.md"
intro_md <- "intro.md"

# Load csv with position info
position_data <- read_csv(position_path)
sections <- unique(position_data$section)
rm(position_data)

# Load csv with profile info
profile <- fread(profile_path)

# Copy html and set output
file.copy(file.path(template_path, "styles.css"), "styles.css")
out_file <- "index.Rmd"

# Part 1: yaml ---------------------------------------------------------
input_file <- file.path(template_path, "template_01_yml.Rmd")
message("Copying contents of ", input_file, " to ", out_file)
fl_content <- readLines(input_file)
fl_content <- gsub("Guangchuang Yu", profile$Name, fl_content)
write_lines(fl_content, out_file)

# Part 2: header ----------------------------------------------------------
input_file <- file.path(template_path, "template_02_header.Rmd")
just_copy(input_file, out_file)

# Part 3: aside -----------------------------------------------------------
input_file <- file.path(template_path, "template_03_aside.Rmd")
message("Copying contents of ", input_file, " to ", out_file)
fl_content <- readLines(input_file)
if (!is.na(profile$Logo)) {
  fl_content <- gsub("logo.png", profile$Logo, fl_content)
} else {
  file.copy(file.path(template_path, "logo.png"), "logo.png")
  #fl_content <- fl_content[!grepl("logo.png", fl_content)]
}
write_lines(fl_content, out_file, append = TRUE)

# Copy aside.md
just_copy(aside_md, out_file)

# Part 4: main ------------------------------------------------------------
input_file <- file.path(template_path, "template_04_main.Rmd")
just_copy(input_file, out_file)

# Copy intro.md
just_copy(intro_md, out_file)

if ("research_positions" %in% sections) {
  input_file <- file.path(template_path, "template_04_research_experience.Rmd")
  just_copy(input_file, out_file)
}

if ("education" %in% sections) {
  input_file <- file.path(template_path, "template_04_education.Rmd")
  just_copy(input_file, out_file)
}

if ("certificate" %in% sections) {
  input_file <- file.path(template_path, "template_04_certificate.Rmd")
  just_copy(input_file, out_file)
}

if ("teaching_positions" %in% sections) {
  input_file <- file.path(template_path, "template_04_teaching_positions.Rmd")
  just_copy(input_file, out_file)
}

if ("grant" %in% sections) {
  input_file <- file.path(template_path, "template_04_grant.Rmd")
  just_copy(input_file, out_file)
}

if ("book_chapters" %in% sections) {
  input_file <- file.path(template_path, "template_04_book_chapters.Rmd")
  just_copy(input_file, out_file)
}

if ("academic_articles" %in% sections) {
  input_file <- file.path(template_path, "template_04_academic_articles.Rmd")
  message("Copying contents of ", input_file, " to ", out_file)
  fl_content <- readLines(input_file)
  id <- profile$Scholar_id
  if (!is.na(id)) {
    source(file.path(template_path, "citation.R"))
    total_cites <- print_cite_png(id)
    profile$total_cites <- total_cites
    profile$h_index <- ifelse(is.na(profile$`H-index`), 0, profile$`H-index`)
    profile$i10_index <- ifelse(is.na(profile$`I10-index`), 0, profile$`I10-index`)
  } else {
    # No citation info available
    # Delete related rows
    del_i <- which(grepl(":::", fl_content))
    fl_content <- fl_content[-c(del_i[1]:del_i[2])]
  }
  write_lines(fl_content, out_file, append = TRUE)
}

if ("presentation" %in% sections) {
  input_file <- file.path(template_path, "template_04_presentation.Rmd")
  just_copy(input_file, out_file)
}

# Render ------------------------------------------------------------------
rmarkdown::render("index.Rmd")
tryCatch(
  pagedown::chrome_print("index.html", "index.pdf"),
  error = function(e) {
    message(e$message)
    message("PDF cannot be generated, please print pdf by your own.")
  }
)

# Generate result directory

if (dir.exists("cv")) {
  message("Directory cv already exists, delete it firstly!")
  unlink("cv", recursive = TRUE)
}
dir.create("cv")

save.image()

all_files <- c(
    "styles.css",
    "index.Rmd",
    "index.html",
    "index.pdf",
    "citation.png",
    if (file.exists("logo.png")) "logo.png" else NULL,
    ".RData"
)
suppressWarnings({
  file.copy(all_files, to = "cv")
  file.remove(all_files)
})

message("Open index.html under cv directory to check your CV!")
