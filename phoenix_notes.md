## Timeline
* 0.5 days to get to grips with running, generating basic models, routes, set up IDE etc.
* 0.75 days - relations, controllers, testing, debugging

## Gotchas
* Generated controllers *have* to be routed in order for code to compile
* `x \n |> y` == `y(x)`
* Iex = pry
* have to manually populate relations in order to have their context available
* Have to pass data from controllers (assignments) in order to be visible in views
* Quite a bit more boilerplate eg. Associations (populate everywhere), 'dig'
* Run tests one by one! (spacemacs m-t-t with cursor on test)

## Checklist
* Testing story: Pretty good - 
  - but generated tests don't seperate factories/fixtures properly
  - Association depth is a pain (if you have assignment - employee - department, mocked data
    includes all relationships, which doesn't represent what you normally want on your api,
    breaking default tests)
* Tooling: Almost as good as rails
* Debugging: A bit trickier - error messages not super great
* Generation: better than rails

## Articles
* Phoenix 1.3 https://medium.com/wemake-services/why-changes-in-phoenix-1-3-are-so-important-2d50c9bdabb9
* Upgrade notes to 1.3 https://gist.github.com/chrismccord/71ab10d433c98b714b75c886eff17357
* Elixir capistrano alt https://github.com/boldpoker/edeliver
