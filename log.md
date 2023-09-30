# Currently: interactivity

# Log
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