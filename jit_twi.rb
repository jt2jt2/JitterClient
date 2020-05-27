#Twitterライブラリ呼び出し
require 'twitter'
require 'open-uri'
require 'fastimage'


@client = Twitter::REST::Client.new do |config|
	config.consumer_key = ""
	config.consumer_secret = 	""
	config.access_token =	""
	config.access_token_secret = 	""
end


def tutorial
	puts "Welcome to jittu Client."
	puts "このclientを起動するときは末尾にoptionをつけてください"
	puts "-t TL取得"
	puts "-r リプライ取得"
    puts "-f TL一括ファボ"
    puts "-c 自分のTLを取得"
    puts "-s 検索機能"
    puts "-g 検索して画像保存"
	puts "ツイートしたい内容のツイート"
end

def homeTimeline
  @client.home_timeline.each do |tweet|
    puts "\e[33m" + tweet.user.name + "\e[32m" + "[ID:" + tweet.user.screen_name + "]"
    puts "\e[0m" + tweet.text
  end
end


def favorite
  @client.home_timeline.each do |tweet|
  	puts "\e[33m" + tweet.user.name + "\e[32m" + "[ID:" + tweet.user.screen_name + "]"
    puts "\e[0m" + tweet.text
   @client.favorite(tweet)
  end
  puts "ふぁぼったよ"
end



def mentionTimeline
	@client.mentions_timeline.each do |tweet|
		puts "\e[33m" + tweet.user.name + "\e[32m" +"[ID:"+ tweet.user.screen_name + "]"
		puts "\e[0m" + tweet.text
	end
end

def tweet
	@client.update(ARGV[0])
	puts "Tweetしたよ！"
end


def checkTimeline(name)
    @client.user_timeline(name).each do |tweet|
        puts "\e[33m" + tweet.user.name + "\e[32m" + "[ID:" + tweet.user.screen_name + "]"
        puts "\e[0m" + tweet.text
    end
end

def searchTimeline(name)
    @client.search(name).take(100).each do |tweet|
        if (!tweet.text.include?("RT")) then
            puts "\e[33m" + tweet.user.name + "\e[32m" + "[ID:" + tweet.user.screen_name + "]"
            puts "\e[0m" + tweet.text
        end
    end
end

def searchAndGetPic(key_word)
  tweets = @client.search(key_word).take(100)
  imgs = []

  folder_name = key_word.to_s
  imgs.concat tweets.flat_map { |s| s.media }.flat_map { |m|
                case m
                when Twitter::Media::AnimatedGif
                  m.video_info.variants.map { |v| v.url.to_s }
                when Twitter::Media::Photo
                  m.media_url.to_s
                else
                  []
                end
              }
  imgs.concat tweets.flat_map { |s| s.urls }.flat_map { |u|
                case FastImage.type(u.url.to_s)
                when :bmp, :gif, :jpeg, :png, :webm 
                  u.expanded_url.to_s
                else
                  []
                end
              }
  imgs.each do |url|
  file_name = File.basename(url).chomp
  file_path = "./index/#{file_name}"
    File.open(file_path, 'w') do |f|
    f.write open(url).read
    puts "true"
    end
  end
end


def searchAndGetPicUser(name)
  tweets = @client.user_timeline(name).take(150)
  imgs = []

  imgs.concat tweets.flat_map { |s| s.media }.flat_map { |m|
                case m
                when Twitter::Media::AnimatedGif
                  m.video_info.variants.map { |v| v.url.to_s }
                when Twitter::Media::Photo
                  m.media_url.to_s
                else
                  []
                end
              }
  imgs.concat tweets.flat_map { |s| s.urls }.flat_map { |u|
                case FastImage.type(u.url.to_s)
                when :bmp, :gif, :jpeg, :png, :webm
                  u.expanded_url.to_s
                else
                  []
                end
              }
  imgs.each do |url|
  file_name = File.basename(url).chomp
  file_path = "./index/#{file_name}"
    File.open(file_path, 'w') do |f|
    f.write open(url).read
    puts "true"
    end
  end
end


def searchAndGetMov(key_word)
  tweets = @client.search(key_word).take(100)
  imgs = []

  folder_name = key_word.to_s
  imgs.concat tweets.flat_map { |s| s.media }.flat_map { |m|
                case m
                when Twitter::Media::AnimatedGif
                  m.video_info.variants.map { |v| v.url.to_s }
                when Twitter::Media::
                  m.media_url.to_s
                else
                  []
                end
              }
  imgs.concat tweets.flat_map { |s| s.urls }.flat_map { |u|
                case FastImage.type(u.url.to_s)
                when :mp4 , :gif
                  u.expanded_url.to_s
                else
                  []
                end
              }
  imgs.each do |url|
  file_name = File.basename(url).chomp
  file_path = "./movie/#{file_name}"
    File.open(file_path, 'w') do |f|
    f.write open(url).read
    puts "true"
    end
  end
end

option = ARGV[0].to_s
value = ARGV[1].to_s

if option == "" then
	tutorial
elsif option == "-t" then
	homeTimeline
elsif option == "-r" then
	mentionTimeline
elsif option == "-f" then
	favorite
elsif option == "-c" then
  checkTimeline(value)
elsif option == "-s" then
  searchTimeline(value)
elsif option == "-g" then
  searchAndGetPic(value)
elsif option == "-k" then
  searchAndGetPicUser(value)
elsif option == "-m" then
  searchAndGetMov(value)
else
	tweet
	homeTimeline
end
