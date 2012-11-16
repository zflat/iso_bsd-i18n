module IsoBsdI18n
  VERSION = '0.1.0'

  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'rails-i18n' do |app|
      IsoBsdI18n::init
    end
  end
end
