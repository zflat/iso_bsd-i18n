require 'i18n'
require_relative 'iso_bsd-i18n/size'

module IsoBsdI18n
  VERSION = '0.1.0'

  def IsoBsdI18n::init
    I18n.load_path << Dir[File.join(File.expand_path(File.dirname(__FILE__) + '/../locales'), '*.yml')]
    I18n.load_path.flatten!
  end

  if defined?(Rails) 
    require 'iso_bsd-i18n/iso_bsd-i18n_initializer.rb'
  else
    IsoBsdI18n::init
  end

end
