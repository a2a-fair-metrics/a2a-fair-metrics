require 'json'
require 'rdf'
require 'rdf/json'
require 'rdf/rdfa'
require 'json/ld'
require 'json/ld/preloaded'
require 'rdf/trig'
require 'rdf/raptor'
require 'net/http'
require 'net/https' # for openssl
#require 'uri'
require 'addressable'
require 'rdf/turtle'
require 'sparql'
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
#require 'pry'

class ApplesUtils
    # config = ParseConfig.new('config.conf')
    
    # @extruct_command = config['extruct']['command'] if config['extruct'] && config['extruct']['command'] && !config['extruct']['command'].empty?
    # @extruct_command = "extruct" unless @extruct_command
    # @extruct_command.strip!
    # case @extruct_command
    # when /[&\|\;\`\$\s]/
    #     abort "The Extruct command in the config file appears to be subject to command injection.  I will not continue"
    # when /echo/i
    #     abort "The Extruct command in the config file appears to be subject to command injection.  I will not continue"
    # end
    # ApplesUtils::ExtructCommand = @extruct_command

    # @rdf_command = config['rdf']['command'] if config['rdf'] && config['rdf']['command'] && !config['rdf']['command'].empty?
    # @rdf_command = "rdf" unless @rdf_command
    # @rdf_command.strip
    # case @rdf_command
    # when /[&\|\;\`\$\s]/
    #     abort "The RDF command in the config file appears to be subject to command injection.  I will not continue"
    # when /echo/i
    #     abort "The RDF command in the config file appears to be subject to command injection.  I will not continue"
    # when !(/rdf$/)
    #     abort "this software requires that Kelloggs Distiller tool is used. The distiller command must end in 'rdf'"
    # end
    # ApplesUtils::RDFCommand = @rdf_command

    # @tika_command = config['tika']['command'] if config['tika'] && config['tika']['command'] && !config['tika']['command'].empty?
    # @tika_command = "http://localhost:9998/meta" unless @tika_command
    # ApplesUtils::TikaCommand = @tika_command



    ApplesUtils::AcceptHeader = {'Accept' => 'text/turtle, application/ld+json, application/rdf+xml, text/xhtml+xml, application/n3, application/rdf+n3, application/turtle, application/x-turtle, text/n3, text/turtle, text/rdf+n3, text/rdf+turtle, application/n-triples' }

    ApplesUtils::TEXT_FORMATS = {
        'text' => ['text/plain',],
    }

    ApplesUtils::RDF_FORMATS = {
      'jsonld'  => ['application/ld+json', 'application/vnd.schemaorg.ld+json'],  # NEW FOR DATACITE
      'turtle'  => ['text/turtle','application/n3','application/rdf+n3',
                   'application/turtle', 'application/x-turtle','text/n3','text/turtle',
                   'text/rdf+n3', 'text/rdf+turtle'],
      #'rdfa'    => ['text/xhtml+xml', 'application/xhtml+xml'],
      'rdfxml'  => ['application/rdf+xml'],
      'triples' => ['application/n-triples','application/n-quads', 'application/trig']
    }

    ApplesUtils::XML_FORMATS = {
      'xml' => ['text/xhtml','text/xml',]
    }
    
    ApplesUtils::HTML_FORMATS = {
      'html' => ['text/html','text/xhtml+xml', 'application/xhtml+xml']
    }
    
    ApplesUtils::JSON_FORMATS = {
				'json' => ['application/json',]
    }

    
    ApplesUtils::DATA_PREDICATES = [
        'http://www.w3.org/ns/ldp#contains',
        'http://xmlns.com/foaf/0.1/primaryTopic',
        'http://purl.obolibrary.org/obo/IAO_0000136', # is about
        'http://purl.obolibrary.org/obo/IAO:0000136', # is about (not the valid URL...)
        'https://www.w3.org/ns/ldp#contains',
        'https://xmlns.com/foaf/0.1/primaryTopic',


        # 'http://schema.org/about', # removed for being too general
        'http://schema.org/mainEntity',
        'http://schema.org/codeRepository',
        'http://schema.org/distribution',
        # 'https://schema.org/about', #removed for being too general
        'https://schema.org/mainEntity',
        'https://schema.org/codeRepository',
        'https://schema.org/distribution',

        'http://www.w3.org/ns/dcat#distribution',
        'https://www.w3.org/ns/dcat#distribution',
        'http://www.w3.org/ns/dcat#dataset',
        'https://www.w3.org/ns/dcat#dataset',
        'http://www.w3.org/ns/dcat#downloadURL',
        'https://www.w3.org/ns/dcat#downloadURL',
        'http://www.w3.org/ns/dcat#accessURL',
        'https://www.w3.org/ns/dcat#accessURL',
        
        'http://semanticscience.org/resource/SIO_000332', # is about
        'http://semanticscience.org/resource/is-about', # is about
        'https://semanticscience.org/resource/SIO_000332', # is about
        'https://semanticscience.org/resource/is-about', # is about
        'https://purl.obolibrary.org/obo/IAO_0000136', # is about
        ]

    ApplesUtils::SELF_IDENTIFIER_PREDICATES = [
        'http://purl.org/dc/elements/1.1/identifier',
        'https://purl.org/dc/elements/1.1/identifier',
        'http://purl.org/dc/terms/identifier',
        'http://schema.org/identifier',
        'https://purl.org/dc/terms/identifier',
        'https://schema.org/identifier'
        ]

    ApplesUtils::GUID_TYPES = {'inchi' => Regexp.new(/^\w{14}\-\w{10}\-\w$/),
                        'doi' => Regexp.new(/^10.\d{4,9}\/[-._;()\/:A-Z0-9]+$/i),
                        'handle1' => Regexp.new(/^[^\/]+\/[^\/]+$/i),
                        'handle2' => Regexp.new(/^\d{4,5}\/[-._;()\/:A-Z0-9]+$/i), # legacy style  12345/AGB47A
                        'uri' => Regexp.new(/^\w+:\/?\/?[^\s]+$/)
    }
        
    @@distillerknown = {}  # global, hash of sha256 keys of message bodies - have they been seen before t/f

    # ===================================================================
    # ===================================================================
    # ===================================================================
    # ===================================================================
    # ===================================================================
    # ===================================================================
    # ===================================================================



    def ApplesUtils::resolve_url(guid, nolinkheaders=false, header=ApplesUtils::AcceptHeader)
        meta = MetadataObject.new()
        meta.guidtype = "uri" if meta.guidtype.nil?
        $stderr.puts "\n\n FETCHING #{guid} #{header}\n\n"
        head, body = ApplesUtils::fetch(guid, header, meta)
        if !head
            meta.comments << "WARN: Unable to resolve #{guid} using HTTP Accept header #{header.to_s}.\n"
            return meta
        end
