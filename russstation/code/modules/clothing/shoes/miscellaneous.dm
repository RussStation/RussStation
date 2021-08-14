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
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/shoes/clown
	var/enabled_waddle = TRUE

/obj/item/clothing/shoes/cowboy/clown/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, list('sound/effects/clownstep1.ogg'=1,'sound/effects/clownstep2.ogg'=1), 50)

/obj/item/clothing/shoes/cowboy/clown/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_FEET)
		if(enabled_waddle)
			user.AddElement(/datum/element/waddling)
		if(user.mind && user.mind.assigned_role == "Clown")
			SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "clownboy boots", /datum/mood_event/clownshoes)

/obj/item/clothing/shoes/cowboy/clown/dropped(mob/user)
	. = ..()
	user.RemoveElement(/datum/element/waddling)
	if(user.mind && user.mind.assigned_role == "Clown")
		SEND_SIGNAL(user, COMSIG_CLEAR_MOOD_EVENT, "clownboy boots")

/obj/item/clothing/shoes/cowboy/clown/CtrlClick(mob/living/user)
	if(!isliving(user))
		return
	if(user.get_active_held_item() != src)
		to_chat(user, "<span class='warning'>You must hold the [src] in your hand to do this!</span>")
		return
	if(!enabled_waddle)
		to_chat(user, "<span class='notice'>You switch off the waddle dampeners!</span>")
		enabled_waddle = TRUE
	else
		to_chat(user, "<span class='notice'>You switch on the waddle dampeners!</span>")
		enabled_waddle = FALSE
