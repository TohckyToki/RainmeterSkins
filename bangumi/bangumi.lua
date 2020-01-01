-- Get Bangumi everyday list
local top = 15
local offset = 25
local width = 250
local height = 18
local left = 20
local website = "https://bgm.tv"

function Initialize()
  -- Bind measure form skin
  measureBangumiInfo = SKIN:GetMeasure("measureBangumiInfo")

  -- Bind meter form skin
  meterBangumi = SKIN:GetMeter("meterBangumi")
end

function Update()
  -- Get html from skin measure
  local html = measureBangumiInfo:GetStringValue()
  if string.len(html) == 0 then
    return
  end
  -- Get main view
  local view = string.match(html, "(<ul.-</ul>)")

  -- Get list
  local arr = string.gmatch(view, "(<li.-</li>)")

  local bangumiList = {}

  for item in arr do
    -- Get background image of bangumi
    local background = (string.match(string.match(item, 'style="(.-)"'), "'(.-)'"))
    -- Get chinese name of bangumi
    local zhNm = (string.match(string.match(item, "(<a.-</a>)"), ">(.+)<"))
    -- Get meta name of bangumi
    local jpNm = (string.match(string.match(item, "(<em.-</em>)", 2), ">(.+)<"))
    -- Get link of bangumi
    local link = (string.match(string.match(item, "(<a.-</a>)"), 'href="(.-)"'))

    -- Check is it has empty name
    if zhNm == nil then
      zhNm = jpNm
    elseif jpNm == nil then
      jpNm = zhNm
    end

    table.insert(bangumiList, {background = background, zhNm = zhNm, jpNm = jpNm, link = link})
  end

  local path = SKIN:GetVariable("PATH")
  local date = SKIN:GetMeasure("measureDate"):GetStringValue()

  local file = io.open(path .. "bangumi.ini", "r")

  local content = file:read("*a")
  file:close()

  local autoText = string.match(content, ";%s%[LastUpdateDate%].+")

  autoText = "; [LastUpdateDate] " .. date .. " [LastUpdateDate]"

  local bangumiMeter = "[meterBangumi[NUM]]"
  bangumiMeter = bangumiMeter .. "\n" .. "Meter=String"
  bangumiMeter = bangumiMeter .. "\n" .. "MeterStyle=styleContent"
  bangumiMeter = bangumiMeter .. "\n" .. "Hidden=1"
  bangumiMeter = bangumiMeter .. "\n" .. "X=[X]"
  bangumiMeter = bangumiMeter .. "\n" .. "Y=[Y]"
  bangumiMeter = bangumiMeter .. "\n" .. "W=[WIDTH]"
  bangumiMeter = bangumiMeter .. "\n" .. "H=[HEIGHT]"
  bangumiMeter = bangumiMeter .. "\n" .. 'Text="[TEXT]"'
  bangumiMeter = bangumiMeter .. "\n" .. 'LeftMouseDownAction="[LEFTDOWNACTION]"'

  for i = 1, #bangumiList do
    local meter = bangumiMeter
    meter = string.gsub(meter, "%[NUM%]", i)
    meter = string.gsub(meter, "%[X%]", left)
    meter = string.gsub(meter, "%[Y%]", top + (offset * i))
    meter = string.gsub(meter, "%[TEXT%]", bangumiList[i].zhNm)
    meter = string.gsub(meter, "%[WIDTH%]", width)
    meter = string.gsub(meter, "%[HEIGHT%]", height)
    meter = string.gsub(meter, "%[LEFTDOWNACTION%]", website..bangumiList[i].link)

    autoText = autoText .. "\n\n" .. meter
  end

  content = string.gsub(content, ";%s%[LastUpdateDate%].+", autoText)

  file = io.open(path .. "bangumi.ini", "w")
  file:write(content)

  file:close()

  SKIN:Bang("!Refresh");
  
end
