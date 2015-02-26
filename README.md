# GroupedLatest

[![Gem Version](https://badge.fury.io/rb/grouped_latest.svg)](http://badge.fury.io/rb/grouped_latest) [![Code Climate](https://codeclimate.com/github/tnantoka/grouped_latest/badges/gpa.svg)](https://codeclimate.com/github/tnantoka/grouped_latest) [![Test Coverage](https://codeclimate.com/github/tnantoka/grouped_latest/badges/coverage.svg)](https://codeclimate.com/github/tnantoka/grouped_latest) [![Circle CI](https://circleci.com/gh/tnantoka/grouped_latest.svg?style=svg)](https://circleci.com/gh/tnantoka/grouped_latest)

GroupedLatest is just another scope to get the latest record from each group.

## Requirement

- Rails 4.2

## Installation

```
# Gemfile
gem 'grouped_latest'
```

## Usage

```
# app/models/post.rb
class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  include GroupedLatest
end

$ rails c
> User.first.post.grouped_latest(:category_id)
```

## Configuration

```
Post.latest_column = :id
Post.latest_strategy = :gl_arel_in
```

## Strategies

WIP. I'm looking for the fastest logic.

```
$ rake test BENCH=1
Strategy        Average
gl_arel_in      0.11766659384011291ms
gl_arel_exists  0.11125772824743763ms
gl_array_in     11.046947546623414ms
```

## Licence

This project rocks and uses MIT-LICENSE.

## Author

[@tnantoka](https://twitter.com/tnantoka)

