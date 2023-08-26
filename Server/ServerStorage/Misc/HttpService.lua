local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local HttpService = game:GetService("HttpService")

local RateLimit = 300 -- 300 requests per minute.
local UpdateTimeAllowed = 120

type methods = "POST" | "PUT" | "GET" | "PATCH" 

local http = {}

local CachedResults = {

}

local function request(URL: string, Method: methods, headers: {}?, Body: {}?)
    return Promise.new(function(resolve, reject)
        if RateLimit == 0 then return reject("Rate limit exceeded, retrying in 60") end
        
        RateLimit -= 1
        local Response = HttpService:RequestAsync{
            Url = URL,
            Method = Method,
            Headers = headers,
            Body = HttpService:JSONEncode(Body) or "",
        }

        if Response.Success then
            CachedResults[URL] = {
                Response = Response,
                Time = os.time()
            }
            return resolve(Response)
        else
            return reject("Response failure")
        end
    end)
end

function http:RequestAsync(URL: string, Method: methods, headers: {}?, Body: {}?)
    assert(typeof(Method) == "string", "A string hasn't been passed through, so this request will not be run.")
    assert(typeof(URL) == "string", "The URL is not a string, so this request has been errored.")

    return Promise.retryWithDelay(request, 5, 60, URL, Method, headers, Body)
end

return http