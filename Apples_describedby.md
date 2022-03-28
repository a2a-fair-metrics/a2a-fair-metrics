# TITLE:  FAIR Maturity Indicator Apples_describedby

## Authors: 
Mark D Wilkinson: 0000-0001-6960-357X

#### Publication Date: 2022-03-21
#### Last Edit: 2022-03-21
#### Accepted: pending


<<<<<<< HEAD
### Maturity Indicator Identifier: ABCDE [https://w3id.org/fair/maturity_indicator/Gen2/Apples_describedby](https://w3id.org/fair/maturity_indicator/Gen2/Apples_describedby)
=======
### Maturity Indicator Identifier: Apples_describedby [https://w3id.org/fair/maturity_indicator/Gen2/Apples_describedby](https://w3id.org/fair/maturity_indicator/Gen2/Apples_describedby)
>>>>>>> fcdd449d7883d9cacf88cb63671ba74169db5baf

### Maturity Indicator Name:   Headers or Link HTML elements include describedby link

<<<<<<< HEAD
The headers of the landing page (HTML or HTTP) should point to metadata.  This should be accomplished 
using the "describedby" Link Header type [https://www.rfc-editor.org/rfc/rfc8574.html](https://www.rfc-editor.org/rfc/rfc8574.html) or the equivalent HTML `link` link.
=======
The landing page should point to one or more metadata records using the `describedby` link.This should be accomplished 
using the `describedby` Link Header type [https://www.rfc-editor.org/rfc/rfc8574.html](https://www.rfc-editor.org/rfc/rfc8574.html) or the equivalent HTML `describedby` link.
The value of this link should be an absolute URL. The link must also have a `type` attribute indicating the MIME type of the Accept headers when resolving the link, that will result in retrieval of the metadata.
>>>>>>> fcdd449d7883d9cacf88cb63671ba74169db5baf

### To which principle does it apply?
F2 - data is described by rich metadata

### What is being measured?

<<<<<<< HEAD
The existence of a reference to the metadata of the data, which should be found in the *describedby* link header, or in the HTML as a link element.

### Why should we measure it?
The FAIR principles require that all data is described by metadata.

### What must be provided for the measurement?
GUID that resolves to a landing page
=======
The existence of a describedby link, absolute URL, and including a type attribute, that resolves

### Why should we measure it?

The ability to discover structured metadata in a predictable manner is core to the 'Apples to apples' signposting approach.  This includes giving 
an agent all of the information it requires to make a successful call for metadata retrieval.

### What must be provided for the measurement?
A GUID that resolves (after following all redirects) to the landing page of a data record, or to a data record that has these link headers.
>>>>>>> fcdd449d7883d9cacf88cb63671ba74169db5baf


### How is the measurement executed?

HTTP GET calls, using Accept */* content type, are made on the provided GUID, and any 300-range redirects are followed.  When there are no more redirects, 
the HTTP headers of the last call are examined for the presence of a `Link` header of `rel="describedby"`, and similarly `<link>` tags in the HTML (if the record is HTML)
are examined for the existence of a `rel="describedby"` link.

### What is/are considered valid result(s)?
<<<<<<< HEAD
the presence of a `describedby` in either headers or HTML

=======
the presence of a full URL and a `type` containing a valid content type
>>>>>>> fcdd449d7883d9cacf88cb63671ba74169db5baf

### For which digital resource(s) is this relevant? (or 'all')
All

### Examples of good practices (that would score well on this assessment)


### Comments
