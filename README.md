# UntappdAPI

`UntappdAPI` is a Swift package for making requests to the [Untappd API v4](https://untappd.com/api/docs).

This library is designed as a lightweight networking layer:
- it handles request construction and authentication query parameters
- it performs async HTTP requests

## Requirements

- Untappd API credentials (`client_id` and `client_secret`)

## Untappd API setup

Create an app and obtain your credentials from the Untappd developer dashboard:
- `client_id`
- `client_secret`

Reference: [Untappd API docs](https://untappd.com/api/docs)

## Usage

### Create a service instance

```swift
import UntappdAPI

let service = UntappdService(
    clientID: "<CLIENT_ID>",
    clientSecret: "<CLIENT_SECRET>"
)
```
