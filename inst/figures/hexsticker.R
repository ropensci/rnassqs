# Create a hex sticker for the package
library(hexSticker)
library(showtext)

## Loading Google fonts (http://www.google.com/fonts)
font_add_google("Cutive Mono", "monospace")

## Automatically use showtext to render text for future devices
showtext_auto()

imgfile <- "inst/figures/profile.png"
sticker(imgfile, 
        package="rnassqs", p_family = "monospace",
        p_size=20, p_color = "#3B2B13", p_y = 1.44,
        s_x=1, s_y=1, s_width=.95,
        h_size = 1, h_fill = "#E1E8F2", h_color = "#3B2B13",
        filename="inst/figures/rnassqs.png")
