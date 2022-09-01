# About

This repo houses code I use to create shaded relief graphics using the [`rayshader`](https://www.rayshader.com/) R package by [Tyler Morgan-Wall](https://twitter.com/tylermorganwall). I'm walking in the giant steps of Twitter user [flotsam](https://twitter.com/researchremora) whose graphics originally inspired me, and tips + code snippets they shared helped immensely as I was just learning how to make these.

I've been making these graphics for a while (see my [gallery](https://spencerschien.info/gallery/shaded-relief/)) and wanted to share code from the start, but I was self-conscious about the state of my code. This repo is an effort to better organize my code so I can be confident in sharing it.

## Repo Structure

Code to create each graphic has its own directory within the [R/portraits](R/portraits) directory, and helper functions can be found in the [R/utils](R/utils) directory. 

Graphics are written to an `images` directory, but I'm not tracking it here because the graphics tend to be pretty large files. Instead, I copy the smaller version of the graphics (created for posting to platforms like Instagram or Reddit where file size limits are enforced) to the [tracked_graphics](tracked_graphics) directory so there is something to showcase here.

## Workflow

Here's a sample workflow you could use to repurpose this code for your own geography (assuming you've forked or otherwise copied this directory):

1. Run the code in the `render_graphic.R` file, an example of which is  [R/portraits/bryce_canyon/render_graphic.R](R/portraits/bryce_canyon/render_graphic.R).
    - If you're changing things up at all, this will be an iterative process. 
    - Start with a lower `z` value so you're working with less data, and it's easier to iterate as you work to to get everything set how you want it.
    - When you're ready to render the final graphic, bump it up to the highest resolution you want.
1. Run the code in `markup.R` (e.g. [R/portraits/bryce_canyon/markup.R](R/portraits/bryce_canyon/markup.R)), adjusting the code as necessary for your given scenario.
    - The code is structured to allow for aligning text, but currently I have only built it out to allow for center aligned. Aligning to left or right will involve handling those settings by setting `{magick}`'s `gravity` argument to 'west' or 'east', and then adjusting the coords accordingly. You could achieve this directly with `{magick}` as well if you want more direct control.
    - I'm making improvements to the `utils` functions as I go, so earlier render and markup scripts might need updating to work with new functions. I am not maintaining backwards compatibility. 
1. The code as I've written it will save two files, one at a higher resolution, and one at a lower resolution that should fall under the limits for sites like Instagram and Reddit.

# Graphics

## [Canyonlands National Park](R/portraits/canyonlands)

![Canyonlands National Park](tracked_graphics/canyonlands_titled_okeeffe_insta_small.png)

## [Capitol Reef National Park](R/portraits/capitol_reef)

![Capitol Reef National Park](tracked_graphics/capitol_reef_titled_okeeffe_insta_small.png)

## [Crater of Vélingara](R/portraits/velingara)

![Crater of Vélingara](tracked_graphics/velingara_titled_blue_eyes_insta_small.png)


## [Eye of the Sahara](R/portraits/eye_of_sahara)

![Eye of the Sahara](tracked_graphics/eye_of_sahara_titled_acadia_insta_small.png)

## [Great Basin](R/portraits/great_basin)

![Great Basin](tracked_graphics/great_basin_titled_olympic_steel_insta_small.png)

## [San Andreas Fault at Temblor Range](R/portraits/san_andreas)

![San Andreas Fault at Temblor Range](tracked_graphics/san_andreas_titled_glacier_lajolla_insta_small.png)

## [Glacier National Park](R/portraits/glacier)

![Glacier National Park](tracked_graphics/glacier_titled_glacier_insta_small.png)

## [Glacier National Park](R/portraits/glacier)

![Glacier National Park](tracked_graphics/glacier_titled_glacier_lajolla_insta_small.png)

## [Kings Canyon National Park](R/portraits/kings_canyon)

![Kings Canyon National Park](tracked_graphics/kings_canyon_titled_glacier_arches2_insta_small.png)

## [Interstate 70](R/portraits/colorado_70)

![Interstate 70](tracked_graphics/colorado_70_titled_alaska_flag_insta_small.png)

## [Sequoia National Park](R/portraits/sequoia)

![Sequoia National Park](tracked_graphics/sequoia_titled_green_gold_insta_small.png)

## [Great Smoky Mountains](R/portraits/smoky_mountains)

![Great Smoky Mountains](tracked_graphics/smoky_titled_gray_jolla_insta_small.png)

## [Bryce Canyon](R/portraits/bryce_canyon)

![Bryce Canyon](tracked_graphics/bryce_titled_glacier_arches2_insta_small.png)
