# About

This repo houses code I use to create shaded relief graphics using the [`rayshader`](https://www.rayshader.com/) R package by [Tyler Morgan-Wall](https://twitter.com/tylermorganwall). I'm walking in the giant steps of Twitter user [flotsam](https://twitter.com/researchremora) whose graphics originally inspired me, and tips + code snippets they shared helped immensely as I was just learning how to make these.

I've been making these graphics for a while (see my [gallery](https://spencerschien.info/gallery/shaded-relief/)) and wanted to share code from the start, but I was self-conscious about the state of my code. This repo is an effort to better organize my code so I can be confident in sharing it.

I also have an online store where I sell prints of a selection of these map. Find that store here: [https://www.rayshadedesigns.com/](https://www.rayshadedesigns.com/).

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

## [Rocky Mountain National Park](R/portraits/rocky_mountain)

![Rocky Mountain National Park](tracked_graphics/rocky_mountain_acadia_small.png)

## [Acadia National Park](R/portraits/acadia)

![Joshua Tree National Park](tracked_graphics/titled_acadia_small.png)

## [Joshua Tree National Park](R/portraits/joshua_tree)

![Joshua Tree National Park](tracked_graphics/titled_jt_small.png)

## [Georgia (Country) Population Density](R/portraits/georgia_country)

![Georgia (Country) Population Density](tracked_graphics/titled_geo_pop_small.png)

## [Gold Coast Population Density](R/portraits/south_florida)

![Gold Coast Population Density](tracked_graphics/titled_gold_coast_small.png)

## [Georgia Pastel Population Density](R/portraits/georgia_pastel)

![Georgia Pastel Population Density](tracked_graphics/titled_ga_pastel_pop_small.png)

## [Georgia Population Density](R/portraits/georgia_again)

![Georgia Population Density](tracked_graphics/titled_ga_pop_small.png)

## [New Mexico Population Density](R/portraits/new_mexico)

![New Mexico Population Density](tracked_graphics/titled_nm_pop_small.png)

## [Tennessee Population Density](R/portraits/tennessee)

![Tennessee Population Density](tracked_graphics/titled_tn_pop_small.png)

## [Colorado Population Density](R/portraits/colorado)

![Colorado Population Density](tracked_graphics/titled_co_pop_small.png)

## [South Dakota Population Density](R/portraits/south_dakota)

![South Dakota Population Density](tracked_graphics/titled_sd_pop_small.png)

## [North Dakota Population Density](R/portraits/north_dakota)

![North Dakota Population Density](tracked_graphics/titled_nd_pop_small.png)

## [Rhode Island Population Density](R/portraits/rhode_island)

![Rhode Island Population Density](tracked_graphics/titled_ri_pop_small.png)

## [Connecticut Population Density](R/portraits/connecticut)

![Connecticut Population Density](tracked_graphics/titled_ct_pop_small.png)

## [New Hampshire Population Density](R/portraits/new_hampshire)

![New Hampshire Population Density](tracked_graphics/titled_nh_pop_small.png)

## [Delaware Population Density](R/portraits/delaware)

![Delaware Population Density](tracked_graphics/titled_de_pop_small.png)

## [East Coast Population Density](R/portraits/east_coast)

![East Coast Population Density](tracked_graphics/titled_east_coast_pop_small.png)

## [West Coast Population Density](R/portraits/west_coast)

![West Coast Population Density](tracked_graphics/titled_west_coast_pop_small.png)

## [Great Lakes Population Density](R/portraits/great_lakes)

![Great Lakes Population Density](tracked_graphics/titled_great_lakes_pop_small.png)

## [New York Population Density](R/portraits/ny_again)

![New York Population Density](tracked_graphics/titled_ny_again_pop_small.png)

## [Kansas Population Density](R/portraits/kansas_again)

![Kansas Population Density](tracked_graphics/titled_kansas_again_pop_small.png)

## [North Carolina Population Density](R/portraits/nc_vice)

![North Carolina Population Density](tracked_graphics/titled_nc_vice_pop_small.png)

## [Alaska Population Density](R/portraits/alaska)

![Alaska Population Density](tracked_graphics/titled_ak_pop_small.png)

## [Maine Population Density](R/portraits/maine)

![Maine Population Density](tracked_graphics/titled_me_pop_small.png)

## [Maryland Population Density](R/portraits/maryland)

![Maryland Population Density](tracked_graphics/titled_md_pop_small.png)

## [Montana Population Density](R/portraits/montana)

![Montana Population Density](tracked_graphics/titled_mt_pop_small.png)

## [Vermont Population Density](R/portraits/vermont)

![Vermont Population Density](tracked_graphics/titled_vt_pop_small.png)

## [Massachusetts Population Density](R/portraits/mass_again)

![Massachusetts Population Density](tracked_graphics/titled_ma_again_pop_small.png)

## [Massachusetts Population Density](R/portraits/massachusetts)

![Massachusetts Population Density](tracked_graphics/titled_ma_pop_small.png)

## [Hawaii Population Density](R/portraits/hawaii)

![Hawaii Population Density](tracked_graphics/titled_hi_pop_small.png)

## [Florida Population Density (Again)](R/portraits/florida_again)

![Florida Population Density](tracked_graphics/titled_fl_pop_small.png)

## [Nevada Population Density](R/portraits/nevada)

![Nevada Population Density](tracked_graphics/titled_nv_pop_small.png)

## [Arkansas Population Density](R/portraits/arkansas)

![Arkansas Population Density](tracked_graphics/titled_ar_pop_small.png)

## [Texas Cities Population Density](R/portraits/tx_cities)

![Texas Cities Population Density](tracked_graphics/titled_tx_cities_pop_small.png)


## [Texas Population Density](R/portraits/texas)

![Texas Population Density](tracked_graphics/titled_tx_pop_small.png)

## [Wyoming Population Density](R/portraits/wyoming)

![Wyoming Population Density](tracked_graphics/titled_wy_pop_small.png)

## [Alabama Population Density](R/portraits/alabama)

![Alabama Population Density](tracked_graphics/titled_al_pop_small.png)

## [West Virginia Population Density](R/portraits/west_virginia)

![West Virginia Population Density](tracked_graphics/titled_wv_pop_small.png)

## [Missouri Population Density](R/portraits/missouri)

![Missouri Population Density](tracked_graphics/titled_mo_pop_small.png)

## [Utah Population Density](R/portraits/utah)

![Utah Population Density](tracked_graphics/titled_ut_pop_small.png)

## [Nebraska Population Density](R/portraits/nebraska)

![Nebraska Population Density](tracked_graphics/titled_ne_pop_small.png)

## [Oklahoma Population Density](R/portraits/oklahoma)

![Oklahoma Population Density](tracked_graphics/titled_ok_pop_small.png)

## [Wisconsin Population Density](R/portraits/wisconsin_again)

![Wisconsin Population Density](tracked_graphics/titled_wi_again_pop_small.png)

## [Young Stellar Object](R/portraits/young_stellar_object)

![Young Stellar Object](tracked_graphics/titled_yso_small.png)

## [California Population Density](R/portraits/california)

![California Population Density](tracked_graphics/titled_ca_pop_small.png)

## [Comparative Population Density: Seattle and Phoenix](R/portraits/sea_pheo)

![Comparative Population Density: Seattle and Phoenix](tracked_graphics/titled_sea_pheo_pop_small.png)

## [Grand Canyon Rims](R/portraits/gc_oval)

![Grand Canyon Rims](tracked_graphics/titled_gc_oval_small.png)

## [Louisiana Population Density](R/portraits/louisiana)

![Louisiana Population Density](tracked_graphics/titled_la_pop_single_small.png)

## [Louisiana Parade Population Density](R/portraits/louisiana)

![Louisiana Parade Population Density](tracked_graphics/titled_la_pop_small.png)

## [Iowa Population Density](R/portraits/iowa)

![Iowa Population Density](tracked_graphics/titled_ia_pop_small.png)

## [New Jersey Population Density](R/portraits/new_jersey)

![New Jersey Population Density](tracked_graphics/titled_nj_pop_small.png)

## [Kentucky Population Density](R/portraits/kentucky)

![Kentucky Population Density](tracked_graphics/titled_ky_pop_small.png)

## [Idaho Population Density](R/portraits/new_york)

![Idaho Population Density](tracked_graphics/titled_ny_pop_small.png)

## [Comparative Population Density: Cincinnati and Kansas City](R/portraits/cin_kc)

![Comparative Population Density: Cincinnati and Kansas City](tracked_graphics/titled_cin_kc_pop_small.png)

## [Comparative Population Density: Philadelphia and San Francisco](R/portraits/phi_sf)

![Comparative Population Density: Philadelphia and San Francisco](tracked_graphics/titled_phi_sf_pop_small.png)

## [Population Density along Interstate 95](R/portraits/i95)

![Population Density along Interstate 95](tracked_graphics/titled_i95_pop_small.png)

## [Comparative Population Density: Chicago and NYC](R/portraits/chi_nyc)

![Comparative Population Density: Chicago and NYC](tracked_graphics/titled_chi_nyc_pop_small.png)

## [New York Population Density](R/portraits/new_york)

![New York Population Density](tracked_graphics/titled_ny_pop_small.png)

## [South Carolina Population Density](R/portraits/south_carolina)

![South Carolina Population Density](tracked_graphics/titled_sc_pop_small.png)

## [Oregon Population Density](R/portraits/oregon)

![Oregon Population Density](tracked_graphics/titled_or_pop_small.png)

## [Comparative Population Density: St. Louis and Milwaukee](R/portraits/stl_mke)

![Comparative Population Density: St. Louis and Milwaukee](tracked_graphics/titled_stl_mke_pop_small.png)

## [Indiana Population Density](R/portraits/indiana)

![Indiana Population Density](tracked_graphics/titled_in_pop_small.png)

## [Densité de population le long de la Seine et la Tamise](R/portraits/seine_thames_comp)

![Densité de population le long de la Seine et la Tamise](tracked_graphics/titled_seine_thames_pop_small_fr.png)

## [Population Density along the Seine and Thames Rivers](R/portraits/seine_thames_comp)

![Population Density along the Seine and Thames Rivers](tracked_graphics/titled_seine_thames_pop_small.png)

## [Population Density along the Thames](R/portraits/thames)

![Population Density along the Thames](tracked_graphics/titled_thames_pop_small.png)

## [Densité de population le long de la Seine](R/portraits/seine)

![Densité de population le long de la Seine](tracked_graphics/titled_seine_pop_fr_small.png)

## [Population Density along the River Seine](R/portraits/seine)

![Population Density along the River Seine](tracked_graphics/titled_seine_pop_small.png)

## [Arizona Population Density](R/portraits/arizona)

![Arizona Population Density](tracked_graphics/titled_az_pop_small.png)

## [New England Population Density](R/portraits/new_england)

![New England Population Density](tracked_graphics/titled_new_england_pop_small.png)

## [Mississippi Population Density](R/portraits/mississippi)

![Mississippi Population Density](tracked_graphics/titled_ms_pop_small.png)

## [Lake Geneva Population Density](R/portraits/lake_geneva)

https://user-images.githubusercontent.com/47727946/209483858-91c3afed-be72-4fd5-8ba8-0ec8a64ad0b6.mp4


## [Washington Population Density](R/portraits/washington)

![Washington Population Density](tracked_graphics/titled_wa_pop_small.png)

## [Mediterranean Coast Population Density](R/portraits/med)

![Mediterranean Coast Population Density](tracked_graphics/titled_med_pop_small.png)

## [Illinois Population Density](R/portraits/illinois)

![Illinois Population Density](tracked_graphics/titled_il_pop_small.png)

## [Kansas Population Density](R/portraits/kansas)

![Kansas Population Density](tracked_graphics/titled_ks_pop_small.png)

## [Amazon River Population Density](R/portraits/amazon)

![Amazon River Population Density](tracked_graphics/titled_amazon_river_pop_small.png)

## [Virginia Population Density](R/portraits/virginia)

![Virginia Population Density](tracked_graphics/titled_va_pop_small.png)

## [Pennsylvania Population Density](R/portraits/pennsylvania)

![Pennsylvania Population Density](tracked_graphics/titled_pa_pop_small.png)

## [Ohio Population Density](R/portraits/ohio)

![Ohio Population Density](tracked_graphics/titled_oh_pop_small.png)

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

## [Great Smoky Mountains](R/portraits/great_smoky_mountains)

![Great Smoky Mountains](tracked_graphics/smoky_titled_gray_jolla_insta_small.png)

## [Bryce Canyon](R/portraits/bryce_canyon)

![Bryce Canyon](tracked_graphics/bryce_titled_glacier_arches2_insta_small.png)
