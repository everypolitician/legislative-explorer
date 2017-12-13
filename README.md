This is a very rough and ready prototype for investigating legislative
information in Wikidata.

This is not meant to be production-ready code, but was put together as a
quick spike by reusing lots of the pre-existing code from
https://github.com/everypolitician/viewer-sinatra, and by embedding lots
of logic for the individual item types directly into the Page classes as
Structs. Ideally these would be factored out to their own classes, or a
standlone gem.

## Running the app

This is a sinatra app, and should run using any `foreman`-like manager.
(Though only tested with https://github.com/chrismytton/shoreman)


