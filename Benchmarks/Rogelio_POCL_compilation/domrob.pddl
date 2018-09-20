(define
	(domain HYRULE)
	(:requirements :adl :typing :universal-preconditions)
	(:types 
		character item - actant
		location entity prefab - object
		door entrance - portal
		actant portal - entity
	)
	(:constants )
	(:predicates
		(at ?x - entity ?y - location)
		(has ?x - character ?y - item)
		(leadsto ?x - entrance ?y - location)
		(connected ?x - location ?y - location)
		(closed ?x - entrance)
		(locked ?x - portal)
		(unlocks ?x - item ?y - portal)
		(doorway ?x - location ?y - location)
		(doorbetween ?x - door ?y - location ?z - location)
		(tutorial-has-been-completed)
		(game-has-been-won)
		(player ?x - character)
		(wants-item ?x - character ?y - item)
		(willing-to-give-item ?x - character ?y - item)
		(prefab ?x - object ?y - prefab)
	)

	(:action talk-to
		:parameters (?speaker - character ?hearer - character ?location - location )
		:precondition
			(and
				(player ?speaker)
				(at ?speaker ?location)
				(at ?hearer ?location)
			)
		:effect
			(and
				(player ?speaker)
				(at ?speaker ?location)
				(at ?hearer ?location)
			)
	)

	(:action look-at
		:parameters (?character - character ?entity - entity ?location - location )
		:precondition
			(and
				(at ?character ?location)
				(at ?entity ?location)
			)
		:effect
			(and
				(at ?character ?location)
				(at ?entity ?location)
			)
	)

	(:action open
		:parameters (?character - character ?entrance - entrance ?location - location )
		:precondition
			(and
				(at ?character ?location)
				(at ?entrance ?location)
				(closed ?entrance)
				(not (locked ?entrance))
			)
		:effect
				(not (closed ?entrance))
	)

	(:action close
		:parameters (?character - character ?entrance - entrance ?location - location )
		:precondition
			(and
				(at ?character ?location)
				(at ?entrance ?location)
				(not (closed ?entrance))
				(not (locked ?entrance))
			)
		:effect
				(closed ?entrance)
	)

	(:action pickup
		:parameters (?character - character ?item - item ?location - location )
		:precondition
			(and
				(at ?character ?location)
				(at ?item ?location)
			)
		:effect
			(and
				(not (at ?item ?location))
				(has ?character ?item)
				(willing-to-give-item ?character ?item)
			)
	)

	(:action drop
		:parameters (?character - character ?item - item ?location - location )
		:precondition
			(and
				(at ?character ?location)
				(has ?character ?item)
				(willing-to-give-item ?character ?item)
			)
		:effect
			(and
				(not (has ?character ?item))
				(at ?item ?location)
				(not (willing-to-give-item ?character ?item))
			)
	)

	(:action give
		:parameters (?sender - character ?item - item ?receiver - character ?location - location )
		:precondition
			(and
				(at ?sender ?location)
				(has ?sender ?item)
				(willing-to-give-item ?sender ?item)
				(at ?receiver ?location)
				(wants-item ?receiver ?item)
			)
		:effect
			(and
				(not (has ?sender ?item))
				(not (willing-to-give-item ?sender ?item))
				(not (wants-item ?receiver ?item))
				(has ?receiver ?item)
			)
	)

	(:action move-through-doorway
		:parameters (?character - character ?from - location ?to - location )
		:precondition
			(and
				(at ?character ?from)
				(connected ?from ?to)
				(doorway ?from ?to)
			)
		:effect
			(and
				(not (at ?character ?from))
				(at ?character ?to)
			)
	)

	(:action move-through-door
		:parameters (?character - character ?from - location ?door - door ?to - location )
		:precondition
			(and
				(at ?character ?from)
				(connected ?from ?to)
				(doorbetween ?door ?from ?to)
				(not (locked ?door))
			)
		:effect
			(and
				(not (at ?character ?from))
				(at ?character ?to)
			)
	)

	(:action move-through-entrance
		:parameters (?character - character ?from - location ?entrance - entrance ?to - location )
		:precondition
			(and
				(at ?character ?from)
				(at ?entrance ?from)
				(leadsto ?entrance ?to)
				(not (closed ?entrance))
			)
		:effect
			(and
				(not (at ?character ?from))
				(at ?character ?to)
			)
	)

	(:action unlock-door
		:parameters (?character - character ?key - item ?door - door )
		:precondition
			(and
				(locked ?door)
				(has ?character ?key)
				(unlocks ?key ?door)
			)
		:effect
			(and
				(not (locked ?door))
				(not (has ?character ?key))
			)
	)

	(:action unlock-entrance
		:parameters (?character - character ?key - item ?entrance - entrance ?location - location )
		:precondition
			(and
				(locked ?entrance)
				(has ?character ?key)
				(unlocks ?key ?entrance)
				(at ?character ?location)
				(at ?entrance ?location)
			)
		:effect
			(and
				(not (locked ?entrance))
				(not (has ?character ?key))
			)
	)

	(:action donothing
		:parameters (?character - character )
		:precondition
				(player ?character)
		:effect
				(player ?character)
	)

	(:action win-the-game
		:parameters (?character - character )
		:precondition
				(player ?character)
		:effect
				(game-has-been-won)
	)
)