#$stderr.puts head.inspect

        meta.comments << "INFO: following redirection using this header led to the following URL: #{meta.finalURI.last}.  Using the output from this URL for the next few tests..."
        meta.full_response << body

        httplinks = ApplesUtils::parse_http_link_headers(head) unless nolinkheaders
        htmllinks = Hash.new
        ApplesUtils::HTML_FORMATS['html'].each do |format|
            if head[:content_type].match(format)
                htmllinks = ApplesUtils::parse_html_link_elements(body) unless nolinkheaders
            end
        end
        return [httplinks, htmllinks, meta]

    end

    
    def ApplesUtils::parse_http_link_headers(headers)
        # we can be sure that a Link header is a URL
        # code stolen from https://gist.github.com/thesowah/0ca5e1b4b3c61bfe8e13 with a few tweaks

        parsed = Hash.new

        links = headers[:link]
        return [] unless links
#$stderr.puts links.inspect
        parts = links.split(',')
#$stderr.puts parts
        
        # Parse each part into a named link
        parts.each do |part, index|
            section = part.split(';')
            #$stderr.puts section
            next unless section[0]
            link = section[0][/<(.*)>/,1]
            #$stderr.puts url
            next unless section[1]
            reltype = ""
            type = ""
            sections = Hash.new
            section[1..].each do |s|
                s.strip!
                if m = s.match(/([\w]+?)="?([\w\-\/]+)"?/)
                    type = m[1]
                    value = m[2]
                    sections[type.to_sym] = value
                end
            end        
            parsed[link] = sections
        end
        return parsed

    end
  
    def ApplesUtils::parse_html_link_elements(body)
        links = Hash.new        
        m = MetaInspector.new("http://example.org", document: body)
        #an array of elements that look like this: [{:rel=>"alternate", :type=>"application/ld+json", :href=>"http://scidata.vitk.lv/dataset/303.jsonld"}]
    
        m.head_links.each do |l|

            link = l[:href]
            next unless link
            links[link] = l
        end
        return links
    end


    # def ApplesUtils::parse_link_header_element(link)
    #     #[" <https://w3id.org/a2a-fair-metrics/03-http-citeas-only/>;rel=\"cite-as\""]
    #     links = Hash.new
    #     section = part.split(';')
    #     #$stderr.puts section
    #     next unless section[0]
    #     url = section[0][/<(.*)>/,1]
    #     #$stderr.puts url
    #     next unless section[1]
    #     type = ""
    #     sections = Hash.new
    #     section[1..].each do |s|
    #         s.strip!
    #         if m = s.match(/([\w]+?)="?([\w\-]+)"?/)
    #             type = m[1]
    #             val = m[2]
    #             sections[type] = val
    #     end
    #     links[url] = sections
    #     return links

    # end

    def ApplesUtils::fetch(url, headers = ApplesUtils::AcceptHeader, meta=nil)  #we will try to retrieve turtle whenever possible

        $stderr.puts "In fetch routine now.  "
        
        begin
            $stderr.puts "executing call over the Web to #{url.to_s}"
            response = RestClient::Request.execute({
                    method: :get,
                    url: url.to_s,
                    #user: user,
                    #password: pass,
                    headers: headers})
            if meta
                meta.finalURI |= [response.request.url]
            end
            $stderr.puts "There was a response to the call #{url.to_s}"
            return [response.headers, response.body]
        rescue RestClient::ExceptionWithResponse => e
            $stderr.puts "ERROR! #{e.response}"
            meta.comments << "WARN: HTTP error #{e} encountered when trying to resolve #{url.to_s}\n" if meta
            response = false
            return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
        rescue RestClient::Exception => e
            $stderr.puts "ERROR! #{e}"
            meta.comments << "WARN: HTTP error #{e} encountered when trying to resolve #{url.to_s}\n" if meta
            response = false
            return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
        rescue Exception => e
            $stderr.puts "ERROR! #{e}"
            meta.comments << "WARN: HTTP error #{e} encountered when trying to resolve #{url.to_s}\n" if meta
            response = false
            return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
        end		  # you can capture the Exception and do something useful with it!\n",

    end
