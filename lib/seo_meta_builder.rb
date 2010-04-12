# encoding: utf-8
# Build localized titles and description for webpages
module SeoMetaBuilder

  # Set title and description at the same time
  def set_page_metas(hash, order = nil)
    set_page_title(hash, order)
    set_page_description(hash, order)
  end

  # Set the page title with an hash of parameters
  def set_page_title(hash, order = nil, type = :title)
    @page_title = page_meta_string_builder(type, hash, order)
  end

  # Set the page description with an hash of parameters
  def set_page_description(hash, order = nil, type = :description)
    @page_description = page_meta_string_builder(type, hash, order)
  end

private
  def page_meta_auto_hash
    hash = {}
    hash[:id] = params[:id] if !params[:id].blank?
    if !params[:page].blank?
      (hash[:page] = params[:page].to_i) rescue nil
    end
    return hash
  end
  
  AutoOrder = [:id, :page]
  
  # Return the default action name to use as scope
  def page_meta_action_name
    case params[:action]
      when 'create'
        :new
      when 'update'
        :edit
      when 'destroy'
        :show
      else
        params[:action]
    end
  end
  
  # Return an escaped value for building metas
  def page_meta_escape_value(val)
    val.to_s.gsub("<", "&lt;").gsub(">", "&gt;")
  end

  # Build a meta string for i18n dependings on parameters
  def page_meta_string_builder(type = :title, hash = {}, order = nil)
    pt = "page_#{type}"
    
    # Build order table
    order = hash.keys if !order
    order.each do |k|
      pt << " - #{k}: %s" if hash[k]
    end

    # Build values table ordered and escaped
    values = []
    order.each do |k|
      # Escape value :
      values << page_meta_escape_value(hash[k]) if hash[k]
    end

    pt = I18n.t(pt, :default => 'no', :scope => :"meta.#{params[:controller]}.#{page_meta_action_name}")
    
    # No translation found
    # So use meta/default translation !
    if pt == 'no'
      pt = "page_#{type}"
      pt << (' - %s' * values.size)
      pt = I18n.t(pt, :default => pt, :scope => :'meta.default')
    end

    begin
      sprintf(pt, *values)
    rescue Exception
      raise 'Mal formed string : ' + pt.to_s + ' | for : ' + values.join(' - ').to_s
    end
  end

public
  def page_title
    @page_title ||= page_meta_string_builder(:title, page_meta_auto_hash, AutoOrder)
  end

  def page_description
    @page_description ||= page_meta_string_builder(:description, page_meta_auto_hash, AutoOrder)
  end
end


# In order to use with rails :
if defined? ActionView
  ActionView::Base.send :include, SeoMetaBuilder
end

if defined? ActionController
  ActionController::Base.send :include, SeoMetaBuilder
end