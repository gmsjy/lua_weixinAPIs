local client = require "client"
--local cjson = require "cjson"

local query = ngx.var.query_string

local function params_to_table(query)
    if not query then
        return nil
    end
    local t = {}
    for k, v in string.gmatch(query, "([^&=]+)=([^&=]+)") do
        t[k] = v
    end
    return t
end

local weixin_client = client:new()


--local url = string.sub(ngx.var.uri,string.find(ngx.var.uri, "%a"),string.len(ngx.var.uri))
local m = ngx.re.match(ngx.var.uri, "[^/].*", "o")
local url = m[0]

local params = params_to_table(ngx.var.query_string)
--ngx.say(type(params))

--for key,value in pairs(params) do
  --  ngx.say("key: " .. tostring(key) .. ", value: " .. tostring(value))
--end

local verb = ngx.var.request_method

local body = ngx.var.request_body
local val , err  = nil,nil

if verb == "GET" then
    val, err = weixin_client:get(url,params)
else
    if verb == "POST" then
        val, err = weixin_client:post(url,params,body)
    else
        ngx.say("The method is wrong. Just use GET or POST")
    end
end


--rbody = cjson.encode(val)

if  err then
    ngx.say(err)
end


if val then
    ngx.say(val)
end
