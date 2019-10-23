/obj/vehicle/ridden/wheelchair/russ
    icon = 'russstation/icons/obj/vehicles.dmi' // redirect icon to our section

/obj/vehicle/ridden/wheelchair/russ/hotrod
    name = "The Hotrod"
    desc = "A rugged display of two-wheeled freedom."
    icon_state = "hotrod"
    armor = list("melee" = 20, "bullet" = 20, "laser" = 20, "energy" = 0, "bomb" = 20, "bio" = 0, "rad" = 0, "fire" = 30, "acid" = 40) // American Engineering
    delay_multiplier = 2 // roughly full running speed

/obj/vehicle/ridden/wheelchair/russ/hotrod/wrench_act(mob/living/user, obj/item/I)
    to_chat(user, "<span class='notice'>You feel deep shame for trying to dismantle such a glorious symbol of freedom</span>")
    return TRUE // Return without dismantling. There isn't a way to build The Hotrod so dismantling it would be a bad time.

/obj/vehicle/ridden/wheelchair/russ/hotrod/handle_rotation_overlayed() //overridden to redefine the icon state
    // largely the same as the implimentation in code/modules/vehicles/wheelchair.dm
	cut_overlays()
	var/image/V = image(icon = icon, icon_state = "hotrod_overlay", layer = FLY_LAYER, dir = src.dir)
	add_overlay(V)
