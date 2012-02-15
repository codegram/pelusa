# pelusa - /pe 'lu sa/ [![Build Status](https://secure.travis-ci.org/codegram/pelusa.png)](http://travis-ci.org/codegram/pelusa)
## A Ruby Lint to improve your OO skills

Pelusa is a static analysis tool and framework to inspect your code style and
notify you about possible red flags or missing best practices.

Above all pelusa _doesn't run your code_ -- it just analyzes it syntactically
to gain superficial insights about it, and raise red flags when needed.

Pelusa needs [Rubinius](http://rubini.us) to run, due to how easy it is to work
with a Ruby AST with it, but it doesn't mean that your Ruby code must run on
Rubinius. Since it's a static analysis tool, pelusa doesn't care what your code
runs on, it just looks at it and tells you stuff.

Here's a sample of pelusa linting on its own code base:

![](http://f.cl.ly/items/3Z341M0q2u1K242m0144/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202012-02-14%20%D0%B2%203.29.38%20PM.png)

## Why Pelusa?

Pelusa happens to be Spanish for the word "Lint". Yeah, I couldn't believe it
either.

## Install and usage

    rvm use rbx-head
    gem install pelusa

To run pelusa, you must run Rubinius in 1.9 mode. To do this, export this
environment variable:

    export RBXOPT=-X19

Then go to a directory where you have some Ruby code, and type this:

    pelusa path/to/some_file.rb

Or just run all the Ruby files (`**/*.rb`) without arguments:

    pelusa

## About the default set of Lints

This project was born as an inspiration from [one of our Monday
Talks](http://talks.codegram.com/object-oriented-nirvana) about Object Oriented
Nirvana by [@oriolgual](http://twitter.com/oriolgual). After reading [this blog
post](http://binstock.blogspot.com/2008/04/perfecting-oos-small-classes-and-short.html)
he prepared his talk and I ([@txustice](http://twitter.com/txustice)) found it interesting, so I explored the
possibility of programmatically linting these practices on a Ruby project. This
*doesn't mean* that any of us thinks these are the true and only practices of
Object Orientation, it's just a set of constraints that are fun to follow to
achieve a mindset shift in the long run.

Anyway, you are always free to implement your own lints, or the ones that suit
your team the best.

## Pelusa as a static analysis framework

With Pelusa, writing your own lints becomes very easy. Check out some of the
default lints under the `lib/pelusa/lint/` directory.

At some point it will be user-extendable by default, but for now you are better
off forking the project and adding your own lints as you need them in your team
(or removing some default ones you don't like).

## Special mentions

The beautiful UTF-8 flowers before each lint ran are taken from [Testosterone](http://github.com/masylum/testosterone),
a project by [@masylum](http://twitter.com/masylum). They're really beautiful,
thanks!!!

## Contributing

You can easily contribute to Pelusa. Its codebase is simple and
[extensively documented][documentation].

* Fork the project.
* Make your feature addition or bug fix.
* Add specs for it. This is important so we don't break it in a future
  version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  If you want to have your own version, that is fine but bump version
  in a commit by itself I can ignore when I pull.
* Send me a pull request. Bonus points for topic branches.

[documentation]: http://rubydoc.info/github/codegram/pelusa/master/frames

## License

MIT License. Copyright 2011 [Codegram Technologies](http://codegram.com)

