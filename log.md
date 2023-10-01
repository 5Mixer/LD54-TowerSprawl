# Currently: Tile generator machine & camera.

# Log
# Sunday
*8:20pm* - Minions put machined tiles into the boxes. Their prioritisation is kind of dodgy though, and minions are dying machining, despite walking past mushrooms haha. It's hard to optimise all the factors of
- Tasks should go to nearby minions. So it's an optimisation problem where the sum of distances of taken-without-replacement pairs of points from separate sets should be minimised.
- Harvest tasks should go to hungry minions (though all minions should go to storage for food if hungry)

I think I'll try to solve that first dot point. It'll be a slow solution, probably brute forced and exact, but I think it'll look more logical in the game.

*7:55pm* - Basic generator in, with a kind of cool animation on the generated tile, to disambiguate it from the surrounding tiles.

*7:20pm* - Minions now retrieve mushrooms from boxes if they're not doing anything and are hungry. It's quite satisfying to add a couple of boxes, minions, and mushroom farms now. Very satisfying to wrap up the box/mushroom mechanics, at least for now.

There's a few things on my list I haven't got to (lighting, item removal, etc), but I think I need to start incorporating room placement, and perhaps camera movement. Ideas:

- Machine that generates the tiles that build up rooms. Place down room templates, minions have to go down and place tiles.
- Limit to 5 random previewed rooms, placement is free.
- Minions generate money, rooms cost money to buy

I think the first option is my favourite, but if I choose it I'm choosing against other cool stuff I want to implement like lighting (and box UI previews, which would be useful), and it's a gamble if I get it done tonight. Thoughts
- Machine generates either wall or ladder tiles every 10s or so, like mushroom farms. Minions collect it, run it to storage or place it. Not that dissimilar to mushroom behavior. Whether to focus on harvesting or mining/machining (?) could be based on hunger, or availability of materials in box?
- Placement is tricky, minions can't fly to place roof wall tiles, etc. I'd consider a separate minion type, but that's starting to feel a tedious route, I like the idea they're generalists.
  - Perhaps they walk to an exit of the new room, the item is taken from their hands, and added to the in progress room. When the room is no longer in progress, they can walk into it. I think I like this, even though the movement of the tiles from their hands to the wall is magic.

Stuff it, I'm going the route of minions machining and building rooms. Crikey this is a huge project. Goals:
- Tile generator machine by 8:10pm.
- Tile collection by 8:30pm
- New room placement as scaffold by 9pm
- Dropping off tiles to scaffold and building up room by 9:30pm
- Publish by 10pm??? No way but that's the ambition.

*6:35pm* - Minions now store mushrooms in boxes, unless they're hungry and eat them first. Just realised it's so light outside because daylight savings started, hm. Now I think I'll make minions seek boxes with mushrooms in them if they're hungry. I have no idea when this tenuous minion state machine is going to become completely disfunctional, but I'm pretty sure I get closer to that every change. Hopefully it's more fun than frustrating.

*5:20pm* - UI work saps my energy so I went the relatively simple route of a tiny hunger/health bar above minions that decreases over time, and dead just by disappearance for now.

I think I'll allow minions to hold items now. When they harvest a mushroom, they'll hold it, and if they're hungry, eat it, otherwise they'll store it.

*4:45pm* - Lots of bug hunting later and mushroom harvesting is looking pretty good. I created a task system, items register that they have tasks to do, minions that don't have tasks are assigned a task and run to the item to do it. I had some bugs around bidirectional references (tasks to minions, minions to tasks) going out of sync. I knew it was a possibility when I setup the references, it was silly to try anyway. I've resorted to a single direction (minions own a task) and search when necessary - in reality, computers are fast, looping through the full set of minions is hardly going to blow my perf budget.

There's lots to do but I'm not sure where to go. The mushrooms have to have a purpose, so I think I'll add minion hunger, which is sated when they harvest a mushroom. No hunger and they explode. The bed then doesn't have an occupier, which perhaps is fine? I just need to make it obvious that the minion died, the player shouldn't be confused if it happens off screen etc. Maybe minions have names, and when one dies, it leaves a pile of bones that can be hovered over to see the name? Rather macabre but could be informative.

I don't like UI work but yep, think I'm going to add hunger and hunger UI to minions.

*2:35pm* - Have added mushroom farms, with simple growth and three visual variants. Increasingly eager to go wild with a lighting system, but for now harvesting is more important. Once minions harvest mushrooms, they'll just eat/destroy them. Later I'll think about kitchens and food storage. Random idea I had before - newly spawned minions are mini-minions, which don't do anything but eat for a certain duration, to help prevent spamming beds/minions down.

