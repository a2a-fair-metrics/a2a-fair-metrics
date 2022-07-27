class Swagger
  attr_accessor :debug, :title, :tests_metric, :description, :applies_to_principle, :organization, :org_url,
                :responsible_developer, :email, :developer_ORCiD, :protocol, :host, :basePath, :path, :response_description, :schemas, :comments, :fairsharing_key_location, :score, :testedGUID

  def initialize(params = {})
    @debug = params.fetch(:debug, false)

    @title = params.fetch(:title, 'unnamed')
    @tests_metric = params.fetch(:tests_metric)
    @description = params.fetch(:description, 'default_description')
    @applies_to_principle = params.fetch(:applies_to_principle, 'some principle')
    @version = params.fetch(:version, '0.1')
    @organization = params.fetch(:organization, 'Some Organization')
    @org_url = params.fetch(:org_url)
    @responsible_develper = params.fetch(:responsible_developer, 'Some Person')
    @email = params.fetch(:email)
    @developer_ORCiD = params.fetch(:developer_ORCiD)
    @host = params.fetch(:host, 'example.org')
    @protocol = params.fetch(:protocol, 'https')
    @basePath = params.fetch(:basePath, '/test/')
    @path = params.fetch(:path, '/test/')
    @response_description = params.fetch(:response_description)
    @schemas = params.fetch(:schemas, [])
    @comments = params.fetch(:comments, [])
    @fairsharing_key_location = params.fetch(:fairsharing_key_location)
    @score = params.fetch(:score, 0)
    @testedGUID = params.fetch(:testedGUID, '')
  end

  def fairsharing_key
    @fairsharing_key_location
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
     produces:#{'  '}
       - application/json
     responses:
       "200":
         description: >-
          #{@response_description}
  definitions:
    schemas:
      required:
EOF_EOF

    schemas.keys.each do |key|
      message += "     - #{key}\n"
    end
    message += "    properties:\n"
    schemas.keys.each do |key|
      message += "        #{key}:\n"
      message += "          type: #{schemas[key][0]}\n"
      message += "          description: >-\n"
      message += "            #{schemas[key][1]}\n"
    end

    message
  end

  # A utility function that SHOULD NOT BE CALLED EXTERNALLY
  #
  # @param s - subject node
  # @param p - predicate node
  # @param o - object node
  # @param repo - an RDF::Graph object
  def triplify(s, p, o, repo)
    s = s.strip if s.instance_of?(String)
    p = p.strip if p.instance_of?(String)
    o = o.strip if o.instance_of?(String)

    unless s.respond_to?('uri')

      if s.to_s =~ %r{^\w+:/?/?[^\s]+}
        s = RDF::URI.new(s.to_s)
      else
        debug and warn "Subject #{s} must be a URI-compatible thingy"
        abort "Subject #{s} must be a URI-compatible thingy"
      end
    end

    unless p.respond_to?('uri')

      if p.to_s =~ %r{^\w+:/?/?[^\s]+}
        p = RDF::URI.new(p.to_s)
      else
        debug and warn "Predicate #{p} must be a URI-compatible thingy"
        abort "Predicate #{p} must be a URI-compatible thingy"
      end
    end

    unless o.respond_to?('uri')
      o = if o.to_s =~ %r{\A\w+:/?/?\w[^\s]+}
            RDF::URI.new(o.to_s)
          elsif o.to_s =~ /^\d{4}-[01]\d-[0-3]\dT[0-2]\d:[0-5]\d/
            RDF::Literal.new(o.to_s, datatype: RDF::XSD.date)
          elsif o.to_s =~ /^[+-]?\d+\.\d+/
            RDF::Literal.new(o.to_s, datatype: RDF::XSD.float)
          elsif o.to_s =~ /^[+-]?[0-9]+$/
            RDF::Literal.new(o.to_s, datatype: RDF::XSD.int)
          else
            RDF::Literal.new(o.to_s, language: :en)
          end
    end

    debug and warn("\n\ninserting #{s} #{p} #{o}\n\n")
    triple = RDF::Statement(s, p, o)
    repo.insert(triple)

    true
  end

  # A utility function that SHOULD NOT BE CALLED EXTERNALLY
  #
  # @param s - subject node
  # @param p - predicate node
  # @param o - object node
  # @param repo - an RDF::Graph object
  def self.triplify(s, p, o, repo)
    triplify(s, p, o, repo)
  end

  def addComment(newcomment)
    comments << newcomment.to_s
    # return self.comments
  end

  def createEvaluationResponse
    g = RDF::Graph.new

    dt = Time.now.iso8601
    uri = testedGUID

    me = protocol + '://' + host + '/' + basePath + path

    meURI = "#{me}##{uri}/result-#{dt}"
    meURI = Addressable::URI.escape(meURI)

    triplify(meURI, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
             'http://fairmetrics.org/resources/metric_evaluation_result', g)
    triplify(meURI, 'http://semanticscience.org/resource/SIO_000300', score, g)
    triplify(meURI, 'http://purl.obolibrary.org/obo/date', dt, g)
    triplify(meURI, 'http://schema.org/softwareVersion', VERSION, g)
    triplify(meURI, 'http://semanticscience.org/resource/SIO_000332', uri, g)

    comments = 'no comments received.  '

    comments = self.comments.join("\n") if self.comments.size > 0
    triplify(meURI, 'http://schema.org/comment', comments, g)

    g.dump(:jsonld)
  end
end
