#!/usr/bin/env ruby

require 'open-uri'
require 'nokogiri'

class Pinarchive
  # Archive a single board url to the given directory
  def archive_board(board_url, outdir, page=1)
    doc = Nokogiri(open("#{board_url}?page=#{page}"))
    title = doc.css('h1 strong').text.strip
    num_pins = doc.css('#BoardStats strong')[1].text.strip.to_i
    board_dir = File.join(outdir, File.split(board_url)[-1])

    Dir.mkdir(board_dir) unless File.exists?(board_dir)

    current_pins = Dir.glob(File.join(board_dir, '*')).map { |x| File.split(x)[-1] }
    new_pins = []

    doc.css('.pin').each do |pin|
      url = pin.attr('data-closeup-url')
      filename = url.split('/')[-1]
      outpath = File.join(board_dir, filename)

      unless File.exists?(outpath)
        new_pins.push(filename)
        `curl #{url} -o #{outpath}`
      end
    end

    unless new_pins.empty?
      puts "Archived #{new_pins.length} new pins from #{board_url}"
      archive_board(board_url, outdir, page+1)
    end
  end

  # Archive every board in a user's account to a given directory
  def archive_user(user_url, outdir)
    doc = Nokogiri(open(user_url))
    puts "Archiving #{doc.css('.pinBoard').length} boards from #{user_url}"
    doc.css('.pinBoard').each do |board|
      path = board.css('a').attr('href').value
      url = "http://pinterest.com#{path}"
      archive_board(url, outdir)
    end
  end

  def archive_url(url, outdir)
    outdir ||= '.'

    unless url.start_with?("http")
      url = 'http://' + url
    end

    if url.match(/pinterest.com\/[^\/]+\/[^\/]+/)
      archive_board(url, outdir)
    elsif url.match(/pinterest.com\/[^\/]+/)
      archive_user(url, outdir)
    else
      wrong_syntax
    end
  end

  def wrong_syntax
    puts <<END
Usage: pinarchive http://pinterest.com/USER/[BOARD] [OUTPUT_DIR]

Archive a Pinterest board to a local directory. Will not download pins
that are already present, so may be invoked repeatedly to keep a copy
of a Pinterest account up to date!

If [BOARD] is omitted, all boards in the user's account will be downloaded.
New directories will be created for each board under [OUTPUT_DIR], which
defaults to the current working directory.

END
    exit(-1)
  end
end
