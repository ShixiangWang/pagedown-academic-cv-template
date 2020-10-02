# Code written by Guangchuang Yu, modified by Shixiang
library(ggplot2)
library(tinyscholar)
library(ggstance)
library(ggtree)
library(ggimage)

# library(jsonlite)
# id <- 'DO5oG40AAAAJ'

print_cite_png <- function(id, out = "citation.png") {
  citation <- tinyscholar::tinyscholar(id)$citation
  citation <- citation[-1, ] # remove 'total' row
  names(citation) <- c("year", "cites")
  citation$year <- as.numeric(citation$year)

  citation$year <- factor(citation$year)

  p <- ggplot(citation, aes(cites, year)) +
    geom_barh(stat = "identity", fill = "#96B56C") +
    geom_text2(aes(label = cites, subset = cites > max(cites) / 5), hjust = 1.1, size = 5) +
    labs(caption = "data from Google Scholar") +
    scale_x_continuous(position = "top") +
    theme_minimal(base_size = 14) +
    xlab(NULL) +
    ylab(NULL) +
    theme(
      panel.grid.major.y = element_blank(),
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_line(linetype = "dashed"),
      plot.caption = element_text(colour = "grey30")
    ) +
    theme_transparent()

  ggsave(p, file = out, width = 3.5, height = 6, bg = "transparent")
  return(sum(citation$cites))
}

## library(magick)
## p <- image_read("citation.png")
## p <- image_transparent(p, "white")
## image_write(p, path="citation.png")
