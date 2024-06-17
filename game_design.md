# NES jam


## Fighters

A fighter has 3 stats: HP, ATK, DEF.
Monsters have an individual set of runes, heroes share a deck of runes.


## Runes

Runes are used to buff/debuff actions and add additional effects.

- Blank : no effect
- Flex : action power +50%
- Poison : action power -25%, applies 1 poison
- Thunder : action power -50%, targets all
- Skull : action power -25%, must be equipped
- Demon :
	- attack -> action power +20% per consumed demon mark
	- defense -> action power -25%, add 1 demon mark
- Angel :
	- attack -> action power +25%, add 1 angel mark
	- defense -> heal 2% HP per consumed angel mark
- Loop : action power -20%, repeats the action


## Fights

On the beginning of a turn:
- The monsters draft runes to fill their slots
- The team draft runes to fill the hand
- Defense points are reduced to 0

The player affects runes from the hand to hero slots, and chooses actions and targets for the heroes.
The hand can be at most of size 6, and each hero has 3 rune slots.

Then actions are resolved: the order is always hero 1, hero 2, monsters from left to right.
Defense actions are resolved first.

Turn example (in order):

fighter    | action | target    | runes
---------- | ------ | --------- | -----
Monster 1  | DEF    | Self 	    | FLEX
Hero 1     | ITEM   | Hero 2	| –
Hero 2     | ATK    | Monster 1	| THUNDER
Monster 2  | ATK    | Hero 1    | POISON, THUNDER

### Actions

- ATK:
	- Inflicts damage equals to the attack stat on the target.
- DEF:
	- Applies defense points on the target (we can shield another ally / an enemy).
	- 1 defense point block 1 attack point.
	- The defense action is resolved before any other actions.
- ITEM:
	- Uses an item on the target.

### Enemy intents

We can see the runes used by the enemies, but we can't see their intent (attack/defense/item).
However, the AI can use the drafted runes to determine enemy actions (e.g. a boss might decide to attack if he has drafted multiple flex runes to make a super attack). 


## Upgrade tree

After buying a perk in the angel or demon branch, the other one becomes unavailable.
`+` at the beginning of the line indicates that all previous perks from this branch must be bought at least once to unlock this perk and the following ones.

### Angel branch

- [2, repeatable] Humility • Unlock 1 angel rune
+ [1, repeatable] Diligence • Improve angel runes (+1% HP heal)
- [0, repeatable] Patience • Decrease attack, Increase HP
- [1, max 5]      Chastity • Reduce skull effect by 5%
+ [0]             Charity • Draw one less rune each turn
+ [3]             Temperance • Double action power if no runes are equipped
- [2, max 5]      Gratitude • Revive once with 10% HP

### Demon branch

- [2, repeatable] Pride • Unlock 1 demon rune
+ [1, repeatable] Lust • Improve demon runes (+5% attack)
+ [0, max 9]      Gluttony • Unlock skull rune, attack boost
- [0, repeatable] Greed • Decrease HP, attack boost
- [3]             Envy • Draw one more rune each turn
+ [4, max 2]      Sloth • Auto shield 5% HP each turn
- [1, max 10]     Wrath • Heal 2% on enemy kill

### Power branch

- [1]             Musculation • Unlock 1 flex rune
+ [1, repeatable] Training • Attack boost
+ [3, max 2]      Voltage • Unlock 1 Thunder rune
- [2, repeatable] Endurance • Flex runes give +5% action power
+ [4]             Strategy • Unlock 1 Loop rune

### Resistance branch

- [1, repeatable] Longevity • HP boost
- [1, repeatable] Immunity • Defense boost
+ [2, repeatable] Simplicity • Blank runes give +10% action power
- [2, max 3]      Barricade • Keep 10% block each turn
+ [3, max 2]      Regeneration • Heal 2% HP at the beginning of each turn


## Items

Items can be affected by the runes. Non trivial interactions are listed after each item.
Action power is witten inside parentheses.

- Potion: Heals (20) HP
	- + poison rune: also cures all poison
- Bomb: Deals (30) damage to all enemies
- Hex: Adds one skull rune to the target deck


## Relics

### Regular relics

- Cross: Redraft hand once in case no angel runes are drafted
- Pentagram: Redraft hand hand once in case no demon runes are drafted
- ???: Adds a skull rune to boss runes
- ???: Poison runes inflict +1 poison

### Boss relics

- ???: Draw one more rune each turn
- ???: Skull runes behaves like flex runes for the team