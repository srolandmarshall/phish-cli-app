# Sam's Phish Gem

# Objectives

1. Create a gem that allows me to browse shows and songs performed by Phish
2. User will pick a tour, then pick a show, and then be able to find out info about specific songs. At any point they can back out a layer.

# Overview

I really like Phish, and would really like to make something using them as one of my projects. They have a great fan-made site available at http://phish.net that pain-stakingly catalogues every show (in their known history) and their setlists. I thought it would be cool to be able to browse this using CLI and to have a few nifty nuggets as well like `lastshow` printing out the setlist from their most recent show.

# How to Use

1. Open terminal
2. `cd` to the phish-cli-app folder
3. `bundle install` to get necessary gems (not that many)
4. `ruby bin/run` to start the app

EASY!


# Development Status

Currently still in development, current release is Alpha .1

https://youtu.be/j0UGw3qW9qs

# Commands

*Things that are working are:*

1. Look up show by tour year: type `tour` to browse by tour year.
2. Look up song by name: `song` then type the song title. Type `Yes` for extended song info (albums, vocals, recommended versions) `lyrics` or `history` at the `"Do you want to know more?"` prompt for those goodies.
3. Look up show by date: type `show` at the menu to get a choice to search by tour or by `date`. Type in the date in either of the listed formats and be shown a show on that date if it exists. Still works a little wonky if two+ shows were played on that day.

*Things that should work soon*:

1. Look up last played show by `lastshow`
2. Look up most popular songs by `top10`

*Things that are a stretch goal*:

1. Look up random show by `randomshow`
2. Look up random song by `randomsong`
