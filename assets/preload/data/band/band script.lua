function onCreate() --animationprefixes
	addAnimationByPrefix('blue','blue1','blue hit1',24,false)
	addAnimationByPrefix('blue','blue2','blue hit2',24,false)
	addAnimationByPrefix('blue','blue3','blue idle',24,false)
	addAnimationByPrefix('red','red1','red hit1',24,false)
	addAnimationByPrefix('red','red2','red hit2',24,false)
	addAnimationByPrefix('red','red3','red idle',24,false)
	addAnimationByPrefix('green','green1','green hit ',24,false)
	addAnimationByPrefix('green','green2','green idle',24,false)
	addAnimationByPrefix('yellow','yellow1','rightblock',24,false)
	addAnimationByPrefix('yellow','yellow2','leftblock',24,false)
end

function onBeatHit(beat) --beathitplayanims
	if curBeat % 2 == 0 then
		objectPlayAnimation('blue','blue1',true)
		objectPlayAnimation('green','green1',true)
	end
	if curBeat % 1 == 0 then
		objectPlayAnimation('yellow','yellow1',true)
        setProperty('yellow.x',getProperty('yellow.x')+5)
    end
	if curBeat % 2 == 0 then
		objectPlayAnimation('yellow','yellow2',true)
        setProperty('yellow.x',getProperty('yellow.x')-50)

    end
end