module IsoBsdI18n
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'rails-i18n' do |app|
      IsoBsdI18n::init
    end
  end
end
