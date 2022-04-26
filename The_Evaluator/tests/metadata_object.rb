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
