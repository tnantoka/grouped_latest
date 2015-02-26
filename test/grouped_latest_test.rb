require 'test_helper'

class GroupedLatestTest < ActiveSupport::TestCase
  setup do
  end

  test "sanity" do
    assert_kind_of Module, GroupedLatest
  end

  test "::grouped_latest" do
    return if with_bench?

    init

    assert_equal Category.first.posts.last,
      @user.posts.grouped_latest(:category_id).where(category_id: Category.first.id).take

    Post.latest_column = :created_at
    assert_equal Category.last.posts.last,
      @user.posts.grouped_latest(:category_id).where(category_id: Category.last.id).take
  end

  test "benchmark" do
    return unless with_bench?

    init

    result = ['', "Strategy\tAverage"]
    %w(gl_arel_in gl_arel_exists gl_array_in).each do |strategy|
      result << bench(strategy)
    end
    puts result.join("\n")
  end

  def bench(strategy)
    assert_equal Category.first.posts.last,
      @user.posts.send(strategy, :category_id).where(category_id: Category.first.id).take

    results = 0
    number_of[:bench].times do
      result = Benchmark.realtime { @user.posts.send(strategy, :category_id) }
      results += result
    end
    "#{strategy}\t#{(results / number_of[:bench]) * 1000}ms"
  end

  def with_bench?
    ENV['BENCH'].present? || ENV['BENCHMARK'].present?
  end

  def wip?
    ENV['WIP'].present?
  end

  def number_of
    if with_bench? && !wip?
      {
        categories: 100,
        posts: 100,
        bench: 1000,
      }
    else
      {
        categories: 2,
        posts: 10,
        bench: 100,
      }
    end
  end

  def init
    ActiveRecord::Base.transaction do
      @user = User.create!(name: 'User 1')
      1.upto(number_of[:categories]) do |i|
        category = Category.create!(name: "Category #{i}")
        1.upto(number_of[:posts]) do |j|
          Post.create!(title: "Post #{i}-#{j}", user: @user, category: category, created_at: (i.day + j.minute).since)
        end
      end
      Post.send(:include, GroupedLatest)
    end
  end
end

