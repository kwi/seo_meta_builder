require 'spec_helper'

describe :seo_meat_builder do
  before(:all) do
    I18n.load_path = []
    I18n.reload!
  end
  
  before(:each) do
    @o = SeoMetaTester.new
  end
  
  it "should show page_title when nothing is translated" do
    @o.page_title.should == 'page_title'
  end
  
  it "should show page_description when nothing is translated" do
    @o.page_description.should == 'page_description'
  end

  it "should just load i18n translations test :p" do
    # Add I18n load_path
    I18n.load_path = (I18n.load_path << Dir[File.join(File.dirname(__FILE__), '../locales', '*.yml')]).uniq
    I18n.reload!
    I18n.locale = :en
  end

  it "should show correct default for page_title" do
    @o.page_title.should == 'Default Title'
  end

  it "should show correct default for page_description" do
    @o.page_description.should == 'Default description'
  end
  
  it "should show correct default for page_title with auto id parameters" do
    @o.params = {:controller => :u, :action => :a, :id => 1}
    @o.page_title.should == 'Default Title 1'
  end
  
  it "should show correct default for page_title with auto id parameters in fr" do
    I18n.locale = :fr
    @o.params = {:controller => :u, :action => :a, :id => 1}
    @o.page_title.should == 'Default Title 1 Fr'
  end
  
  it "should show correct default for page_title with auto id and page parameters" do
    I18n.locale = :en
    @o.params = {:controller => :u, :action => :a, :id => 1, :page => 32}
    @o.page_title.should == 'Default Title 1 - 32'
  end
  
  it "should show correct default for page_title with auto id and page parameters in fr" do
    I18n.locale = :fr
    @o.params = {:controller => :u, :action => :a, :id => 1, :page => 32}
    @o.page_title.should == 'Default Title 1 Fr - 32'
  end
  
  it "should show correct page_title with translation done" do
    I18n.locale = :en
    @o.params = {:controller => :users, :action => :index}
    @o.page_title.should == 'Members list'
  end
  
  it "should show correct page_title with parameters" do
    I18n.locale = :en
    @o.params = {:controller => :users, :action => :show}
    @o.set_page_title(:login => 'kwi')
    @o.page_title.should == 'kwi, member of our site'
  end
  
  it "should show correct page_title with parameters in fr" do
    I18n.locale = :fr
    @o.params = {:controller => :users, :action => :show}
    @o.set_page_title(:login => 'kwi')
    @o.page_title.should == 'kwi, membre de notre site'
  end

  it "should show correct ordered parameters" do
    I18n.locale = :en
    @o.params = {:controller => :users, :action => :show}
    @o.set_page_title({:p1 => :p1, :p3 => :p3, :p2 => :p2, :login => 'kwi'}, [:login, :p1, :p2, :p3])
    @o.page_title.should == 'page_title - kwi - p1 - p2 - p3'
  end
  
  it "should show not show parameters if no order is specified" do
    I18n.locale = :en
    @o.params = {:controller => :users, :action => :show}
    @o.set_page_title({:p1 => :p1, :p3 => :p3, :p2 => :p2, :login => 'kwi'}, [:login, :p4, :p3])
    @o.page_title.should == 'Default Title kwi - p3'
  end

  it "should correctly escape parameters" do
    I18n.locale = :fr
    @o.params = {:controller => :users, :action => :show}
    @o.set_page_title(:login => '<script></script>')
    @o.page_title.should == '&lt;script&gt;&lt;/script&gt;, membre de notre site'
  end

end