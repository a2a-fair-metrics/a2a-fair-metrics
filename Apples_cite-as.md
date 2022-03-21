# TITLE:  FAIR Maturity Indicator Apples_cite-as

## Authors: 
Mark D Wilkinson: 0000-0001-6960-357X

#### Publication Date: 2022-03-21
#### Last Edit: 2022-03-21
#### Accepted: pending


### Maturity Indicator Identifier: ABCDE [https://w3id.org/fair/maturity_indicator/Gen2/Apples_cite-as](https://w3id.org/fair/maturity_indicator/Gen2/Apples_cite-as)

### Maturity Indicator Name:   Headers or link elements include cite-as link

The landing page should point to the permanent GUID of the record (e.g. its DOI, as an http(s) reference).  This should be accomplished 
using the "cite-as" Link Header type [https://www.rfc-editor.org/rfc/rfc8574.html](https://www.rfc-editor.org/rfc/rfc8574.html) or the equivalent HTML `link` link.

### To which principle does it apply?
F1

### What is being measured?

The existence of a reference to the identifier of the data, which should be found in the cite-as link header, or in the HTML as a meta element.

### Why should we measure it?
The FAIR principles require that all data is precisely identified with a globally unique identifier.

### What must be provided for the measurement?
A GUID that resolves (after following all redirects) to the landing page of the record, or some equivalent metadata record.


### How is the measurement executed?
HTTP GET calls, using Accept */* content type, are made on the provided GUID, and any 300-range redirects are followed.  When there are no more redirects, 
the HTTP headers of the last call are examined for the presence of a `Link` header of `rel` "cite-as", and similarly `<link>` tags in the HTML (if the record is HTML)
are examined for the existence of a cite-as tag.

### What is/are considered valid result(s)?
the presence of a cite-as in either headers or HTML

### For which digital resource(s) is this relevant? (or 'all')
All

### Examples of good practices (that would score well on this assessment)


### Comments
