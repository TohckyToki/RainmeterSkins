function Initialize()
end

function Update()
  SKIN:Bang("!SetOption", "meterLoading", "Text", "信息获取中...");
  path = SKIN:GetVariable("PATH");
  date = SKIN:GetMeasure("measureDate"):GetStringValue();

  local file = io.open(path .. "bangumi.ini", "r");
  local content = file:read("*a");
  file:close();

  local lastDate = string.match(content, "%[LastUpdateDate%]%s(.-)%s%[LastUpdateDate%]");

  if date == lastDate then
    meter = SKIN:GetMeter("meterLoading");
    meter:Hide()
    count = 1;
    for item in string.gmatch(content, "%[meterBangumi%d-%]") do
      meter = SKIN:GetMeter("meterBangumi"..count);
      meter:Show();
      count = count + 1;
    end
  else
    SKIN:GetMeasure("measureBangumiInfo"):Enable();
  end
end
