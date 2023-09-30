# Currently: Making room loading

# Log

10:30am - Have got a basic project with Kha running, and rendering from a tilemap. Currently working on a room loader, and have used ascii art to define a bunch of standard rooms, with different shapes, ropes, and exits.

9:05am - Have settled on a tower building/management/defence game. Start with a room on the ground and a minion, buy rooms of strange shapes that snap onto other rooms. Minions generate money, try to steal rooms from neighboring buildings, etc. Minion classes, like in 'Lemmings'. 2D, with Kha.

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