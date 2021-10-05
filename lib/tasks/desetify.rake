
require 'optparse'

task :deSetify do |args|
  
  options = {}

  # Retrieve options from command line
  OptionParser.new(args) do |opts|
    opts.on("-t", "--type {type}", "Type") { |type| options[:type] = type }
    opts.on("-a", "--artist {artist}", "Artist") { |artist| options[:artist] = artist }
    opts.on("-v", "--video {video}", "Video") { |video| options[:video] = video }
  end.parse!

  # Type field is mandatory.
  raise OptionParser::MissingArgument if options[:type].nil?
  
  if options[:type] = 'set'
    raise OptionParser::MissingArgument if options[:video].nil?
    songs = get_tracklist(options[:video])
    byebug
  end

  # browser = Watir::Browser.new :chrome, url: "https://www.youtube.com/"

  
end

def get_tracklist(video)
  comments = get_comments(video)
  comments.each do |comment|
    break if check_comment(comment) == true
    byebug
  end
  
  byebug
end

def get_comments(video)
  Yt.configure { |config| config.api_key = ENV["YOUTUBE_API_KEY"] }
  ytvideo = Yt::Video.new(id: video)
  return ytvideo.comment_threads.where(order: 'relevance').take(100).map(&:text_display)
end

def check_comment(comment)
  if comment =~ /^(?:(?:([01]?\d|2[0-3]):)?([0-5]?\d):)?([0-5]?\d)$/
    return true
  end
end
