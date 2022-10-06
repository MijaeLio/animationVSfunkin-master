xoffset = -110
yoffset = 0

function onCreate()
if dadName == 'HeroRed' then
makeAnimatedLuaSprite('animatedicon', 'icons/Red_icon', getProperty('iconP2.x') + xoffset, getProperty('iconP2.y') - 100 + yoffset)
addAnimationByPrefix('animatedicon', 'normal', 'Red_icon_healthy', 9, false)
addAnimationByPrefix('animatedicon', 'losing', 'Red_icon_fucked', 9, false)
setScrollFactor('animatedicon', 0, 0)
setObjectCamera('animatedicon', 'other') -- either is under the health bar or nothing
addLuaSprite('animatedicon', true)
objectPlayAnimation('animatedicon', 'normal', false)
end
end

function onUpdate(elapsed)
if dadName == 'HeroRed' then
setProperty('iconP2.alpha', 0)
if getProperty('health') > 1.6 then
objectPlayAnimation('animatedicon', 'losing', false)
xoffset = -140
yoffset = -40
else
objectPlayAnimation('animatedicon', 'normal', false)
xoffset = -110
yoffset = 0
end
end
setProperty('camOther.zoom', getProperty('camHUD.zoom'))
setProperty('animatedicon.x', getProperty('iconP2.x'))
setProperty('animatedicon.angle', getProperty('iconP2.angle'))
setProperty('animatedicon.x', getProperty('iconP2.x') + xoffset)
setProperty('animatedicon.y', getProperty('iconP2.y') - 85 + yoffset)
setProperty('animatedicon.scale.x', getProperty('iconP2.scale.x') / 2)
setProperty('animatedicon.scale.y', getProperty('iconP2.scale.y') / 2)
end