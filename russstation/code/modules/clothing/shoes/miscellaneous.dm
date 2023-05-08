/obj/item/clothing/shoes/cowboy/pink
	name = "pink cowboy boots"
	icon = 'russstation/icons/obj/clothing/shoes.dmi'
	worn_icon = 'russstation/icons/mob/feet.dmi'
	icon_state = "cowboy_pink"

/obj/item/clothing/shoes/cowboy/clown
	name = "clownboy boots"
	icon = 'russstation/icons/obj/clothing/shoes.dmi'
	worn_icon = 'russstation/icons/mob/feet.dmi'
	icon_state = "cowboy_clown"
	slowdown = SHOES_SLOWDOWN+1
	var/enabled_waddle = TRUE

/obj/item/clothing/shoes/cowboy/clown/Initialize()
	. = ..()
	create_storage(storage_type = /datum/storage/pockets/shoes/clown)
	AddComponent(/datum/component/squeak, list('sound/effects/footstep/clownstep1.ogg'=1,'sound/effects/footstep/clownstep2.ogg'=1), 50)

/obj/item/clothing/shoes/cowboy/clown/equipped(mob/living/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_FEET)
		if(enabled_waddle)
			user.AddElement(/datum/element/waddling)
		if(user.mind && user.mind.assigned_role == "Clown")
			user.add_mood_event("clownboy boots", /datum/mood_event/clownshoes)

/obj/item/clothing/shoes/cowboy/clown/dropped(mob/living/user)
	. = ..()
	user.RemoveElement(/datum/element/waddling)
	if(user.mind && user.mind.assigned_role == "Clown")
		user.clear_mood_event("clownboy boots")

/obj/item/clothing/shoes/cowboy/clown/CtrlClick(mob/living/user)
	if(!isliving(user))
		return
	if(user.get_active_held_item() != src)
		to_chat(user, span_warning("You must hold the [src] in your hand to do this!"))
		return
	if(!enabled_waddle)
		to_chat(user, span_notice("You switch off the waddle dampeners!"))
		enabled_waddle = TRUE
	else
		to_chat(user, span_notice("You switch on the waddle dampeners!"))
		enabled_waddle = FALSE
