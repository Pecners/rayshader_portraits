# About

This repo houses code I use to create shaded relief graphics using the [`rayshader`](https://www.rayshader.com/) R package by [Tyler Morgan-Wall](https://twitter.com/tylermorganwall). I'm walking in the giant steps of Twitter user [flotsam](https://twitter.com/researchremora) whose graphics originally inspired me, and tips + code snippets they shared helped immensely as I was just learning how to make these.

I've been making these graphics for a while (see my [gallery](https://spencerschien.info/gallery/shaded-relief/)) and wanted to share code from the start, but I was self-conscious about the state of my code. This repo is an effort to better organize my code so I can be confident in sharing it.

## Repo Structure

Code to create each graphic has its own directory within the [R/portraits](R/portraits) directory, and helper functions can be found in the [R/utils](R/utils) directory. 

Graphics are written to an `images` directory, but I'm not tracking it here because the graphics tend to be pretty large files. Instead, I copy the smaller version of the graphics (created for posting to platforms like Instagram or Reddit where file size limits are enforced) to the [tracked_graphics](tracked_graphics) directory so there is something to showcase here.

## Workflow

Here's a sample workflow you could use to repurpose this code for your own geography (assuming you've forked or otherwise copied this directory):

1. Call `.new_portrait()` to start work on a portrait. This function takes one argument, which is the name of the map. 
    - If it is based on a US National Park, the name will be used to filter the master list of park geometries for the one you specified in the function call. 
    - This function will create a new directory within `R/portraits`, with the directory name determined by `map` argument in the the function call.
    - `.new_portrait()` is loaded whenever you open the project via the `.Rprofile` file, but it remains hidden from the environment because its name begins with a leading period.
1. Run the code in the `render_graphic.R` file, an example of which is  [R/portraits/bryce_canyon/render_graphic.R](R/portraits/bryce_canyon/render_graphic.R).
    - If you're changing things up at all, this will be an iterative process. 
    - Start with a lower `z` value so you're working with less data, and it's easier to iterate as you work to to get everything set how you want it.
    - When you're ready to render the final graphic, bump it up to the highest resolution you want.
1. Run the code in `markup.R` (e.g. [R/portraits/bryce_canyon/markup.R](R/portraits/bryce_canyon/markup.R)), adjusting the code as necessary for your given scenario.
    - The code is structured to allow for aligning text, but currently I have only built it out to allow for center aligned. Aligning to left or right will involve handling those settings by setting `{magick}`'s `gravity` argument to 'west' or 'east', and then adjusting the coords accordingly. You could achieve this directly with `{magick}` as well if you want more direct control.
    - I'm making improvements to the `utils` functions as I go, so earlier render and markup scripts might need updating to work with new functions. I am not maintaining backwards compatibility. 
1. The code as I've written it will save two files, one at a higher resolution, and one at a lower resolution that should fall under the limits for sites like Instagram and Reddit.

# Graphics

## [Georgia Population Density](R/portraits/georgia)

![Georgia Population Density](tracked_graphics/titled_ga_pop_small.png)

## [The Nile Population Density](R/portraits/nile)

![The Nile Population Density](tracked_graphics/titled_nile_river_pop_small.png)

## [North Carolina Population Density](R/portraits/north_carolina)

![North Carolina Population Density](tracked_graphics/titled_nc_pop_small.png)

## [Minnesota Population Density](R/portraits/minnesota)

![Minnesota Population Density](tracked_graphics/titled_mn_pop_small.png)

## [Colorado River Population Density](R/portraits/colorado_river)

![Colorado River Population Density](tracked_graphics/titled_co_river_pop_small.png)

## [Michigan Population Density](R/portraits/michigan_pop)

![Michigan Population Density](tracked_graphics/titled_mi_pop_small.png)

## [Death Valley](R/portraits/death_halloween)

![Death Valley](tracked_graphics/death_halloween_titled_halloween_insta_small.png)

## [Pillars of Creation](R/portraits/pillars_combined)

![Pillars of Creation](tracked_graphics/pillars_together_titled_none_insta_small.png)

## [Pillars of Creation](R/portraits/fourth_pillars)

![Pillars of Creation](tracked_graphics/fourth_pillars_titled_glacier_arches2_insta_small.png)

## [Pillars of Creation](R/portraits/fifth_pillars)

![Pillars of Creation](tracked_graphics/fifth_pillars_titled_pink_greens_insta_small.png)

## [Pillars of Creation](R/portraits/third_pillars)

![Pillars of Creation](tracked_graphics/third_pillars_titled_pink_green_insta_small.png)

## [Pillars of Creation](R/portraits/pillars_of_creation)

![Pillars of Creation](tracked_graphics/pillars_of_creation_titled_img_insta_small.png)

## [Pillars of Creation](R/portraits/death_pillars)

![Pillars of Creation](tracked_graphics/death_pillars_titled_gray_jolla_insta_small.png)

## [Mount Katmai](R/portraits/mount_katmai)

![Mount Katmai](tracked_graphics/mount_katmai_titled_acadia_insta_small.png)

## [Katmai National Park](R/portraits/katmai_bear)

![Katmai National Park](tracked_graphics/katmai_bear_titled_golden_brown_insta_small.png)

## [Kobuk Valley National Park](R/portraits/kobuk)

![Kobuk Valley National Park](tracked_graphics/kobuk_titled_alaska_flag_insta_small.png)

## [Voyageurs National Park](R/portraits/voyageurs)

![Voyageurs National Park](tracked_graphics/voyageurs.gif)

## [Voyageurs National Park](R/portraits/voyageurs)

![Voyageurs National Park](tracked_graphics/voyageurs_titled_gray_jolla_insta_small.png)

## [Voyageurs National Park](R/portraits/voyageurs)

![Voyageurs National Park](tracked_graphics/voyageurs_titled_blue_green_insta_small.png)

## [Washington National Parks](R/portraits/washington_3)

![Washington National Parks](tracked_graphics/washington_3_titled_glacier_arches2_insta_small.png)


## [North Cascades National Park](R/portraits/north_cascade)

![North Cascades National Park](tracked_graphics/north_cascade_titled_glacier_arches2_insta_small.png)


## [Mount Rainier National Park](R/portraits/rainier)

![Mount Rainier National Park](tracked_graphics/rainier_titled_glacier_arches2_insta_small.png)

## [Olympic National Park](R/portraits/olympic)

![Olympic National Park](tracked_graphics/olympic_titled_glacier_arches2_insta_small.png)

## [Congaree National Park](R/portraits/congaree)

![Congaree National Park](tracked_graphics/congaree_titled_pink_greens_insta_small.png)

## [Badlands National Park](R/portraits/badlands)

![Badlands National Park](tracked_graphics/badlands_titled_tangerine_blues_insta_small.png)

## [Mighty Five National Parks of Utah](R/portraits/mighty_5)

![Mighty Five National Parks of Utah](tracked_graphics/mighty_5_titled_okeeffe_insta_small.png)

## [Bryce Canyon National Park](R/portraits/bryce)

![Bryce Canyon National Park](tracked_graphics/bryce_titled_okeeffe_insta_small.png)

## [Zion National Park](R/portraits/zion)

![Zion National Park](tracked_graphics/zion_titled_okeeffe_insta_small.png)

## [Arches National Park](R/portraits/arches)

![Arches National Park](tracked_graphics/arches_titled_okeeffe_insta_small.png)

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
