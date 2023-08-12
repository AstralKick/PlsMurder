local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage.Packages
local Promise = require(Packages.Promise)
local TblUtil = require(Packages.TblUtil)


--@param This is the subcategories for the catalog.
local SubCategories = {"3"}

--local Url = "https://catalog.roproxy.com/v1/search/items/details?Category=3&Subcategory=".. SubCategories[i].. "&Sort=4&Limit=30&CreatorName=%s&cursor=%s"

local Urls = {
    Catalog = "https://catalog.roproxy.com/v1/search/items/details?Category=3&Subcategory=%s&Sort=4&Limit=30&CreatorName=%s&cursor=%s", -- Urls.Catalog:format(subcategory, username, cursor)
    Gamepasses = "https://www.roproxy.com/users/inventory/list-json?assetTypeId=34&cursor=&itemsPerPage=100&pageNumber=%s&userId=%s",
    Likes = "https://games.roproxy.com/v1/games/votes?universeIds=%s"
}

-- Game Id
local GameId = 891852901

local ApiRequests = {}

ApiRequests.__index = ApiRequests

local function MakeHttpRequest(Url: string)
    return Promise.new(function(Resolve, Reject)
        local Request = HttpService:RequestAsync({
        Url = Url,
        Method = "GET",
        })
        
        local RequestLength = Request.Body:len()
        if not Request.Success then
            Reject()
        end
        Request = HttpService:JSONDecode(Request.Body)
        Resolve(Request, RequestLength)
    end)
end


function ApiRequests.new(Player: Player)
    local self = setmetatable({}, ApiRequests)

    self.Player = Player
    self.Gamepasses = {}
    self.TShirts = {}

    return self
end

function ApiRequests:GetItems()
    local Player = self.Player
    for _,Category in ipairs (SubCategories) do
        local Cursor = ""
        local RequestUrl = Urls.Catalog:format(Category, Player.Name, Cursor)

        MakeHttpRequest(RequestUrl):andThen(function(Result)
            self.TShirts = TblUtil.Copy(Result.data, true)
        end):catch(function()
            warn(Player.Name, " HAS NO ITEMS ON CATEGORY ", Category)
        end):await()
    end


    local function RecursiveGamepassCollection(Player: Player)
        local GamepassUrl = Urls.Gamepasses:format(tostring(self.GamepassUrlLength), Player.UserId)
        self.PageNumber = self.PageNumber or 1 
        self.GamepassUrlLength = self.GamepassUrlLength or math.huge

        MakeHttpRequest(GamepassUrl):andThen(function(Result: {["Data"]: {}}, RequestLength: number)
            for i,gamepass in ipairs (Result.Data.Items) do
                if gamepass.Creator.Id ~= Player.UserId then continue end
                self.Gamepasses[#self.Gamepasses+1] = TblUtil.Copy(gamepass, true)
            end

            if RequestLength ~= self.GamepassUrlLength then
                self.GamepassUrlLength = RequestLength
                self.PageNumber += 1
                RecursiveGamepassCollection(Player)
            end

        end):catch(function(err)
            warn(Player.Name, " HAS NO GAMEPASSES")
            warn(err)
        end):await()
    end

    RecursiveGamepassCollection(Player)
end

function ApiRequests:GetLikes()
    local UrlRequest = Urls.Likes:format(tostring(GameId))
    MakeHttpRequest(UrlRequest):andThen(function(Result)
        print(Result)
    end):catch(function()
        warn("Unable to fetch like data")
    end)
end

return ApiRequests