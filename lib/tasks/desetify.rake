# frozen_string_literal: true

require 'optparse'

task :deSetify => :environment do |args|
  
  include TracklistHelper
  options = {}

  # Retrieve options from command line
  OptionParser.new(args) do |opts|
    opts.on('-t', '--type {type}', 'Type') { |type| options[:type] = type }
    opts.on('-a', '--artist {artist}', 'Artist') { |artist| options[:artist] = artist }
    opts.on('-v', '--video {video}', 'Video') { |video| options[:video] = video }
  end.parse!
  # Type field is mandatory.
  raise OptionParser::MissingArgument if options[:type].nil?
  
  # Retrieve the Tracklist directly if it's already a Set.
  if options[:type] == 'set' || options[:type] == 's'
    raise OptionParser::MissingArgument if options[:video].nil?

    tracklist = get_tracklist(options[:video])
    byebug
  end
end

