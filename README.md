# Vainglossary

Vainglossary is an iOS app that is accompanied by a [backend](https://github.com/FrozenFireStudios/GloryBackend) with the purpose of helping users make better draft decisions. Watching the Spring preseason “Run the Gauntlet” Preseason Invitational we saw Playoff Beard mention wanting to help get casual players to better understand the drafting process and we thought that would be a great use of the match data that the MadGlory API is providing.

The backend pulls matches from the MadGlory API and saves match up data for every pair of characters: how many times they played with and against each other and how often each won. The Vainglossary iOS app takes this data and uses it to show the best recommended pairings and counters to each hero, as well as offer a "Live Draft" option.

In the Live Draft the user can select the different characters that have already been picked in a draft and show them recommendations for the next best picks. It takes the other character's roles and builds into account (to get good balanced teams) it looks at previous match ups to determine which characters go best with the other characters already picked by teammates and which characters have done best against characters picked by other teams.

The Vainglossary also has a tab with a general strategy guide for drafting to help new players get started with understanding the process and how to build good teams.

Future steps for Vainglossary:

The next step would be to allow a user to select their user name and the names of their teammates and have the app also pull match up data directly from the MadGlory API to see which characters each user has the most success with and take this into account during the draft.

We would like to display more information about the characters and show their stats for different builds, as well as show information about the different items that can be bought.

On the data side we would like to look into more advanced data techniques, including machine learning, to find ways to give even better recommendations. It would also be useful to keep track of different character power spikes to determine how aggressive the different comps are and take this into consideration when considering good counters to overall teams instead of just individual characters. We hope that in the future the MadGlory API will support ELO leaderboards for each region, so that we can have the backend automatically update it match up data from the best players in the world, and so that we can show these leaderboards in the iOS app.

# Blitz
[![Blitz](https://raw.githubusercontent.com/FrozenFireStudios/Glory/master/BlitzVideo.png)](https://vimeo.com/210173429)

# Ranked Draft
[![Ranked Draft](https://raw.githubusercontent.com/FrozenFireStudios/Glory/master/RankedDraftVideo.png)](https://vimeo.com/210173450)

# iPhone
![Ranked Draft](https://raw.githubusercontent.com/FrozenFireStudios/Glory/master/DraftGuide.png)
![Ranked Draft](https://raw.githubusercontent.com/FrozenFireStudios/Glory/master/Hero.png)
![Ranked Draft](https://raw.githubusercontent.com/FrozenFireStudios/Glory/master/LiveDraft.png)
![Ranked Draft](https://raw.githubusercontent.com/FrozenFireStudios/Glory/master/GoodLuck.png)
