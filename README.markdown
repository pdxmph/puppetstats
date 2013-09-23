# PuppetStats

This is a little analytics project in Padrino. It doesn't do much right now but:

- Import a list of nodes (think: blog posts) from a JSON feed provided by a Drupal instance
- Gather basic analytics data for the nodes (e.g. pageviews, bounces, visits) in set (arbitrary) intervals from the publication date of a post 
- Do some basic reporting 

## Why?

Google Analytics is awesome, but it doesn't understand some things that are nice to understand about what it's tracking, like how old it is or who wrote it.

There are ways to wedge in "how old" and "who wrote it," but it's still not easy to make a lot of generalizations about the data in GA because it doesn't think in terms of "how many views did all these things have when they were each 30 days old." It thinks "how many views did all these things have on the date range of the current report."

