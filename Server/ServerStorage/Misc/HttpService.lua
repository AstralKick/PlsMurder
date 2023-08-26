local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local HttpService = game:GetService("HttpService")

local RateLimit = 350 -- 300 requests per minute.
local UpdateTimeAllowed = 120

type methods = "POST" | "PUT" | "GET" | "PATCH" 

local http = {}

local CachedResults = {

}

local function ChangeRate()
    RateLimit += 1
end

local function SetAsync(URL: string, Data: {} | string)
    return Promise.new(function(Resolve, Reject)
        if RateLimit == 0 then return Reject("Rate limit exceeded, retrying in 60") end
        RateLimit -= 1
        task.delay(60, ChangeRate)

        local Response = HttpService:RequestAsync{
            Url = URL,
            Method = 'PUT',
            Body = Data
        }

        if Response.Success then
            return Resolve(Response)
        else
            return Reject(Response)
        end
    end)
end

local function GetAsync(URL: string)
    return Promise.new(function(resolve, reject)
        if RateLimit == 0 then return reject("Rate limit exceeded, retrying in 60") end
        if CachedResults[URL] then 
            if os.time() - CachedResults[URL].Time < UpdateTimeAllowed then
                return resolve(CachedResults[URL].Response)
            end
        end
        RateLimit -= 1
        task.delay(60, ChangeRate)

        local Response = HttpService:RequestAsync{
            Url = URL,
            Method = 'GET',
        }

        if Response.Success then
            CachedResults[URL] = {
                Response = Response,
                Time = os.time()
            }
            return resolve(Response)
        else
            return reject(Response)
        end
    end)
end

local function noCacheGetAsync(URL: string)
    return Promise.new(function(resolve, reject)
        if RateLimit == 0 then return reject("Rate limit exceeded, retrying in 60") end
        RateLimit -= 1
        task.delay(60, ChangeRate)

        local Response = HttpService:RequestAsync{
            Url = URL,
            Method = 'GET',
        }

        if Response.Success then
            CachedResults[URL] = {
                Response = Response,
                Time = os.time()
            }
            return resolve(Response)
        else
            return reject(Response)
        end
    end)
end


function http:GetAsync(URL: string, avoidCache: boolean)
    assert(typeof(URL) == "string", "The URL is not a string, so this request has errored.")

    return if not avoidCache then GetAsync(URL) else Promise.retryWithDelay(noCacheGetAsync, 15, 60, URL)
end

function http:SetAsync(URL: string, Data: string | {})
    assert(typeof(URL) == "string", "The URL is not a string, so this request has errored.")

    return SetAsync(URL, Data)
end

return http