end


class MetadataObject
    
    attr_accessor :hash  # a hash of metadata
    attr_accessor :graph  # a RDF.rb graph of metadata
    attr_accessor :comments  # an array of comments
    attr_accessor :guidtype  # the type of GUID that was detected
    attr_accessor :full_response  # will be an array of Net::HTTP::Response
    attr_accessor :finalURI  
    def initialize(params = {}) # get a name from the "new" call, or set a default
        
      @hash = Hash.new
      @graph = RDF::Graph.new
      @comments = Array.new
      #@guidtype = "unknown"
      @full_response = Array.new
      @finalURI = Array.new
    end
    
    def merge_hash(hash)
        #$stderr.puts "\n\n\nIncoming Hash #{hash.inspect}"
        self.hash = self.hash.merge(hash)
    end
    
    def merge_rdf(triples)  # incoming list of triples
      self.graph << triples
      return self.graph
    end
  
    def rdf
      return self.graph
    end
    
  end


  class Swagger   
    attr_accessor :debug
    attr_accessor :title  
    attr_accessor :tests_metric
    attr_accessor :description
    attr_accessor :applies_to_principle
    attr_accessor :organization
    attr_accessor :org_url
    attr_accessor :responsible_developer
    attr_accessor :email
    attr_accessor :developer_ORCiD
    attr_accessor :protocol
    attr_accessor :host
    attr_accessor :basePath
    attr_accessor :path
    attr_accessor :response_description
    attr_accessor :schemas
    attr_accessor :comments
    attr_accessor :fairsharing_key_location
    attr_accessor :score
    attr_accessor :testedGUID
      
    def initialize(params = {})
        @debug = params.fetch(:debug, false)
      
      @title = params.fetch(:title, 'unnamed')
      @tests_metric = params.fetch(:tests_metric)
      @description = params.fetch(:description, 'default_description')
      @applies_to_principle = params.fetch(:applies_to_principle, 'some principle')
      @version = params.fetch(:version, "0.1")
      @organization = params.fetch(:organization, 'Some Organization')
      @org_url = params.fetch(:org_url)
      @responsible_develper = params.fetch(:responsible_developer, 'Some Person')
      @email = params.fetch(:email)
      @developer_ORCiD = params.fetch(:developer_ORCiD)
      @host = params.fetch(:host)
      @protocol = params.fetch(:protocol, "https")
      @basePath = params.fetch(:basePath)
      @path = params.fetch(:path)
      @response_description = params.fetch(:response_description)
      @schemas = params.fetch(:schemas, [])
      @comments = params.fetch(:comments, [])
      @fairsharing_key_location = params.fetch(:fairsharing_key_location)
      @score = params.fetch(:score, 0)
      @testedGUID = params.fetch(:testedGUID, "")
      
  
      
    end
    
      
  
    def fairsharing_key 
        return @fairsharing_key_location
    end
    
  
      
    def getSwagger 
                        
  message = <<"EOF_EOF"
  swagger: '2.0'
  info:
   version: '#{@version}'
   title: "#{@title}"
   x-tests_metric: '#{@tests_metric}'
   description: >-
     #{@description}
   x-applies_to_principle: "#{@applies_to_principle}"
   contact:
    x-organization: "#{@organization}"
    url: "#{@org_url}"
    name: '#{@responsible_develper}'
    x-role: "responsible developer"
    email: #{@email}
    x-id: '#{developer_ORCiD}'
  host: #{@host}
  basePath: #{@basePath}
  schemes:
    - #{@protocol}
  paths:
   #{@path}:
    post:
     parameters:
      - name: content
        in: body
        required: true
        schema:
          $ref: '#/definitions/schemas'
     consumes:
       - application/json
     produces:  
       - application/json
     responses:
       "200":
         description: >-
          #{@response_description}
  definitions:
    schemas:
      required:
EOF_EOF
      
  
      
      self.schemas.keys.each do |key|
        message += "     - #{key}\n"
      end
      message += "    properties:\n"
      self.schemas.keys.each do |key|
            message += "        #{key}:\n"
            message += "          type: #{self.schemas[key][0]}\n"
            message += "          description: >-\n"
            message += "            #{self.schemas[key][1]}\n"   
      end
            
      return message
    end
    
    
      
      # A utility function that SHOULD NOT BE CALLED EXTERNALLY
      #
      # @param s - subject node
      # @param p - predicate node
      # @param o - object node
      # @param repo - an RDF::Graph object
      def triplify(s, p, o, repo)
    
        if s.class == String
                s = s.strip
        end
        if p.class == String
                p = p.strip
        end
        if o.class == String
                o = o.strip
        end
        
        unless s.respond_to?('uri')
          
          if s.to_s =~ /^\w+:\/?\/?[^\s]+/
                  s = RDF::URI.new(s.to_s)
          else
            self.debug and $stderr.puts "Subject #{s.to_s} must be a URI-compatible thingy"
            abort "Subject #{s.to_s} must be a URI-compatible thingy"
          end
        end
        
        unless p.respond_to?('uri')
      
          if p.to_s =~ /^\w+:\/?\/?[^\s]+/
                  p = RDF::URI.new(p.to_s)
          else
            self.debug and $stderr.puts "Predicate #{p.to_s} must be a URI-compatible thingy"
            abort "Predicate #{p.to_s} must be a URI-compatible thingy"
          end
        end
    
        unless o.respond_to?('uri')
          if o.to_s =~ /\A\w+:\/?\/?\w[^\s]+/
                  o = RDF::URI.new(o.to_s)
          elsif o.to_s =~ /^\d{4}-[01]\d-[0-3]\dT[0-2]\d:[0-5]\d/
                  o = RDF::Literal.new(o.to_s, :datatype => RDF::XSD.date)
          elsif o.to_s =~ /^[+-]?\d+\.\d+/
                  o = RDF::Literal.new(o.to_s, :datatype => RDF::XSD.float)
          elsif o.to_s =~ /^[+-]?[0-9]+$/
                  o = RDF::Literal.new(o.to_s, :datatype => RDF::XSD.int)
          else
                  o = RDF::Literal.new(o.to_s, :language => :en)
          end
        end
    
        self.debug and $stderr.puts("\n\ninserting #{s.to_s} #{p.to_s} #{o.to_s}\n\n")
        triple = RDF::Statement(s, p, o) 
        repo.insert(triple)
    
        return true
      end
      
    
      # A utility function that SHOULD NOT BE CALLED EXTERNALLY
      #
      # @param s - subject node
      # @param p - predicate node
      # @param o - object node
      # @param repo - an RDF::Graph object
    def Swagger.triplify(s, p, o, repo)
        return triplify(s,p,o,repo)
    end
      
    def addComment(newcomment)		  
        self.comments << newcomment.to_s
        #return self.comments
    end
  
    def createEvaluationResponse
      
      g = RDF::Graph.new
  
      dt = Time.now.iso8601
      uri = self.testedGUID
  
      me = self.protocol + "://" + self.host + "/" + self.basePath + self.path
      
       meURI  ="#{me}##{uri}/result-#{dt}"
       meURI  =Addressable::URI.escape(meURI)
  
      triplify(meURI, "http://www.w3.org/1999/02/22-rdf-syntax-ns#type", "http://fairmetrics.org/resources/metric_evaluation_result", g );
      triplify(meURI, "http://semanticscience.org/resource/SIO_000300", self.score, g )
      triplify(meURI, "http://purl.obolibrary.org/obo/date", dt, g )
      triplify(meURI, "http://schema.org/softwareVersion", VERSION, g )
      triplify(meURI,"http://semanticscience.org/resource/SIO_000332", uri, g)
      
      comments = "no comments received.  "
      
      comments = self.comments.join("\n") if self.comments.size > 0 
      triplify(meURI, "http://schema.org/comment", comments, g)
      
      return g.dump(:jsonld)
    end	
      
  end
  