*2:00pm* - Did a huge clean, had a guest over, had lunch, enjoyed the weather for awhile. Back at it now!

*10:25am* - Smooth walking minions in, awesome. Interesting bug where pathfinding would cut corners, as the map position, rounded off from the player position, would jump ahead of where the player appeared. Taking a break for some chores, then I think I'll work on some more entities/items for the minions to operate.

*10:05am* - Bed constraint finally in, and a bug where minions would spawn despite invalid bed placement fixed. On to smooth movement.

*9:40am* - I have a very basic state machine in minions, and added a day/night cycle that wakes them up/puts them to sleep. I'm quite eager to have dynamic lighting, such that exits exposed to the outside are meaningful, and lamps are necessary, but that might not be worth the time. The day/night cycle works by picking out a colour from a gradient in the spritesheet, meaning I could use gimp's gradient tools to setup a nice sunrise/sunset.

Lost a bit of time trying to get the day/night cycle working on linux builds - I've had trouble with using `getPixel()` and `at()` on native targets in the past. Couldn't get it quite right, but I've put compile flags in so that it at least doesn't crash on linux.

Next up, item constraints and smooth walking. Going to time box this to 10:30am; smooth walking at least is not super crucial.

*8:10am* - I'm up, feeling good. Had a look at some wip games on ldjam, some neat ones. Feeling very good about this idea, just need to get as much of this massive scope in as possible. Will add the minion state machine now.

## Saturday
*10:30pm* - All the minions are chasing the cursor now, though they step in tile increments, and if they end up on the same tile they become indistinguishable. Todo list for tomorrow:

- Minion state machine
- Smooth walking minions
- Day/night state
- Constraints on items, they can still float
- Machine that produces gadgets
- Other items/minion mechanics (food etc)
- Item removal (exploding lanterns!)
- Lighting
- Algae growing
- Pretty background etc

*10:10pm* - Pathfinding is in! Took much less time than I anticipated. Biggest gotcha was just equality of `Vector2i`'s; I'd assumed that the equality operator was overriden for value based comparison, but it seems not. Pretty straight forward pathfinding algo, just BFS out, keeping a map that stores the parent position of visited positions, and reversing/following that list back when we find the finish. I originally had in mind some optimisations - I think it'd be possible to pathfind across the high level connections of the rooms, and then find the routes between doors on each step (which could also be optimised to only include necessary points), but performance seems plenty fast at a glance.

I think I'll try making the minions walk the returned path now.

*9pm* - Or maybe not. I think I need to get onto minions, pathfinding with ropes might take awhile.

*8:50pm* - Item placement on the map finally working. That took way longer than expected. Just going to improve position validation, so beds have to be on the floor etc.

*7:20pm* - Added a camera so that the pixel graphics are finally scaled up to look pixelated. That prompted me to scale the UI rooms, which became too big, so I made them have a separate mini-render mode for the UI. All this camera work required a bunch of transformation math frustration, and there goes the hour. It was necessary though. Onto item placement, again!

*6pm* - Mmh, the items are tiny. I might need to make some bigger machines, perhaps 3x2 tiles. Easy to get distracted pieces the room types together, there are some very satisfying combinations. Given the fun of that, I don't want to make rooms too expensive, I'm thinking that you should be placing one every 30s or so. The idea of a huge building, with hundreds of minions and machines sounds entertaining. Still so much to do - minions aren't even moving yet!
 
*5:40pm* - Hah, amusing problem - with an 8x8 character, the items are either quite large compared with the player, or they only occupy a single tile, which sort of defeats the challenge of 'limited space'. That's alright, they can have big beds.

*5:15pm* - Designed a little 8x8 minion. With such a small tileset, there's really not much room for detail, and animations might be minimalist, but I think I can make it work.

*4:50pm* - Took a long break and cooked some food for tonight. I have gotten manual placement of rooms working, and they it checks that a placement is valid before allowing it. Now I'm going to get to placing stuff in rooms - beds, first, I think, which will be where minions rest.

