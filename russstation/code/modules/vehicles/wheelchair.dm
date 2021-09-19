/obj/vehicle/ridden/wheelchair/russ
	icon = 'russstation/icons/obj/vehicles.dmi' // redirect icon to our section

/obj/vehicle/ridden/wheelchair/russ/hotrod
	name = "The Hotrod"
	desc = "A rugged display of two-wheeled freedom."
	icon_state = "hotrod"
	armor = list(MELEE = 20, BULLET = 20, LASER = 20, ENERGY = 0, BOMB = 20, BIO = 0, RAD = 0, FIRE = 30, ACID = 40) // American Engineering
	delay_multiplier = 2 // roughly full running speed
	overlay_icon = "hotrod_overlay"

/obj/vehicle/ridden/wheelchair/russ/hotrod/wrench_act(mob/living/user, obj/item/I)
	to_chat(user, span_notice("You feel deep shame for trying to dismantle such a glorious symbol of freedom"))
	return TRUE // Return without dismantling. There isn't a way to build The Hotrod so dismantling it would be a bad time.

/obj/vehicle/ridden/wheelchair/russ/sportschair
	name = "Sportschair"
	desc = "A lightweight model wheelchair."
	icon_state = "sportschair"
	armor = list(MELEE = 10, BULLET = 10, LASER = 10, ENERGY = 0, BOMB = 10, BIO = 0, RAD = 0, FIRE = 20, ACID = 30)
	overlay_icon = "sportschair_overlay"
	var/datum/effect_system/spark_spread/sparks
	var/grinding = FALSE
	var/next_crash
	var/instability = 10
