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
      @developer_ORCiD = params.fetch(:developer_ORCiD, "0000-0000-0000-0000")
      @host = params.fetch(:host, "example.org")
      @protocol = params.fetch(:protocol, "https")
      @basePath = params.fetch(:basePath, "fair_tests")
      @path = params.fetch(:path, "unnamed")
      @response_description = params.fetch(:response_description, "undescribed")
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