Trying to decide how I'll implement items (enums, or inherited from a base class, etc). Some requirements:
- Items will be larger than a single tile
- Will need to be identifiable for path finding
- Will probably need collisions
- should be destroyable (all at once, not tile by tile)
- will have constraints on where they can be placed (beds can't float, etc)
- may need state

Specific items, in rough order of planned eventual implementation:
- Bed, one per minion. At night (10 seconds, every two minutes) the minions run to their beds. If they can't get to one, they slowly lose health until they perish??
- Kitchen/stove top (converst 1 raw algae to food per second when operated, minions run to kitchen when food below 5, and eat 5 food)
- Algae farm (generates 1 raw algae per second, when harvested)
- Work bench (generates 1 gadget per minute when operated)
- Lantern (illuminates the surrounding area, which does... something?)
- Storage chest (minions put gadgets here)

*12:45am* - Lunch was tasty. I'm reconsidering manual room placement, and the core game loop, or would at least like to put into writing how it would work. I'm thinking there's a UI on the right hand side with stuff you own - rooms, beds, machines, etc. Maybe a panel on the left listing your minions and their attributes. You can drag stuff you own onto the map, and it will let you drop it if it would be put in a valid location. You get stuff by buying it from a UI shop (not great), or perhaps looting it from a neighboring building, by occupying it with your minions for a period of time.

The alternative has less of a UI, which is always good. There is no shop, you just have stuff in rooms that belong to you. You can take stuff from rooms that don't belong to you, or just occupy rooms that aren't yours to eventually own them.

In both of these cases, it really feels like there's increasing emphasis on the neighboring towers, which isn't great. Neighboring towers imply either multiplayer, (which is doable but limits the games value when you don't have a fellow gamer), or AI based, which is hard to do well.

For now, I'll scrap the idea of neighboring towers, 

*12:20am* - Even though the game probably doesn't need it, to test room placement/door alignment, I made it repeatedly try to place rooms that connect to existing rooms in the map, making it generate neat, though nonsensical levels. Not sure where to go from here. I could go the route of interactivity, so you can manually place rooms if they fit, or putting stuff in the rooms, like machines and the minions. Interactivity is probably less fun, but more important, so will try and get that done after lunch.

*12am* - Rooms are loading well, and can be stamped on the map. I've setup some utilies for seeing if a room fits in a particular position, and getting the list of doors. My short term goal is to generate a random building out of room pieces, such that all the exits align. I've created a `PlacedRoom` class; I may later rename `Room` to `RoomTemplate`.

*10:30am* - Have got a basic project with Kha running, and rendering from a tilemap. Currently working on a room loader, and have used ascii art to define a bunch of standard rooms, with different shapes, ropes, and exits.

*9:05am* - Have settled on a tower building/management/defence game. Start with a room on the ground and a minion, buy rooms of strange shapes that snap onto other rooms. Minions generate money, try to steal rooms from neighboring buildings, etc. Minion classes, like in 'Lemmings'. 2D, with Kha.

# Theme: LIMITED SPACE

- Packing
    - Cars, a room, industrial containers, inventory space
- Parkour
    - Tight tunnels?
- Limited land ownership? Castles, territory, competition for resources, can only own so much at a time?
- Start overpowered, so difficult enemies are easy, but then have to become progressively smaller, meaning you're weaker, and the same enemies feel harder?
- Outerspace:
    - Limited (oxygen) in space? Can this be more than just a timer to get back to your ship?
- Space button is the core input to the game, and there's some limit to it (maximum number of presses per time period, per level)
    - Space heats up engine, too hot and it explodes?
- Limited inventory
    - Card game - limited space in your hand? Have to make trade offs between card types?
- Limited city space
    - Build upwards, very verticle game. Support your minions/people, build bridges to nearby buildings that supply resources. Better gameplay = faster upward growth. Economy management, buy rooms, builders, etc.
    - Can branch horizontally if you're faster than the neighboring buildings. They can branch on top of you, meaning you have to go around.
    - Resources: money, minions, food, electricity, rooms (bedroom, kitchen, workshop, library, etc)
    - Simplifications:
        - Standard room options, with fixed entraces/exits
        - No minions? No minion movement? hmm.
        - No room types? Just build up, compete with neighbors?
        - Factory instead? Power generators, machines (use power, gen $)
    - End states?
        - Winning should ideally be more than just zooming way ahead of competition, boring
        - Losing? Smog/zombies etc rising from the ground?
        - alternatives to idle management game:
            - tower defence?
            - runner game? Smog is rising, control single character that must buy upwards
            - PvAI?
                - Room piracy!
    - Issues
        - Too slow gameplay?
        - Pathfinding timeconsuming impl
    - Name ideas
        - "TOWER SPRAWL"