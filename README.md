# About

This repo houses code I use to create shaded relief graphics using the [`rayshader`](https://www.rayshader.com/) R package by [Tyler Morgan-Wall](https://twitter.com/tylermorganwall). I'm walking in the giant steps of Twitter user [flotsam](https://twitter.com/researchremora) whose graphics originally inspired me, and tips + code snippets they shared helped immensely as I was just learning how to make these.

I've been making these graphics for a while (see my [gallery](https://spencerschien.info/gallery/shaded-relief/)) and wanted to share code from the start, but I was self-conscious about the state of my code. This repo is an effort to better organize my code so I can be confident in sharing it.

## Repo Structure

Code to create each graphic has its own directory within the [R/portraits](R/portraits) directory, and helper functions can be found in the [R/utils](R/utils) directory. 

Graphics are written to an `images` directory, but I'm not tracking it here because the graphics tend to be pretty large files. Instead, I copy the smaller version of the graphics (created for posting to platforms like Instagram or Reddit where file size limits are enforced) to the [tracked_graphics](tracked_graphics) directory so there is something to showcase here.

## Workflow

Here's a sample workflow you could use to repurpose this code for your own geography (assuming you've forked or otherwise copied this directory):

1. Run the code in the `render_graphic.R` file, an example of which is  [R/portraits/bryce_canyon/render_graphic.R](R/portraits/bryce_canyon/render_graphic.R).
    - If you're changing things up at all, start with a lower `z` value to get everything set how you want it, and when you're ready to render the final graphic, bump it up to the highest resolution you want.
1. Run the code in `markup.R` (e.g. [R/portraits/bryce_canyon/markup.R](R/portraits/bryce_canyon/markup.R)), adjusting the code as necessary for your given scenario.

# Graphics

## [Bryce Canyon](R/portraits/bryce_canyon)

![Bryce Canyon](tracked_graphics/bryce_titled_glacier_arches2_insta_small.png)
