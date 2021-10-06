# frozen_string_literal: true

require 'optparse'
task :deSetify do |args|
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

def get_tracklist(video)
  comments = get_comments(video)

  comments.each do |comment|
    comm = get_comment_array(comment)

    return comm if comm.count > 4
  end
end

def get_comments(video)
  Yt.configure { |config| config.api_key = ENV['YOUTUBE_API_KEY'] }
  ytvideo = Yt::Video.new(id: video)
  ytvideo.comment_threads.where(order: 'relevance').take(100).map(&:text_display)
end

def get_comment_array(comment)
  
  clean_comm = []

  #Remove all whitespaces from string.
  comm = comment.gsub(/\s+/, "")

  #Convert all breaklines into spaces.
  
  comm = comm.gsub! '<br>', ' '

  #gsub! converts comm to nil if a <br> is not found.
  if !comm.nil?
    #Split into array separated by spaces.
    comm = comm.split
    comm.each do |comm_str|
      clean_comm.append(comm_str.partition('</a>').last) if !comm_str.index('</a>').nil?
    end
  else
    return clean_comm
  end
  return clean_comm
end
