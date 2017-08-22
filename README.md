# Sam's Phish Gem

# Objectives

1. Create a gem that allows me to browse shows and songs performed by Phish
2. User will pick a tour, then pick a show, and then be able to find out info about specific songs. At any point they can back out a layer.

# Overview

I really like Phish, and would really like to make something using them as one of my projects. They have a great fan-made site available at http://phish.net that pain-stakingly catalogues every show (in their known history) and their setlists. I thought it would be cool to be able to browse this using CLI and to have a few nifty nuggets as well like `lastshow` printing out the setlist from their most recent show.

I plan on doing this using Nokogiri and Open-URI, though I may need a few other things along the way.

# Development Status

Currently still in development. Things that are working are:

Look up show by tour year: type `tour` to browse by tour year.

*Things that should work soon*:

1. Look up song by name
2. Look up show by date
3. Look up last played show by `lastshow`
4. Look up most popular songs by `top10`

*Things that are a stretch goal*:

1. Look up random show by `randomshow`
2. Look up random song by `randomsong`
