#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'

filenames = %w[
  base.rb
  boss.rb
  config.rb
  database.rb
  factory.rb
  formatter.rb
  jeff.rb
  migration.rb
  neil.rb
  payments.rb
  whatever.rb
]

subdirs = %w[
  foo
  bar
  baz
  quux
  spam
  thud
  zork
]

main_dirs = %w[
  app
  bin
  config
  lib
  spec
]

# what is my problem
$leaf_dirs = []

def generate_subdirs(prefix, subdirs)
  if subdirs.empty?
    $leaf_dirs << prefix
    return [prefix]
  end

  subdirs.map do |dir|
    new_prefix = "#{prefix}/#{dir}"
    new_subdirs = subdirs - [dir]

    [
      new_prefix,
      generate_subdirs(new_prefix, new_subdirs)
    ].flatten
  end.flatten
end

dirs = main_dirs.map do |dir|
  generate_subdirs(dir, subdirs)
end.flatten.uniq

dirs.each do |dir|
  FileUtils.mkdir_p(dir)
end

$leaf_dirs.each do |dir|
  filenames.each do |file|
    FileUtils.touch("#{dir}/#{file}")
  end
end

puts "Created #{dirs.size} dirs"
puts "Created #{$leaf_dirs.size * filenames.size} files"
