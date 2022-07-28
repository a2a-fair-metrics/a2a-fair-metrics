def extract_warning_ids(warnings:)
    warn_ids = Array.new
    warnings.each do |id, url, msg|
      warn_ids << id 
    end
    warn_ids
end
  
def extract_citeas_hrefs(links:)
    hrefs = Array.new
    links.each do |l|
      hrefs << l.href if l.relation == "cite-as"
    end
    hrefs
end

def extract_describedby_hrefs(links:)
    hrefs = Array.new
    links.each do |l|
      hrefs << l.href if l.relation == "describedby"
    end
    hrefs
end

def extract_describedby_profiles(links:)
  profiles = Array.new
  links.each do |l|
    profiles << l.profile if (l.relation == "describedby" and l.respond_to? 'profile')
  end
  profiles
end

def extract_item_hrefs(links:)
  hrefs = Array.new
  links.each do |l|
    hrefs << l.href if l.relation == "item"
  end
  hrefs
end

def extract_item_types(links:)
  types = Array.new
  links.each do |l|
    types << l.type if(l.relation == "item" and l.respond_to? 'type')
  end
  types
end
