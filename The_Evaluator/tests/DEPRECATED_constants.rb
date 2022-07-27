ACCEPT_ALL_HEADER = { 'Accept' => 'text/turtle, application/ld+json, application/rdf+xml, text/xhtml+xml, application/n3, application/rdf+n3, application/turtle, application/x-turtle, text/n3, text/turtle, text/rdf+n3, text/rdf+turtle, application/n-triples' }

TEXT_FORMATS = {
  'text' => ['text/plain']
}

RDF_FORMATS = {
  'jsonld' => ['application/ld+json', 'application/vnd.schemaorg.ld+json'],  # NEW FOR DATACITE
  'turtle' => ['text/turtle', 'application/n3', 'application/rdf+n3',
               'application/turtle', 'application/x-turtle', 'text/n3', 'text/turtle',
               'text/rdf+n3', 'text/rdf+turtle'],
  # 'rdfa'    => ['text/xhtml+xml', 'application/xhtml+xml'],
  'rdfxml' => ['application/rdf+xml'],
  'triples' => ['application/n-triples', 'application/n-quads', 'application/trig']
}

XML_FORMATS = {
  'xml' => ['text/xhtml', 'text/xml']
}

HTML_FORMATS = {
  'html' => ['text/html', 'text/xhtml+xml', 'application/xhtml+xml']
}

JSON_FORMATS = {
  'json' => ['application/json']
}

DATA_PREDICATES = [
  'http://www.w3.org/ns/ldp#contains',
  'http://xmlns.com/foaf/0.1/primaryTopic',
  'http://purl.obolibrary.org/obo/IAO_0000136', # is about
  'http://purl.obolibrary.org/obo/IAO:0000136', # is about (not the valid URL...)
  'https://www.w3.org/ns/ldp#contains',
  'https://xmlns.com/foaf/0.1/primaryTopic',

  'http://schema.org/mainEntity',
  'http://schema.org/codeRepository',
  'http://schema.org/distribution',
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
  'https://purl.obolibrary.org/obo/IAO_0000136' # is about
]

SELF_IDENTIFIER_PREDICATES = [
  'http://purl.org/dc/elements/1.1/identifier',
  'https://purl.org/dc/elements/1.1/identifier',
  'http://purl.org/dc/terms/identifier',
  'http://schema.org/identifier',
  'https://purl.org/dc/terms/identifier',
  'https://schema.org/identifier'
]

GUID_TYPES = { 'inchi' => Regexp.new(/^\w{14}-\w{10}-\w$/),
               'doi' => Regexp.new(%r{^10.\d{4,9}/[-._;()/:A-Z0-9]+$}i),
               'handle1' => Regexp.new(%r{^[^/]+/[^/]+$}i),
               'handle2' => Regexp.new(%r{^\d{4,5}/[-._;()/:A-Z0-9]+$}i), # legacy style  12345/AGB47A
               'uri' => Regexp.new(%r{^\w+:/?/?[^\s]+$}) }

CONFIG = File.exist?('config.conf') ? ParseConfig.new('config.conf') : {}
if CONFIG['extruct'] && CONFIG['extruct']['command'] && !CONFIG['extruct']['command'].empty?
  extruct = config['extruct']['command']
end
extruct = 'extruct' unless @extruct_command
extruct.strip!
case @extruct
when /[&|;`$\s]/
  abort 'The Extruct command in the config file appears to be subject to command injection.  I will not continue'
when /echo/i
  abort 'The Extruct command in the config file appears to be subject to command injection.  I will not continue'
end
EXTRUCT_COMMAND = extruct

rdf_command = CONFIG['rdf']['command'] if CONFIG['rdf'] && CONFIG['rdf']['command'] && !CONFIG['rdf']['command'].empty?
rdf_command = 'rdf' unless @rdf_command
rdf_command.strip
case rdf_command
when /[&|;`$\s]/
  abort 'The RDF command in the config file appears to be subject to command injection.  I will not continue'
when /echo/i
  abort 'The RDF command in the config file appears to be subject to command injection.  I will not continue'
when !(/rdf$/ =~ $_)
  abort "this software requires that Kelloggs Distiller tool is used. The distiller command must end in 'rdf'"
end
RDF_COMMAND = rdf_command

if CONFIG['tika'] && CONFIG['tika']['command'] && !CONFIG['tika']['command'].empty?
  tika_command = CONFIG['tika']['command']
end
tika_command = 'http://localhost:9998/meta' unless @tika_command
TIKA_COMMAND = tika_command
