# TITLE:  FAIR Maturity Indicator Apples_perma-cite-as

## Authors: 
Mark D Wilkinson: 0000-0001-6960-357X

#### Publication Date: 2022-03-21
#### Last Edit: 2022-03-21
#### Accepted: pending


### Maturity Indicator Identifier: Apples_perma-cite-as [https://w3id.org/fair/maturity_indicator/Gen2/Apples_cite-as](https://w3id.org/fair/maturity_indicator/Gen2/Apples_cite-as)

### Maturity Indicator Name:   Headers inclulde cite-as link which is some kind of permanent id

The headers of the landing page should point to the permanent GUID of the record (e.g. its DOI, as an http(s) reference).  This should be accomplished 
using the "cite-as" Link Header type [https://www.rfc-editor.org/rfc/rfc8574.html](https://www.rfc-editor.org/rfc/rfc8574.html) or the equivalent HTML Meta link.
The value of this link should be some form of recognized permanent-id (e.g. a DOI, or a w3id or a handle, or an ark, etc.)

### To which principle does it apply?
F1

### What is being measured?

The reference to the identifier of the data should conform to a permanent id standard

### Why should we measure it?

FAIR expects the identifier of a record should be permanent

### What must be provided for the measurement?
A GUID that resolves (after following all redirects) to the landing page of the record, or some equivalent metadata record.


### How is the measurement executed?
HTTP GET calls, using Accept */* content type, are made on the provided GUID, and any 300-range redirects are followed.  When there are no more redirects, 
the HTTP headers of the last call are examined for the presence of a Link of type "cite-as", and similarly link meta tags in the HTML (if the record is HTML)
are examined for the existence of a cite-as tag.  The value of that tag should conform to
[[......  put the algorithm here.....]]

### What is/are considered valid result(s)?
the presence of a permanent id as the value of a cite as element or header

### For which digital resource(s) is this relevant? (or 'all')
All

### Examples of good practices (that would score well on this assessment)


### Comments
