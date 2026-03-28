GLASSJOKER = SMODS.current_mod

-- VALID MODES:
-- "stretch": always scales to fills screen. does not preserve aspect ratio
-- "scale_small": scales up. fits smallest edge (will show border colour)
-- "scale_large": scales up. fits largest edge (will cut off some of image)
-- "center": always sits in center without scaling (will show border colour, or cut off image)
GLASSJOKER.draw_mode = "stretch"
-- all from 0-1
GLASSJOKER.border_colour = { 0., 0., 0., 1. }

local file_data = assert(NFS.newFileData(GLASSJOKER.path.."background.png"),("Image should exist at background.png"))
local tempimagedata = assert(love.image.newImageData(file_data),("Image should be an image?"))
--print ("LTFNI: Successfully loaded " .. fn)
GLASSJOKER.bg_image = (assert(love.graphics.newImage(tempimagedata),("Image should be an image?")))
iw, ih = GLASSJOKER.bg_image:getDimensions() 

GLASSJOKER.draw_background = function ()
    love.graphics.push()
    love.graphics.setColor(GLASSJOKER.border_colour)
    love.graphics.rectangle("fill", 0, 0, 9999, 9999)

    local w, h = love.graphics.getDimensions()

    love.graphics.setColor(1., 1., 1., 1.)
    if GLASSJOKER.draw_mode == "stretch" then
        love.graphics.scale(w / iw, h / ih)
        love.graphics.draw(GLASSJOKER.bg_image)
    end
    if GLASSJOKER.draw_mode == "scale_small" then
        local w_scale = w / iw
        local h_scale = h / ih

        local scale, target = w_scale, "w"
        if w_scale >= h_scale then
            scale, target = h_scale, "h"
        end

        -- calculate offset
        local w_offset = target == "w" and 0 or (w - iw * h_scale) / 2
        local h_offset = target == "h" and 0 or (h - ih * w_scale) / 2

        love.graphics.scale(scale, scale)
        love.graphics.translate(w_offset, h_offset)
        love.graphics.draw(GLASSJOKER.bg_image)
    end
    if GLASSJOKER.draw_mode == "scale_large" then
        local w_scale = w / iw
        local h_scale = h / ih

        local scale, target = w_scale, "w"
        if w_scale <= h_scale then
            scale, target = h_scale, "h"
        end

        -- calculate offset
        local w_offset = target == "w" and 0 or (w - iw * h_scale) / 2
        local h_offset = target == "h" and 0 or (h - ih * w_scale) / 2

        love.graphics.scale(scale, scale)
        love.graphics.translate(w_offset, h_offset)
        love.graphics.draw(GLASSJOKER.bg_image)
    end
    if GLASSJOKER.draw_mode == "center" then
        local w_offset, h_offset = (w - iw) / 2, (h - ih) / 2
        love.graphics.translate(w_offset, h_offset)
        love.graphics.draw(GLASSJOKER.bg_image)
    end
    love.graphics.pop()
end