local A = {}

-- Return a valid zettelkasten anchor,
-- composed of yymmddHHMM.
--
-- date can be passed in as a table containing a year, a month, a day, an hour,
-- and a minute key. Returns nil if the date passed in is invalid.
-- If no date is passed in, returns Zettel anchor for current moment.
function A.create_anchor(date)
    local timestamp
    if pcall(function() timestamp = os.time(date) end) then
        return os.date('%y%m%d%H%M', timestamp)
    else
        return nil
    end
end

return A
