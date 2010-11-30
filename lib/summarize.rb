require 'summarize/summarize'

class Hash
  def symbolize_keys
    inject({}) do |options, (key, value)|
      options[(key.to_sym rescue key) || key] = value
      options
    end
  end
end unless {}.respond_to? 'symbolize_keys'

module Summarize
  VERSION = "1.0.0"

  LANGUAGES = [
    'bg', # Bulgarian
    'ca', # Catalan
    'cs', # Czech
    'cy', # Welsh
    'da', # Danish
    'de', # German
    'el', # Greek
    'en', # English
    'eo', # Esperanto
    'es', # Spanish
    'et', # Creole
    'eu', # Basque
    'fi', # Finnish
    'fr', # French
    'ga', # Irish
    'gl', # Galician
    'he', # Hebrew
    'hu', # Hungarian
    'ia', # Interlingua
    'id', # Indonesian
    'is', # Icelandic
    'it', # Italian
    'lv', # Latvian
    'mi', # Maori
    'ms', # Malay
    'mt', # Maltese
    'nl', # Dutch
    'nn', # Norweigan
    'pl', # Polish
    'pt', # Portuguese
    'ro', # Romanian
    'ru', # Russian
    'sv', # Swedish
    'tl', # Tagalog
    'tr', # Turkish
    'uk', # Ukrainian
    'yi'  # Yiddish
  ]

  def self.parse_options(options = {})
    default_options = {
      :ratio => 25,     # percentage
      :language => 'en' # ISO 639-1 code
    }

    options = default_options.merge(options.symbolize_keys)

    if options.key? :dictionary
      dict_file = options[:dictionary]
    else
      raise "Language not supported" unless LANGUAGES.index(options[:language])
      dict_file = File.join(File.expand_path(File.dirname(__FILE__)), "../ext/summarize/dic/#{options[:language]}")
    end

    return [dict_file, options[:ratio]]
  end

end

class String
  extend Summarize

  def summarize(options = {})
    dict_file, ratio = Summarize.parse_options(options)
    String.send(:summarize, self, dict_file, ratio)
  end

end

class File

  def summarize(options = {})
    self.read.summarize(options)
  end

end