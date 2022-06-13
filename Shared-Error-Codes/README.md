# Evaluator Shared Error Codes

One objective of the Apples to Apples initiative is to harmonize the various automated FAIR Evaluators.
Part of this will be an attempt to align how they output their success/error codes.  Here we begin
to collect the various kinds of messages that an Evaluator might emit as it explores a resource.

The codes are associated with a severity:  Failure, Error, Warning, Success

* `Failure` and `Success` should only be emitted as the final output from a report, and are mutually exclusive.  

* `Error` idicates that the activity that was being attempted failed, but this failure may not be fatal (e.g. if there
are fallback paths to try).  

* `Warning` is for situations where the observed behaviour is not appropriate (e.g. not standards-compliant) but the Evaluator was able to proceed anyway.  For example, if the content-type header does not match the content of the message, this may not be a problem for the evaluation.

This is an emergent list, and should not be used by anyone other than a2a participants.
 
