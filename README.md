# MovieDB

## Architecture

CleanSwift https://clean-swift.com/

## Layers

- RL - Resource Layer which is responsible for database and networking
- BL - Business layer
- UI - User Interface

## themoviedb.org Api

**Api Key**
`eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzNjBhNjY2ZmU2N2U3NTNmNzExOThhODU4Y2QwYzVlYyIsInN1YiI6IjYxZWFjYjJmYTBiNmI1MDA0NGRjZTk2YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.8lP0ET7okIBmxkb8-0rEC9MH3wCsYnBExEoelkv3FpM`

On the real project OpenApi specification would be used for code generation in order to minimize number of human errors and process automation.

Unfortunately, existing specification isn't done well and have a lot of errors.
https://api.stoplight.io/v1/versions/o74HCHnJvtmZWGdMJ/export/oas.json
