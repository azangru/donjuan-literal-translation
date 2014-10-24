# require 'pry'
require 'open-uri'

class Podstrochnik < Sinatra::Base

  helpers do

    def to_stanzas(text)
      # produces array of stanzas
      stanzas = text.scan(/^(\d.*?)\n\n/m)
    end

    def to_html(text)
      # change \n to <br />
      text.gsub!(/\n/, "<br/>")
    end

    def get_stanza_number(stanza)
      number = stanza.match(/^(\d+?)<br\/>/)[1]
    end

    def remove_number(stanza)
      stanza = stanza.gsub(/^(\d+?)<br\/>/, '<br\/>')
    end

    def annotate(text)
      # put links to commentaries:
      # - count number of |com-<digits>| tags
      number_of_comments = text.scan(/\|com-(\d.*?)\|/).length
      # - walk through the text and change |com-<digits>| tags
      number_of_comments.times do |num|
        comment_number = text.match(/\|com-(\d.*?)\|/)[1]
        text.sub!(/\|com-(\d.*?)\|/, "<a href='#' class='comment' data-comment='#{comment_number}'>*</a>")
      end
      # - count number of |alt-<digits>| tags
      number_of_alternatives = text.scan(/\|alt-(\d.*?)\|/).length
      # - walk through the text and change |alt-<digits>| tags
      number_of_alternatives.times do |num|
        alt_number = text.match(/\|alt-(\d.*?)\|/)[1]
        text.sub!(/\|alt-(\d.*?)\|/, "<a href='#' class='alternative' data-alternative='#{alt_number}'>?</a>")
      end
      text
    end

    def get_comments(text)
      comments = text.scan(/(\\comment.*?})/m)
    end

    def get_alternatives(text)
      alternatives = text.scan(/(\\alternative.*?})/m)
    end

  end


###### ROUTES #######

  get '/' do
    erb :index
  end

  get '/cantos/:name' do
    texts = get_texts("#{params[:name]}")
    @russian_text = texts[:russian]
    annotate(@russian_text)
    @russian_stanzas = to_stanzas(@russian_text).flatten
    @comments = get_comments(@russian_text).flatten
    @alternatives = get_alternatives(@russian_text).flatten
    @english_text = texts[:english]
    @english_stanzas = to_stanzas(@english_text).flatten
    erb :canto
  end


  def get_texts(name)
    russian_text = open("https://rawgit.com/azangru/donjuan-literal-translation/master/russian/#{name}.txt") {|f| f.read }
    english_text = open("https://rawgit.com/azangru/donjuan-literal-translation/master/english/#{name}.txt") {|f| f.read }
    texts = {russian: russian_text, english: english_text}
  end

end
