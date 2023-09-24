# TITLE:  FAIR Maturity Indicator Apples_cite-as

## Authors: 
Robert Huber: 

#### Publication Date: 2022-03-21
#### Last Edit: 2022-03-21
#### Accepted: pending


### Maturity Indicator Identifier: ABCDE [https://w3id.org/fair/maturity_indicator/Apples/Apples_item](https://w3id.org/fair/maturity_indicator/Apples/Apples_item)

### Maturity Indicator Name:   Headers inclulde item link

The headers of the landing page should include actionable (e.g. http(s)) links to data content such as downloadable files or data streams.
This should be accomplished using the "item" Link Header type [https://www.rfc-editor.org/rfc/rfc8574.html](https://www.rfc-editor.org/rfc/rfc8574.html) or the equivalent HTML `link` link.

### To which principle does it apply?
F3

### What is being measured?

The existence of one or more references (links) to a data object, which should be found in one or more item link header, or in the HTML as a link element.
Indication of these link should follow the signposting conventions as defined here: https://signposting.org/conventions/

### Why should we measure it?
The FAIR principles require that links to data are precisely identified within the metadata.

### What must be provided for the measurement?
A GUID that resolves (after following all redirects) to the landing page of the record, or some equivalent metadata record.


### How is the measurement executed?
HTTP GET calls, using `Accept */*` content type, are made on the provided GUID, and any 300-range redirects are followed.  When there are no more redirects, 
the HTTP headers of the last call are examined for the presence of a `Link` header of `rel="item"`, and similarly `<link>` tags in the HTML (if the record is HTML)
are examined for the existence of a `rel="item"` tag. Further, it shall be checked if links are actionable and resolve to a downloadable or streamable data item.

### What is/are considered valid result(s)?
the presence of a item-as in either headers or HTML

### For which digital resource(s) is this relevant? (or 'all')
All

### Examples of good practices (that would score well on this assessment)


### Comments
