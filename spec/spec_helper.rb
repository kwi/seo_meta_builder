require 'rubygems'
require 'spec'

require 'i18n'
require 'active_support'

require File.dirname(__FILE__) + '/../init.rb'

class SeoMetaTester
  include SeoMetaBuilder
  
  def params=(params)
    @params = params
  end
  
  def params
    @params || {:controller => :controller, :action => :index}
  end
end
