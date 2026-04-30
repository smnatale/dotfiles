#!/usr/bin/env lua

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function shell_quote(s)
  return "'" .. s:gsub("'", "'\\''") .. "'"
end

local function run(cmd)
  local handle = io.popen(cmd, "r")
  if not handle then
    return nil
  end

  local output = handle:read("*a")
  handle:close()
  return output
end

local function first_line(s)
  return (s:match("([^\r\n]+)") or "")
end

local function error_json(message)
  io.write(string.format('{"error": %q}\n', message))
end

local security_bin = "/usr/bin/security"
local curl_bin = "/usr/bin/curl"

local password_json = trim(run(security_bin .. [[ find-generic-password -w -s "Claude Code-credentials" 2>/dev/null]]) or "")
if password_json == "" then
  local keychain_output = run(security_bin .. [[ find-generic-password -g -s "Claude Code-credentials" 2>&1]]) or ""
  password_json = keychain_output:match('password:%s*"(.*)"%s*$') or ""
end

local access_token = password_json:match('"accessToken"%s*:%s*"([^"]+)"') or ""
access_token = trim(access_token)
if access_token == "" then
  error_json("no keychain access token: " .. first_line(password_json))
  os.exit(1)
end

local usage_cmd = table.concat({
  curl_bin .. " -sS -w '\\n%{http_code}'",
  "-H " .. shell_quote("Authorization: Bearer " .. access_token),
  "-H " .. shell_quote("anthropic-beta: oauth-2025-04-20"),
  "-H " .. shell_quote("Accept: application/json"),
  shell_quote("https://api.anthropic.com/api/oauth/usage"),
}, " ")

local raw_response = trim(run(usage_cmd) or "")
if raw_response == "" then
  error_json("http error")
  os.exit(1)
end

local body, status = raw_response:match("^(.*)\n([0-9][0-9][0-9])$")
if status and status ~= "200" then
  error_json("http " .. status)
  os.exit(1)
end
raw_response = body or raw_response

local five_hour = raw_response:match([["five_hour"%s*:%s*(%b{})]])
local seven_day = raw_response:match([["seven_day"%s*:%s*(%b{})]])
if not five_hour or not seven_day then
  error_json("parse error")
  os.exit(1)
end

local session = tonumber(five_hour:match([["utilization"%s*:%s*([0-9%.]+)]]) or "0") or 0
local weekly = tonumber(seven_day:match([["utilization"%s*:%s*([0-9%.]+)]]) or "0") or 0
local session_reset = five_hour:match([["resets_at"%s*:%s*"([^"]*)"]]) or ""
local weekly_reset = seven_day:match([["resets_at"%s*:%s*"([^"]*)"]]) or ""

local response = string.format(
  '{"session": %d, "weekly": %d, "session_reset": %q, "weekly_reset": %q}',
  math.floor(session),
  math.floor(weekly),
  session_reset,
  weekly_reset
)

if response == "" then
  error_json("http error")
  os.exit(1)
end

io.write(response .. "\n")
