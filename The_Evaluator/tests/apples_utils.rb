require 'json'
require 'linkeddata'
require 'json/ld'
require 'json/ld/preloaded'
require 'linkheader-processor'
require 'addressable'
require 'tempfile'
require 'xmlsimple'
require 'nokogiri'
require 'parseconfig'
require 'rest-client'
require 'cgi'
require 'digest'
require 'open3'
require 'metainspector'
require 'rdf/xsd'
require_relative './swagger.rb'
require_relative './metadata_object.rb'
require_relative './constants.rb'
require_relative './web_utils.rb'

#require 'pry'

class ApplesUtils
        
    @@distillerknown = {}  # global, hash of sha256 keys of message bodies - have they been seen before t/f

    def ApplesUtils::resolve_url(guid, nolinkheaders=false, header=ACCEPT_ALL_HEADER)
        @meta = MetadataObject.new()
        @meta.guidtype = "uri" if @meta.guidtype.nil?
        $stderr.puts "\n\n FETCHING #{guid} #{header}\n\n"
        head, body = fetch(guid, header)
        $stderr.puts "\n\n head #{head.inspect}\n\n"
        
        if !head
            @meta.comments << "WARN: Unable to resolve #{guid} using HTTP Accept header #{header.to_s}.\n"
            return [[], [], @meta]
        end

        @meta.comments << "INFO: following redirection using this header led to the following URL: #{@meta.finalURI.last}.  Using the output from this URL for the next few tests..."
        @meta.full_response << body

        httplinks = ApplesUtils::parse_http_link_headers(head, guid) unless nolinkheaders  # pass guid to check against anchors in linksets
        htmllinks = Hash.new
        HTML_FORMATS['html'].each do |format|
            if head[:content_type] and head[:content_type].match(format)
                htmllinks = ApplesUtils::parse_html_link_elements(body, guid) unless nolinkheaders  # pass guid to check against anchors in linksets
            end
        end
        return [httplinks, htmllinks, @meta]

    end

    
    def ApplesUtils::parse_http_link_headers(headers, anchor)
        # we can be sure that a Link header is a URL
        # code stolen from https://gist.github.com/thesowah/0ca5e1b4b3c61bfe8e13 with a few tweaks
        parsed = Hash.new
        links = headers[:link]
        return [] unless links
        #$stderr.puts links.inspect
        parts = links.split(',')
        #$stderr.puts parts
        
        # Parse each part into a named link
        parsed = ApplesUtils::split_http_link_headers(parts, parsed)
        # $stderr.puts "\n\nPRE-PARSED\n\n #{parsed}"
        parsed = ApplesUtils::check_for_linkset(parsed, anchor)
        return parsed
    end

    def ApplesUtils::split_http_link_headers(parts, parsed)
      parts.each do |part, index|
        section = part.split(';')
        #$stderr.puts section
        next unless section[0]
        link = section[0][/<(.*)>/,1]
        #$stderr.puts url
        next unless section[1]
        type = ""
        sections = Hash.new
        section[1..].each do |s|
            s.strip!
            if m = s.match(/([\w]+?)="?([\w\:\d\.\,\#\-\+\/\s]+)"?/)  # can be rel="cite-as describedby"  --> two relations in one!  or "linkset+json"
                type = m[1]
                value = m[2]
                sections[type.to_sym] = value  # value could hold multiple relation types
            end
        end        
        parsed[link] = sections
      end
      return parsed
    end


    def ApplesUtils::parse_html_link_elements(body, anchor)
        links = Hash.new        
        m = MetaInspector.new("http://example.org", document: body)
        #an array of elements that look like this: [{:rel=>"alternate", :type=>"application/ld+json", :href=>"http://scidata.vitk.lv/dataset/303.jsonld"}]
    
        m.head_links.each do |l|
            link = l[:href]
            next unless link
            links[link] = l
        end
        links = ApplesUtils::check_for_linkset(links, anchor)
        return links
    end



    def ApplesUtils::check_for_linkset(parsed, anchor) # incoming: {"link1" => {"sectiontype1" => value, "sectiontype2" => value2}}
      $stderr.puts "\n\nPARSED\n\n #{parsed}"
      reparsed = Hash.new
      parsed.each do |link,  valhash|
        # $stderr.puts valhash
        next unless valhash[:rel] == 'linkset'
        if valhash[:type] == 'application/linkset+json'
          linksethash = ApplesUtils::processJSONLinkset(link, anchor)
          ApplesUtils::check_for_conflicts(parsed, linksethash)
          $stderr.puts "\n\nlinksethash\n\n #{linksethash}"
          reparsed = parsed.merge(linksethash)
          # $stderr.puts parsed
        elsif valhash[:type] == 'application/linkset'
          linksethash = ApplesUtils::processTextLinkset(link, anchor)
          ApplesUtils::check_for_conflicts(parsed, linksethash)
          $stderr.puts "\n\nlinksethash\n\n #{linksethash}"
          reparsed = parsed.merge(linksethash)
        end
      end
      $stderr.puts "\n\nREPARSED\n\n #{reparsed}"
      return reparsed.any? ? reparsed : parsed
    end


    def ApplesUtils::processJSONLinkset(link, anchor)
      parsed = Hash.new
      headers, linkset = fetch(link,{'Accept' => 'application/linkset+json'})
      $stderr.puts headers.inspect
      $stderr.puts linkset.inspect
      
      return {} unless linkset
      linkset = JSON.parse(linkset)
      linkset['linkset'].each do |ls|
        $stderr.puts ls['anchor']
        $stderr.puts anchor        
        # next unless ls["anchor"] == anchor
        ls["cite-as"].each do |cite|
          cite[:rel] = "cite-as"; cite.delete('rel')
          href = cite["href"]; cite.delete('href')
          cite[:href] = href
          parsed[href] = cite
        end
        ls["describedby"].each do |db|
          db[:rel] = "describedby"; db.delete('rel')
          href = db["href"]
          type = db["type"]
          db[:href] = href; db.delete('href')
          db[:type] = type; db.delete('type')
          parsed[href] = db
        end
        ls["item"].each do |item|
          item[:rel] = "item"; item.delete('rel')
          href = item["href"]
          type = item["type"]
          item[:href] = href; item.delete('href')
          item[:type] = type; item.delete('type')
          parsed[href] = item
        end
      end
      # $stderr.puts parsed
      return parsed
    end

    def ApplesUtils::processTextLinkset(link, anchor)
      parsed = Hash.new
      headers, linkset = fetch(link,{'Accept' => 'application/linkset'})
      # $stderr.puts "headers #{headers.inspect}"
      return {} unless linkset
      links = linkset.scan(/(\<.*?\>[^\<]+)/)  # split on the open angle bracket, which indicates a new link

      links.each do |ls|
        ls = ls.first  # ls is a single element array
        elements = ls.split(';')  # semicolon delimited fields
        # ["<https://w3id.org/a2a-fair-metrics/08-http-describedby-citeas-linkset-txt/>", "anchor=\"https://s11.no/2022/a2a-fair-metrics/08-http-describedby-citeas-linkset-txt/\"", "rel=\"cite-as\""] 
        href = elements.shift  # first element is always the link url
        href = href.match(/\<([^\>]+)\>/)[1]
        linkshash = Hash.new
        elements.each do |e| 
          key, val = e.split('=')
          key.strip!
          val.strip!
          val.delete_prefix!('"').delete_suffix!('"')  # get rid of newlines and start/end quotes
          linkshash[key.to_sym] = val # split on key=val and make key a symbol
        end  
        
        # $stderr.puts "linkshash #{linkshash}\n#{linkshash[:anchor]}\n#{anchor}\n\n"
        # next unless linkshash[:anchor] and linkshash[:anchor] == anchor # eliminate the ones we don't want
        parsed[href] = linkshash
      end
      return parsed
    end

    def ApplesUtils::check_for_conflicts(parsed1, parsed2) # incoming: {"link1" => {"sectiontype1" => value, "sectiontype2" => value2}}
      @meta.comments << "INFO: checking for conflicting cite-as links"
      cite1 = ""
      cite2 = ""
      parsed1.each do |link,  valhash|
        # $stderr.puts valhash
        next unless valhash[:rel] == 'cite-as'
        cite1 = link
      end
      parsed2.each do |link,  valhash|
        # $stderr.puts valhash
        next unless valhash[:rel] == 'cite-as'
        cite2 = link
      end
      if cite1 and cite2 and cite1 != cite2
        @meta.comments << "WARN: Conflicting cite-as links. found conflicting cite-as: #{cite1} versus #{cite2}."
        return true
      end
      @meta.comments << "INFO: No conflicting cite-as links found."
      
      return false

    end


end




    